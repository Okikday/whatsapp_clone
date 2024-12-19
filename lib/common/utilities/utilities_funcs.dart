import 'dart:io';
import 'dart:math';
import 'package:flutter_image_compress/flutter_image_compress.dart';

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
}