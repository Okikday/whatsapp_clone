import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TimestampedChatMessage extends MultiChildRenderObjectWidget {
  TimestampedChatMessage({
    super.key,
    required this.textSpan,
    required this.sentAt,
    this.expandWidth = false,
    this.internalArgs
  }) : super(children: [sentAt]);

  final TextSpan textSpan;
  final Widget sentAt;
  final bool expandWidth;
  final void Function(double longestLineWidth)? internalArgs;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return TimestampedChatMessageRenderObject(
      textSpan: textSpan,
      textDirection: Directionality.of(context),
      internalArgs: internalArgs,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    TimestampedChatMessageRenderObject renderObject,
  ) {
    renderObject.textSpan = textSpan;
    renderObject.textDirection = Directionality.of(context);
    renderObject.expandWidth = expandWidth;
    renderObject.internalArgs = internalArgs;
  }
}

class TimestampedChatMessageParentData extends ContainerBoxParentData<RenderBox> {}

class TimestampedChatMessageRenderObject extends RenderBox with ContainerRenderObjectMixin<RenderBox, TimestampedChatMessageParentData> {
  TimestampedChatMessageRenderObject({
    required TextSpan textSpan,
    required TextDirection textDirection,
    bool expandWidth = false,
    this.internalArgs,
  }) {
    _textSpan = textSpan;
    _textDirection = textDirection;
    _expandWidth = expandWidth;
    _textPainter = TextPainter(
      text: _textSpan,
      textDirection: _textDirection,
    );
  }
  late void Function(double longestLineWidth)? internalArgs;
  late TextDirection _textDirection;
  late TextSpan _textSpan;
  late TextPainter _textPainter;
  late bool _timestampFitsOnLastLine;
  late double _lineHeight;
  late double _lastMessageLineWidth;
  double _longestLineWidth = 0;
  late int _numMessageLines;
  bool _expandWidth = false;

  TextSpan get textSpan => _textSpan;
  set textSpan(TextSpan val) {
    if (val == _textSpan) return;
    _textSpan = val;
    _textPainter.text = _textSpan;
    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  bool get expandWidth => _expandWidth;
  set expandWidth(bool val) {
    if (val == _expandWidth) return;
    _expandWidth = val;
    markNeedsLayout();
  }

  set textDirection(TextDirection val) {
    if (_textDirection == val) return;
    _textDirection = val;
    _textPainter.textDirection = val;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! TimestampedChatMessageParentData) {
      child.parentData = TimestampedChatMessageParentData();
    }
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.isSemanticBoundary = true;
    config.label = _textSpan.toPlainText();
    config.textDirection = _textDirection;
  }

  @override
  bool hitTestSelf(Offset position) => true;

  void _visitChildren(TextSpan span, void Function(TextSpan span) visitor) {
    visitor(span);
    span.children?.forEach((child) {
      if (child is TextSpan) {
        _visitChildren(child, visitor);
      }
    });
  }

  TextSpan? _getSpanForPosition(TextPosition position) {
    TextSpan? result;
    int index = position.offset;

    void visitor(TextSpan span) {
      if (result != null) return;

      final String text = span.text ?? '';
      if (index >= 0 && index <= text.length) {
        result = span;
      }
      index -= text.length;
    }

    _visitChildren(_textSpan, visitor);
    return result;
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is! PointerDownEvent) {
      return;
    }

    final TextPosition position = _textPainter.getPositionForOffset(event.localPosition);
    final TextSpan? span = _getSpanForPosition(position);

    if (span?.recognizer != null) {
      span!.recognizer!.addPointer(event);
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final sentAtChild = firstChild;
    if (sentAtChild == null) return 0.0;

    _layoutText(double.infinity);
    final timestampWidth = sentAtChild.getMinIntrinsicWidth(height);
    return max(_longestLineWidth, timestampWidth);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final sentAtChild = firstChild;
    if (sentAtChild == null) return 0.0;

    _layoutText(double.infinity);
    final timestampWidth = sentAtChild.getMaxIntrinsicWidth(height);
    return max(_longestLineWidth, timestampWidth);
  }

  @override
  double computeMinIntrinsicHeight(double width) => computeMaxIntrinsicHeight(width);

  @override
  double computeMaxIntrinsicHeight(double width) {
    final sentAtChild = firstChild;
    if (sentAtChild == null) return 0.0;

    final computedSize = _layoutText(width);
    final timestampHeight = sentAtChild.getMaxIntrinsicHeight(width);
    return computedSize.height + (_timestampFitsOnLastLine ? 0 : timestampHeight);
  }

