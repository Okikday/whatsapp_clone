import 'dart:io';
import 'dart:math';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:ntp/ntp.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';

class UtilitiesFuncs {

  static Future<File?> compressImageTo1MB(File imageFile) async {
    int fileSize = await imageFile.length();
    int targetSize = pow(1024, 2).truncate();

    if (fileSize <= targetSize) return imageFile;

    // Calculating compression ratio
    double compressionRatio = targetSize / fileSize;
    int compressionQuality = (compressionRatio * 100).toInt();

    // Ensuring the compression quality is less than 1MB
    if (compressionQuality < 0) compressionQuality = 1;

    try {
      // Compress the image with the calculated quality
      final XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        "${imageFile.absolute.path}_compressed.jpg",
        quality: compressionQuality,
      );
      if(compressedFile != null){
        return File(compressedFile.path);
      }else{
        return null;
      }
    } catch (e) {
      return null;
    }
  }

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
}