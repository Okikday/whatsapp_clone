import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/themes.dart';
import 'package:whatsapp_clone/features/authentication/views/welcome_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "WhatsApp Clone",
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      home: const WelcomeScreen(),
    );
  }
}