  Size _layoutText(double maxWidth) {
    if (_textSpan.toPlainText().isEmpty) return Size.zero;

    assert(maxWidth > 0, 'You must allocate SOME space to layout a TimestampedChatMessageRenderObject. Received a `maxWidth` value of $maxWidth.');

    final sentAtChild = firstChild;
    if (sentAtChild == null) return Size.zero;

    // First, layout text with unlimited width to get its natural size
    _textPainter.layout(maxWidth: double.infinity);
    final naturalTextSize = _textPainter.size;

    // Then layout with constrained width
    _textPainter.layout(maxWidth: maxWidth);
    final textLines = _textPainter.computeLineMetrics();
    
    _longestLineWidth = 0;
    for (final line in textLines) {
      _longestLineWidth = max(_longestLineWidth, line.width);
    }

    final messageSize = Size(_longestLineWidth, _textPainter.height);
    _lastMessageLineWidth = textLines.last.width;
    _lineHeight = textLines.last.height;
    _numMessageLines = textLines.length;

    // Layout timestamp to get its size
    sentAtChild.layout(BoxConstraints(maxWidth: maxWidth), parentUsesSize: true);
    final timestampSize = sentAtChild.size;

    final lastLineWithTimestamp = _lastMessageLineWidth + timestampSize.width + 8; // 8px spacing
    
    // Check if text needed to wrap
    final didTextWrap = naturalTextSize.width > maxWidth;
    
    if (textLines.length == 1 && !didTextWrap) {
      _timestampFitsOnLastLine = lastLineWithTimestamp < maxWidth;
    } else {
      _timestampFitsOnLastLine = lastLineWithTimestamp < maxWidth;
    }

    late Size computedSize;
    if (!_timestampFitsOnLastLine) {
      computedSize = Size(
        _expandWidth ? maxWidth : _longestLineWidth,
        messageSize.height + timestampSize.height,
      );
    } else {
      if (textLines.length == 1 && !didTextWrap) {
        computedSize = Size(
          _expandWidth ? maxWidth : lastLineWithTimestamp,
          max(messageSize.height, timestampSize.height),
        );
      } else {
        computedSize = Size(
          _expandWidth ? maxWidth : max(_longestLineWidth, lastLineWithTimestamp),
          max(messageSize.height, timestampSize.height),
        );
      }
    }
    return computedSize;
  }

  @override
  void performLayout() {
    final sentAtChild = firstChild;
    if (sentAtChild == null) {
      size = Size.zero;
      return;
    }

    final unconstrainedSize = _layoutText(constraints.maxWidth);
    
    // Use maxWidth if expandWidth is true, otherwise use calculated width
    size = constraints.constrain(
      Size(
        _expandWidth ? constraints.maxWidth : min(unconstrainedSize.width, constraints.maxWidth),
        unconstrainedSize.height,
      ),
    );

    // Position the timestamp widget
    final TimestampedChatMessageParentData timestampParentData =
        sentAtChild.parentData! as TimestampedChatMessageParentData;
    
    if (_timestampFitsOnLastLine) {
      timestampParentData.offset = Offset(
        size.width - sentAtChild.size.width,
        (_lineHeight * (_numMessageLines - 1)),
      );
    } else {
      timestampParentData.offset = Offset(
        size.width - sentAtChild.size.width,
        _lineHeight * _numMessageLines,
      );
    }
    if (internalArgs != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => internalArgs!(size.width));
    }
  }


  @override
  void paint(PaintingContext context, Offset offset) {
    if (_textSpan.toPlainText().isEmpty) return;

    // Paint the text
    _textPainter.paint(context.canvas, offset);

    // Paint the timestamp widget
    final sentAtChild = firstChild;
    if (sentAtChild != null) {
      final TimestampedChatMessageParentData timestampParentData = sentAtChild.parentData! as TimestampedChatMessageParentData;
      context.paintChild(sentAtChild, offset + timestampParentData.offset);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final sentAtChild = firstChild;
    if (sentAtChild != null) {
      final TimestampedChatMessageParentData childParentData = sentAtChild.parentData! as TimestampedChatMessageParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset);
          return sentAtChild.hitTest(result, position: transformed);
        },
      );
      if (isHit) return true;
    }
    return false;
  }
}


// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

