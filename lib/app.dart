import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/themes.dart';
import 'package:whatsapp_clone/features/authentication/views/welcome_screen.dart';
import 'package:whatsapp_clone/features/home/views/home_view.dart';

class App extends StatelessWidget {
  final bool isUserSignedIn;
  const App({super.key, required this.isUserSignedIn});

  @override
  Widget build(BuildContext context) {
    
    return GetMaterialApp(
      title: "WhatsApp Clone",
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      home:  isUserSignedIn ? const HomeView() : const WelcomeScreen(),
    );
  }
}
