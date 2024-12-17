import 'package:flutter/material.dart';
import 'package:whatsapp_clone/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:whatsapp_clone/general/data/user_data/user_data.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(App(isUserSignedIn: await UserDataFunctions().isUserSignedIn(),));
}
