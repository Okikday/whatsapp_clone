import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';
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
      title: "WhatsApp Clone",
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      home:  isUserSignedIn ? RoutesNames.homeView : RoutesNames.welcomeScreen,
    );
  }
}
