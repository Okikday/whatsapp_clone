import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      home:  isUserSignedIn ? RoutesNames.homeView : const WelcomeScreen(),
    );
  }
}


/*

Bubble(
        showNip: true,
        stick: true,
        nip: BubbleNip.leftTop,
        nipHeight: 12, nipWidth: 10,
        nipRadius: 2,
        radius: Radius.circular(12),
        child: CustomWidgets.text(context, "Hello there", fontSize: 20))

*/
