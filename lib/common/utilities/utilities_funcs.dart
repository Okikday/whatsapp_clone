
import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';

class UtilitiesFuncs {



  // Method to check if system time is correct
  static Future<Result<bool>> isSystemTimeCorrect() async {
    try {
      // Get the current time from an NTP server (trusted external time source)
      DateTime ntpTime = await NTP.now();
      
      // Get the current system time
      DateTime systemTime = DateTime.now();

      // Allow a tolerance window for time differences (e.g., 5 seconds)
      const toleranceThreshold = Duration(seconds: 30);

      // Check if the system time is within the tolerance window of the NTP time
      if ((ntpTime.difference(systemTime)).abs() <= toleranceThreshold) {
        return Result.success(true); // System time is correct
      } else {
        return Result.success(false); // System time is incorrect
      }
    } catch (e) {
      return Result.error('Error checking system time: $e');
    }
  }

  static Size getTextSize(String text, TextStyle style, {int? maxLines, double maxWidth = double.infinity}) => (TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    maxLines: maxLines
  )..layout(maxWidth: maxWidth)).size;

/// Function to calculate text size and number of lines.
static int getTextLines(
  String text,
  TextStyle style, {
  int? maxLines,
  double maxWidth = double.infinity,
}) {
  final textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    maxLines: maxLines,
  )..layout(maxWidth: maxWidth);

  // Get the size of the text
  final textSize = textPainter.size;

  // Calculate the height of a single line
  final lineHeight = style.height != null
      ? style.fontSize! * style.height!
      : style.fontSize!;

  // Calculate the number of lines
  final numLines = (textSize.height / lineHeight).ceil();

  return numLines;
}

}