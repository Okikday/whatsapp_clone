
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whatsapp_clone/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:whatsapp_clone/general/data/hive_data/hive_data.dart';
import 'package:whatsapp_clone/general/data/user_data/user_data.dart';
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
  final bool isUserSignedIn = await UserDataFunctions().isUserSignedIn();

  runApp(App(
    isUserSignedIn: isUserSignedIn,
  ));
  
}