// class TimestampedChatMessage extends MultiChildRenderObjectWidget {
//   TimestampedChatMessage({
//     super.key,
//     required this.textSpan,
//     required this.sentAt,
//   }) : super(children: [sentAt]);

//   final TextSpan textSpan;
//   final Widget sentAt;

//   @override
//   RenderObject createRenderObject(BuildContext context) {
//     return TimestampedChatMessageRenderObject(
//       textSpan: textSpan,
//       textDirection: Directionality.of(context),
//     );
//   }

//   @override
//   void updateRenderObject(
//     BuildContext context,
//     TimestampedChatMessageRenderObject renderObject,
//   ) {
//     renderObject.textSpan = textSpan;
//     renderObject.textDirection = Directionality.of(context);
//   }
// }

// class TimestampedChatMessageParentData extends ContainerBoxParentData<RenderBox> {}

// class TimestampedChatMessageRenderObject extends RenderBox with ContainerRenderObjectMixin<RenderBox, TimestampedChatMessageParentData> {
//   TimestampedChatMessageRenderObject({
//     required TextSpan textSpan,
//     required TextDirection textDirection,
//   }) {
//     _textSpan = textSpan;
//     _textDirection = textDirection;
//     _textPainter = TextPainter(
//       text: _textSpan,
//       textDirection: _textDirection,
//     );
//   }

//   late TextDirection _textDirection;
//   late TextSpan _textSpan;
//   late TextPainter _textPainter;
//   late bool _timestampFitsOnLastLine;
//   late double _lineHeight;
//   late double _lastMessageLineWidth;
//   double _longestLineWidth = 0;
//   late int _numMessageLines;

//   TextSpan get textSpan => _textSpan;
//   set textSpan(TextSpan val) {
//     if (val == _textSpan) return;
//     _textSpan = val;
//     _textPainter.text = _textSpan;
//     markNeedsLayout();
//     markNeedsSemanticsUpdate();
//   }

//   set textDirection(TextDirection val) {
//     if (_textDirection == val) return;
//     _textDirection = val;
//     _textPainter.textDirection = val;
//     markNeedsLayout();
//   }

//   @override
//   void setupParentData(RenderBox child) {
//     if (child.parentData is! TimestampedChatMessageParentData) {
//       child.parentData = TimestampedChatMessageParentData();
//     }
//   }

//   @override
//   void describeSemanticsConfiguration(SemanticsConfiguration config) {
//     super.describeSemanticsConfiguration(config);
//     config.isSemanticBoundary = true;
//     config.label = _textSpan.toPlainText();
//     config.textDirection = _textDirection;
//   }

//   @override
//   bool hitTestSelf(Offset position) => true;

//   void _visitChildren(TextSpan span, void Function(TextSpan span) visitor) {
//     visitor(span);
//     span.children?.forEach((child) {
//       if (child is TextSpan) {
//         _visitChildren(child, visitor);
//       }
//     });
//   }

//   TextSpan? _getSpanForPosition(TextPosition position) {
//     TextSpan? result;
//     int index = position.offset;

//     void visitor(TextSpan span) {
//       if (result != null) return;

//       final String text = span.text ?? '';
//       if (index >= 0 && index <= text.length) {
//         result = span;
//       }
//       index -= text.length;
//     }

//     _visitChildren(_textSpan, visitor);
//     return result;
//   }

//   @override
//   void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
//     assert(debugHandleEvent(event, entry));
//     if (event is! PointerDownEvent) {
//       return;
//     }

//     final TextPosition position = _textPainter.getPositionForOffset(event.localPosition);
//     final TextSpan? span = _getSpanForPosition(position);

//     if (span?.recognizer != null) {
//       span!.recognizer!.addPointer(event);
//     }
//   }

//   @override
//   double computeMinIntrinsicWidth(double height) {
//     final sentAtChild = firstChild;
//     if (sentAtChild == null) return 0.0;

//     _layoutText(double.infinity);
//     final timestampWidth = sentAtChild.getMinIntrinsicWidth(height);
//     return max(_longestLineWidth, timestampWidth);
//   }

//   @override
//   double computeMaxIntrinsicWidth(double height) {
//     final sentAtChild = firstChild;
//     if (sentAtChild == null) return 0.0;

//     _layoutText(double.infinity);
//     final timestampWidth = sentAtChild.getMaxIntrinsicWidth(height);
//     return max(_longestLineWidth, timestampWidth);
//   }

