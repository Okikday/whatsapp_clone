import 'dart:math';
import 'package:flutter/material.dart';

/// Enum for bubble nip positions.
enum BubbleNip {
  none,
  leftTop,
  leftCenter,
  leftBottom,
  rightTop,
  rightCenter,
  rightBottom,
}

class BubbleClipper extends CustomClipper<Path> {
  BubbleClipper({
    required this.radius,
    required this.showNip,
    required this.position,
    required this.nipWidth,
    required this.nipHeight,
    required this.nipOffset,
    required this.nipRadius,
    required this.stick,
    required this.padding,
  })  : assert(nipWidth > 0),
        assert(nipHeight > 0),
        assert(nipRadius >= 0 && nipRadius <= nipWidth / 2 && nipRadius <= nipHeight / 2) {
    if (position == BubbleNip.none) return;

    _startOffset = _endOffset = nipWidth;
    final isCenter = position == BubbleNip.leftCenter || position == BubbleNip.rightCenter;
    final k = isCenter ? nipHeight / 2 / nipWidth : nipHeight / nipWidth;
    final a = atan(k);

    _nipCX = isCenter ? sqrt(nipRadius * nipRadius * (1 + 1 / (k * k))) : (nipRadius + sqrt(nipRadius * nipRadius * (1 + k * k))) / k;
    final nipStickOffset = (_nipCX - nipRadius).floorToDouble();
    _nipCX -= nipStickOffset;
    _nipCY = isCenter ? 0 : nipRadius;
    _nipPX = _nipCX - nipRadius * sin(a);
    _nipPY = _nipCY + nipRadius * cos(a);

    _startOffset -= nipStickOffset;
    _endOffset -= nipStickOffset;

    if (stick) {
      _endOffset = 0;
    }
  }

  final Radius radius;
  final bool showNip;
  final BubbleNip position;
  final double nipWidth;
  final double nipHeight;
  final double nipOffset;
  final double nipRadius;
  final bool stick;
  final EdgeInsets padding;

  double _startOffset = 0; // Offsets of the bubble
  double _endOffset = 0;
  double _nipCX = 0; // The center of the circle
  double _nipCY = 0;
  double _nipPX = 0; // The point of contact of the nip with the circle
  double _nipPY = 0;

