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