//   @override
//   double computeMinIntrinsicHeight(double width) => computeMaxIntrinsicHeight(width);

//   @override
//   double computeMaxIntrinsicHeight(double width) {
//     final sentAtChild = firstChild;
//     if (sentAtChild == null) return 0.0;

//     final computedSize = _layoutText(width);
//     final timestampHeight = sentAtChild.getMaxIntrinsicHeight(width);
//     return computedSize.height + (_timestampFitsOnLastLine ? 0 : timestampHeight);
//   }

//   Size _layoutText(double maxWidth) {
//     if (_textSpan.toPlainText().isEmpty) return Size.zero;

//     assert(maxWidth > 0, 'You must allocate SOME space to layout a TimestampedChatMessageRenderObject. Received a `maxWidth` value of $maxWidth.');

//     final sentAtChild = firstChild;
//     if (sentAtChild == null) return Size.zero;

//     // First, layout text with unlimited width to get its natural size
//     _textPainter.layout(maxWidth: double.infinity);
//     final naturalTextSize = _textPainter.size;

//     // Then layout with constrained width
//     _textPainter.layout(maxWidth: maxWidth);
//     final textLines = _textPainter.computeLineMetrics();

//     _longestLineWidth = 0;
//     for (final line in textLines) {
//       _longestLineWidth = max(_longestLineWidth, line.width);
//     }

//     final messageSize = Size(_longestLineWidth, _textPainter.height);
//     _lastMessageLineWidth = textLines.last.width;
//     _lineHeight = textLines.last.height;
//     _numMessageLines = textLines.length;

//     // Layout timestamp to get its size
//     sentAtChild.layout(BoxConstraints(maxWidth: maxWidth), parentUsesSize: true);
//     final timestampSize = sentAtChild.size;

//     final lastLineWithTimestamp = _lastMessageLineWidth + timestampSize.width + 8; // 8px spacing

//     // Check if text needed to wrap
//     final didTextWrap = naturalTextSize.width > maxWidth;

//     if (textLines.length == 1 && !didTextWrap) {
//       _timestampFitsOnLastLine = lastLineWithTimestamp < maxWidth;
//     } else {
//       _timestampFitsOnLastLine = lastLineWithTimestamp < maxWidth;
//     }

//     late Size computedSize;
//     if (!_timestampFitsOnLastLine) {
//       computedSize = Size(
//         didTextWrap ? maxWidth : messageSize.width,
//         messageSize.height + timestampSize.height,
//       );
//     } else {
//       if (textLines.length == 1 && !didTextWrap) {
//         computedSize = Size(
//           lastLineWithTimestamp,
//           max(messageSize.height, timestampSize.height),
//         );
//       } else {
//         computedSize = Size(
//           maxWidth,
//           max(messageSize.height, timestampSize.height),
//         );
//       }
//     }
//     return computedSize;
//   }

//   @override
//   void performLayout() {
//     final sentAtChild = firstChild;
//     if (sentAtChild == null) {
//       size = Size.zero;
//       return;
//     }

//     final unconstrainedSize = _layoutText(constraints.maxWidth);
//     size = constraints.constrain(
//       Size(unconstrainedSize.width, unconstrainedSize.height),
//     );

//     // Position the timestamp widget
//     final TimestampedChatMessageParentData timestampParentData = sentAtChild.parentData! as TimestampedChatMessageParentData;

//     if (_timestampFitsOnLastLine) {
//       timestampParentData.offset = Offset(
//         size.width - sentAtChild.size.width,
//         (_lineHeight * (_numMessageLines - 1)),
//       );
//     } else {
//       timestampParentData.offset = Offset(
//         size.width - sentAtChild.size.width,
//         _lineHeight * _numMessageLines,
//       );
//     }
//   }

//   @override
//   void paint(PaintingContext context, Offset offset) {
//     if (_textSpan.toPlainText().isEmpty) return;

//     // Paint the text
//     _textPainter.paint(context.canvas, offset);

//     // Paint the timestamp widget
//     final sentAtChild = firstChild;
//     if (sentAtChild != null) {
//       final TimestampedChatMessageParentData timestampParentData = sentAtChild.parentData! as TimestampedChatMessageParentData;
//       context.paintChild(sentAtChild, offset + timestampParentData.offset);
//     }
//   }

