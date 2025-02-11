import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroine/heroine.dart';
import 'package:whatsapp_clone/features/authentication/views/welcome_screen.dart';
import 'package:whatsapp_clone/common/themes.dart';
import 'package:whatsapp_clone/routes_names.dart';

class App extends StatelessWidget {
  final bool isUserSignedIn;
  const App({
    super.key,
    required this.isUserSignedIn,
  });


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "WhatsApp Clone",
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      navigatorObservers: [HeroineController()],
      defaultTransition: Transition.cupertino,
      home:  isUserSignedIn ? RoutesNames.homeView : const WelcomeScreen(),
    );
  }
}