  @override
  Path getClip(Size size) {
    var radiusX = radius.x;
    var radiusY = radius.y;
    final maxRadiusX = size.width / 2;
    final maxRadiusY = size.height / 2;

    // Adjust radii to fit within bounds.
    if (radiusX > maxRadiusX) {
      radiusY *= maxRadiusX / radiusX;
      radiusX = maxRadiusX;
    }
    if (radiusY > maxRadiusY) {
      radiusX *= maxRadiusY / radiusY;
      radiusY = maxRadiusY;
    }

    var path = Path();

    switch (position) {
      case BubbleNip.leftTop:
      case BubbleNip.leftBottom:
      case BubbleNip.leftCenter:
        path.addRRect(RRect.fromLTRBR(_startOffset, 0, size.width - _endOffset, size.height, radius));
        break;

      case BubbleNip.rightTop:
      case BubbleNip.rightBottom:
      case BubbleNip.rightCenter:
        path.addRRect(RRect.fromLTRBR(_endOffset, 0, size.width - _startOffset, size.height, radius));
        break;

      default:
        path.addRRect(RRect.fromLTRBR(_endOffset, 0, size.width - _endOffset, size.height, radius));
    }

    if (showNip) {
      Path nipPath;
      switch (position) {
        case BubbleNip.leftTop:
          nipPath = Path()
            ..moveTo(_startOffset + radiusX, nipOffset)
            ..lineTo(_startOffset + radiusX, nipOffset + nipHeight)
            ..lineTo(_startOffset, nipOffset + nipHeight);
          if (nipRadius == 0) {
            nipPath.lineTo(0, nipOffset);
          } else {
            nipPath
              ..lineTo(_nipPX, nipOffset + _nipPY)
              ..arcToPoint(
                Offset(_nipCX, nipOffset),
                radius: Radius.circular(nipRadius),
              );
          }
          nipPath.close();
          path = Path.combine(PathOperation.union, path, nipPath);
          break;

        case BubbleNip.leftCenter:
          final cy = nipOffset + size.height / 2;
          final nipHalf = nipHeight / 2;
          nipPath = Path()
            ..moveTo(_startOffset, cy - nipHalf)
            ..lineTo(_startOffset + radiusX, cy - nipHalf)
            ..lineTo(_startOffset + radiusX, cy + nipHalf)
            ..lineTo(_startOffset, cy + nipHalf);
          if (nipRadius == 0) {
            nipPath.lineTo(0, cy);
          } else {
            nipPath
              ..lineTo(_nipPX, cy + _nipPY)
              ..arcToPoint(
                Offset(_nipPX, cy - _nipPY),
                radius: Radius.circular(nipRadius),
              );
          }
          nipPath.close();
          path = Path.combine(PathOperation.union, path, nipPath);
          break;

        case BubbleNip.leftBottom:
          nipPath = Path()
            ..moveTo(_startOffset + radiusX, size.height - nipOffset)
            ..lineTo(_startOffset + radiusX, size.height - nipOffset - nipHeight)
            ..lineTo(_startOffset, size.height - nipOffset - nipHeight);
          if (nipRadius == 0) {
            nipPath.lineTo(0, size.height - nipOffset);
          } else {
            nipPath
              ..lineTo(_nipPX, size.height - nipOffset - _nipPY)
              ..arcToPoint(
                Offset(_nipCX, size.height - nipOffset),
                radius: Radius.circular(nipRadius),
                clockwise: false,
              );
          }
          nipPath.close();
          path = Path.combine(PathOperation.union, path, nipPath);
          break;

        case BubbleNip.rightTop:
          nipPath = Path()
            ..moveTo(size.width - _startOffset - radiusX, nipOffset)
            ..lineTo(size.width - _startOffset - radiusX, nipOffset + nipHeight)
            ..lineTo(size.width - _startOffset, nipOffset + nipHeight);
          if (nipRadius == 0) {
            nipPath.lineTo(size.width, nipOffset);
          } else {
            nipPath
              ..lineTo(size.width - _nipPX, nipOffset + _nipPY)
              ..arcToPoint(
                Offset(size.width - _nipCX, nipOffset),
                radius: Radius.circular(nipRadius),
                clockwise: false,
              );
          }
          nipPath.close();
          path = Path.combine(PathOperation.union, path, nipPath);
          break;

        case BubbleNip.rightCenter:
          final cy = nipOffset + size.height / 2;
          final nipHalf = nipHeight / 2;
          nipPath = Path()
            ..moveTo(size.width - _startOffset, cy - nipHalf)
            ..lineTo(size.width - _startOffset - radiusX, cy - nipHalf)
            ..lineTo(size.width - _startOffset - radiusX, cy + nipHalf)
            ..lineTo(size.width - _startOffset, cy + nipHalf);
          if (nipRadius == 0) {
            nipPath.lineTo(size.width, cy);
          } else {
            nipPath
              ..lineTo(size.width - _nipPX, cy + _nipPY)
              ..arcToPoint(
                Offset(size.width - _nipPX, cy - _nipPY),
                radius: Radius.circular(nipRadius),
                clockwise: false,
              );
          }
          nipPath.close();
          path = Path.combine(PathOperation.union, path, nipPath);
          break;

        case BubbleNip.rightBottom:
          nipPath = Path()
            ..moveTo(size.width - _startOffset - radiusX, size.height - nipOffset)
            ..lineTo(size.width - _startOffset - radiusX, size.height - nipOffset - nipHeight)
            ..lineTo(size.width - _startOffset, size.height - nipOffset - nipHeight);
          if (nipRadius == 0) {
            nipPath.lineTo(size.width, size.height - nipOffset);
          } else {
            nipPath
              ..lineTo(size.width - _nipPX, size.height - nipOffset - _nipPY)
              ..arcToPoint(
                Offset(size.width - _nipCX, size.height - nipOffset),
                radius: Radius.circular(nipRadius),
              );
          }
          nipPath.close();
          path = Path.combine(PathOperation.union, path, nipPath);
          break;

        default:
          // Do nothing if BubbleNip.no
          break;
      }
    }

    return path;
  }