//   @override
//   bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
//     final sentAtChild = firstChild;
//     if (sentAtChild != null) {
//       final TimestampedChatMessageParentData childParentData = sentAtChild.parentData! as TimestampedChatMessageParentData;
//       final bool isHit = result.addWithPaintOffset(
//         offset: childParentData.offset,
//         position: position,
//         hitTest: (BoxHitTestResult result, Offset transformed) {
//           assert(transformed == position - childParentData.offset);
//           return sentAtChild.hitTest(result, position: transformed);
//         },
//       );
//       if (isHit) return true;
//     }
//     return false;
//   }
// }


/*

class TimestampedChatMessage extends MultiChildRenderObjectWidget {
  TimestampedChatMessage({
    super.key,
    required this.textSpan,
    required this.sentAt,
    this.expandWidth = false,
  }) : super(children: [sentAt]);

  final TextSpan textSpan;
  final Widget sentAt;
  final bool expandWidth;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return TimestampedChatMessageRenderObject(
      textSpan: textSpan,
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    TimestampedChatMessageRenderObject renderObject,
  ) {
    renderObject.textSpan = textSpan;
    renderObject.textDirection = Directionality.of(context);
    renderObject.expandWidth = expandWidth;
  }
}

class TimestampedChatMessageParentData extends ContainerBoxParentData<RenderBox> {}

class TimestampedChatMessageRenderObject extends RenderBox with ContainerRenderObjectMixin<RenderBox, TimestampedChatMessageParentData> {
  TimestampedChatMessageRenderObject({
    required TextSpan textSpan,
    required TextDirection textDirection,
    bool expandWidth = false,
  }) {
    _textSpan = textSpan;
    _textDirection = textDirection;
    _expandWidth = expandWidth;
    _textPainter = TextPainter(
      text: _textSpan,
      textDirection: _textDirection,
    );
  }

  late TextDirection _textDirection;
  late TextSpan _textSpan;
  late TextPainter _textPainter;
  late bool _timestampFitsOnLastLine;
  late double _lineHeight;
  late double _lastMessageLineWidth;
  double _longestLineWidth = 0;
  late int _numMessageLines;
  bool _expandWidth = false;

  TextSpan get textSpan => _textSpan;
  set textSpan(TextSpan val) {
    if (val == _textSpan) return;
    _textSpan = val;
    _textPainter.text = _textSpan;
    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  bool get expandWidth => _expandWidth;
  set expandWidth(bool val) {
    if (val == _expandWidth) return;
    _expandWidth = val;
    markNeedsLayout();
  }

  set textDirection(TextDirection val) {
    if (_textDirection == val) return;
    _textDirection = val;
    _textPainter.textDirection = val;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! TimestampedChatMessageParentData) {
      child.parentData = TimestampedChatMessageParentData();
    }
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.isSemanticBoundary = true;
    config.label = _textSpan.toPlainText();
    config.textDirection = _textDirection;
  }

  @override
  bool hitTestSelf(Offset position) => true;

  void _visitChildren(TextSpan span, void Function(TextSpan span) visitor) {
    visitor(span);
    span.children?.forEach((child) {
      if (child is TextSpan) {
        _visitChildren(child, visitor);
      }
    });
  }

  TextSpan? _getSpanForPosition(TextPosition position) {
    TextSpan? result;
    int index = position.offset;

    void visitor(TextSpan span) {
      if (result != null) return;

      final String text = span.text ?? '';
      if (index >= 0 && index <= text.length) {
        result = span;
      }
      index -= text.length;
    }

    _visitChildren(_textSpan, visitor);
    return result;
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is! PointerDownEvent) {
      return;
    }

    final TextPosition position = _textPainter.getPositionForOffset(event.localPosition);
    final TextSpan? span = _getSpanForPosition(position);

    if (span?.recognizer != null) {
      span!.recognizer!.addPointer(event);
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final sentAtChild = firstChild;
    if (sentAtChild == null) return 0.0;

    _layoutText(double.infinity);
    final timestampWidth = sentAtChild.getMinIntrinsicWidth(height);
    return max(_longestLineWidth, timestampWidth);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final sentAtChild = firstChild;
    if (sentAtChild == null) return 0.0;

    _layoutText(double.infinity);
    final timestampWidth = sentAtChild.getMaxIntrinsicWidth(height);
    return max(_longestLineWidth, timestampWidth);
  }

  @override
  double computeMinIntrinsicHeight(double width) => computeMaxIntrinsicHeight(width);

  @override
  double computeMaxIntrinsicHeight(double width) {
    final sentAtChild = firstChild;
    if (sentAtChild == null) return 0.0;

    final computedSize = _layoutText(width);
    final timestampHeight = sentAtChild.getMaxIntrinsicHeight(width);
    return computedSize.height + (_timestampFitsOnLastLine ? 0 : timestampHeight);
  }

  Size _layoutText(double maxWidth) {
    if (_textSpan.toPlainText().isEmpty) return Size.zero;

    assert(maxWidth > 0, 'You must allocate SOME space to layout a TimestampedChatMessageRenderObject. Received a `maxWidth` value of $maxWidth.');

    final sentAtChild = firstChild;
    if (sentAtChild == null) return Size.zero;

    // First, layout text with unlimited width to get its natural size
    _textPainter.layout(maxWidth: double.infinity);
    final naturalTextSize = _textPainter.size;

    // Then layout with constrained width
    _textPainter.layout(maxWidth: maxWidth);
    final textLines = _textPainter.computeLineMetrics();
    
    _longestLineWidth = 0;
    for (final line in textLines) {
      _longestLineWidth = max(_longestLineWidth, line.width);
    }

    final messageSize = Size(_longestLineWidth, _textPainter.height);
    _lastMessageLineWidth = textLines.last.width;
    _lineHeight = textLines.last.height;
    _numMessageLines = textLines.length;

    // Layout timestamp to get its size
    sentAtChild.layout(BoxConstraints(maxWidth: maxWidth), parentUsesSize: true);
    final timestampSize = sentAtChild.size;

    final lastLineWithTimestamp = _lastMessageLineWidth + timestampSize.width + 8; // 8px spacing
    
    // Check if text needed to wrap
    final didTextWrap = naturalTextSize.width > maxWidth;
    
    if (textLines.length == 1 && !didTextWrap) {
      _timestampFitsOnLastLine = lastLineWithTimestamp < maxWidth;
    } else {
      _timestampFitsOnLastLine = lastLineWithTimestamp < maxWidth;
    }

    late Size computedSize;
    if (!_timestampFitsOnLastLine) {
      computedSize = Size(
        _expandWidth ? maxWidth : _longestLineWidth,
        messageSize.height + timestampSize.height,
      );
    } else {
      if (textLines.length == 1 && !didTextWrap) {
        computedSize = Size(
          _expandWidth ? maxWidth : lastLineWithTimestamp,
          max(messageSize.height, timestampSize.height),
        );
      } else {
        computedSize = Size(
          _expandWidth ? maxWidth : max(_longestLineWidth, lastLineWithTimestamp),
          max(messageSize.height, timestampSize.height),
        );
      }
    }
    return computedSize;
  }

  @override
  void performLayout() {
    final sentAtChild = firstChild;
    if (sentAtChild == null) {
      size = Size.zero;
      return;
    }

    final unconstrainedSize = _layoutText(constraints.maxWidth);
    
    // Use maxWidth if expandWidth is true, otherwise use calculated width
    size = constraints.constrain(
      Size(
        _expandWidth ? constraints.maxWidth : min(unconstrainedSize.width, constraints.maxWidth),
        unconstrainedSize.height,
      ),
    );

    // Position the timestamp widget
    final TimestampedChatMessageParentData timestampParentData =
        sentAtChild.parentData! as TimestampedChatMessageParentData;
    
    if (_timestampFitsOnLastLine) {
      timestampParentData.offset = Offset(
        size.width - sentAtChild.size.width,
        (_lineHeight * (_numMessageLines - 1)),
      );
    } else {
      timestampParentData.offset = Offset(
        size.width - sentAtChild.size.width,
        _lineHeight * _numMessageLines,
      );
    }
  }


  @override
  void paint(PaintingContext context, Offset offset) {
    if (_textSpan.toPlainText().isEmpty) return;

    // Paint the text
    _textPainter.paint(context.canvas, offset);

    // Paint the timestamp widget
    final sentAtChild = firstChild;
    if (sentAtChild != null) {
      final TimestampedChatMessageParentData timestampParentData = sentAtChild.parentData! as TimestampedChatMessageParentData;
      context.paintChild(sentAtChild, offset + timestampParentData.offset);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final sentAtChild = firstChild;
    if (sentAtChild != null) {
      final TimestampedChatMessageParentData childParentData = sentAtChild.parentData! as TimestampedChatMessageParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset);
          return sentAtChild.hitTest(result, position: transformed);
        },
      );
      if (isHit) return true;
    }
    return false;
  }
}

*/