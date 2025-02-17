import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whatsapp_clone/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';
import 'package:whatsapp_clone/data/app_data.dart';
import 'data/hive_data/hive_data.dart';
import 'data/user_data/user_data.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await Hive.initFlutter();
  await HiveData.initHiveData();
  final hiveData = HiveData();
  await hiveData.initSecureHiveData();


  final UserDataFunctions userDataFunctions = UserDataFunctions();
  final Result userIdResult = await userDataFunctions.getUserId();
  final bool isUserSignedIn;

  if(userIdResult.isSuccess){
    isUserSignedIn = true;
    AppData.userId = userIdResult.value;
  }else{
    isUserSignedIn = false;
  }
  log("isUserSignedIn: $isUserSignedIn");

  runApp(App(
    isUserSignedIn: isUserSignedIn,
  ));


}