  @override
  bool shouldReclip(covariant BubbleClipper oldClipper) =>
      oldClipper.position != position ||
      oldClipper.nipWidth != nipWidth ||
      oldClipper.nipHeight != nipHeight ||
      oldClipper.nipOffset != nipOffset ||
      oldClipper.nipRadius != nipRadius ||
      oldClipper.stick != stick ||
      oldClipper.padding != padding;
}

/// A painter for the Bubble.
class BubblePainter extends CustomPainter {
  BubblePainter({
    required this.clipper,
    required this.color,
    required this.borderColor,
    required this.borderWidth,
    required this.borderUp,
    required this.elevation,
    required this.shadowColor,
  })  : _fillPaint = Paint()
          ..color = color
          ..style = PaintingStyle.fill,
        _strokePaint = (borderWidth == 0 || borderColor == Colors.transparent)
            ? null
            : (Paint()
              ..color = borderColor
              ..strokeWidth = borderWidth
              ..strokeCap = StrokeCap.round
              ..strokeJoin = StrokeJoin.round
              ..style = PaintingStyle.stroke);

  final CustomClipper<Path> clipper;
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final bool borderUp;
  final double elevation;
  final Color shadowColor;

  final Paint _fillPaint;
  final Paint? _strokePaint;

  @override
  void paint(Canvas canvas, Size size) {
    final clip = clipper.getClip(size);

    // Draw shadow if elevation is specified.
    if (elevation > 0) {
      canvas.drawShadow(clip, shadowColor, elevation, false);
    }

    // Draw fill and stroke paths.
    if (borderUp) {
      canvas.drawPath(clip, _fillPaint);
    }
    if (_strokePaint != null) {
      canvas.drawPath(clip, _strokePaint);
    }
    if (!borderUp) {
      canvas.drawPath(clip, _fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant BubblePainter oldDelegate) =>
      oldDelegate.clipper != clipper ||
      oldDelegate.color != color ||
      oldDelegate.borderColor != borderColor ||
      oldDelegate.borderWidth != borderWidth ||
      oldDelegate.borderUp != borderUp ||
      oldDelegate.elevation != elevation ||
      oldDelegate.shadowColor != shadowColor;
}

/// The main Bubble widget.
class CustomBubble extends StatelessWidget {
  const CustomBubble({
    super.key,
    required this.child,
    this.nip = BubbleNip.none,
    this.nipWidth = 10,
    this.nipHeight = 12,
    this.nipOffset = 0,
    this.nipRadius = 2,
    this.stick = true,
    this.padding = const EdgeInsets.all(4),
    this.margin = const EdgeInsets.all(4),
    this.radius = const Radius.circular(10),
    this.color = Colors.white,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
    this.borderUp = false,
    this.elevation = 0,
    this.shadowColor = Colors.black12,
  });

  final Widget child;
  final BubbleNip nip;
  final double nipWidth;
  final double nipHeight;
  final double nipOffset;
  final double nipRadius;
  final bool stick;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Radius radius;
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final bool borderUp;
  final double elevation;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    final bool showNip = nip != BubbleNip.none;
    final EdgeInsets adjustedPadding;

    if (nip == BubbleNip.rightTop || nip == BubbleNip.rightCenter || nip == BubbleNip.rightBottom) {
        adjustedPadding = padding.copyWith(right: padding.right + nipWidth - nipRadius);
      } else if (nip == BubbleNip.leftTop || nip == BubbleNip.leftCenter || nip == BubbleNip.leftBottom) {
        adjustedPadding = padding.copyWith(left: padding.left + nipWidth - nipRadius);
      }else{
        adjustedPadding = padding;
      }

    return Padding(
      padding: margin,
      child: CustomPaint(
        isComplex: true,
        painter: BubblePainter(
          clipper: BubbleClipper(
            radius: radius,
            showNip: showNip,
            position: nip,
            nipWidth: nipWidth,
            nipHeight: nipHeight,
            nipOffset: nipOffset,
            nipRadius: nipRadius,
            stick: stick,
            padding: padding,
          ),
          color: color,
          borderColor: borderColor, 
          borderWidth: borderWidth,
          borderUp: borderUp,
          elevation: elevation,
          shadowColor: shadowColor,
        ),
        child: Padding(
          padding: adjustedPadding,
          child: child,
        ),
      ),
    );
  }
}

