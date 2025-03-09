import 'package:uuid/uuid.dart';

class ChatsFunctions {
  static String generateMsgId() => const Uuid().v4();

  static double calculateContentHeight({
    required String text,
    required double lineHeight,
    required double fontSize,
    double width = double.infinity,
  }) {
    // Ensure valid line height (minimum 1.0)
    final adjustedLineHeight = lineHeight < 1.0 ? fontSize : lineHeight;

    // Split the text into lines based on newlines
    final lines = text.split('\n');

    int totalLines = lines.length;

    // Calculate number of wrapped lines if width is provided
    if (width != double.infinity) {
      for (String line in lines) {
        final lineLength = line.length;
        // Assuming an average character width is ~0.5 of fontSize (this can vary)
        final charsPerLine = width ~/ (fontSize * 0.5);

        // Add extra lines for wrapped text
        if (lineLength > charsPerLine) {
          totalLines += (lineLength / charsPerLine).ceil() - 1;
        }
      }
    }

    // Calculate the total height
    return totalLines * adjustedLineHeight;
  }

}