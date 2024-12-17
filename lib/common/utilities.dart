import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/images_strings.dart';

class Utilities {
  static ImageProvider? imgProvider({
      File? imgfile,
      String? imgurl,
      required ImageSource imgsrc,
      String defaulAssetImage = ImagesStrings.imgPlaceholder,
    }){
      if(imgfile == null && imgurl == null){
        return AssetImage(defaulAssetImage);
      }else if(imgurl != null && imgsrc == ImageSource.network){
        return NetworkImage(imgurl);
      }else if(imgsrc == ImageSource.file && imgfile != null){
        return FileImage(imgfile);
      }else{
        return null;
      }
    }
}

/// A class representing a result that can be either a success or a failure.
class Result<T> {
  final T? value;
  final String? error;
  final dynamic unavailable;

  /// Private constructor to initialize the [value] and [error].
  const Result._({this.value, this.error, this.unavailable});

  /// Factory constructor for a successful result.
  factory Result.success(T value) {
    return Result._(value: value);
  }

  /// Factory constructor for a failed result.
  factory Result.error(String error) {
    return Result._(error: error);
  }

  factory Result.unavailable(dynamic unavailable){
    return Result._(unavailable: unavailable);
  }

  /// Indicates whether the result is successful.
  bool get isSuccess => value != null;

  /// Indicates whether the result is a failure.
  bool get isError => error != null;

  /// Indicates whether unavailable
  bool get isUnavailable => unavailable != null;
}
