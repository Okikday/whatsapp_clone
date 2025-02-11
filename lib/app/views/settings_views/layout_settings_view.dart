import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/app/controllers/app_layout_settings.dart';

class LayoutSettingsView extends StatelessWidget {
  const LayoutSettingsView({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Layout Settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Obx(() {
            final controller = appLayoutSettings;
            return ListTile(
            title: const Text("Use Low Resolution Chat Bubble"),
            trailing: Switch(
              value: controller.useLowResChatBubble,
              onChanged: (bool value) {
                controller.useLowResChatBubble = value;
              },
            ),
          );
          }),
          // You can add additional ListTiles here for more settings.
        ],
      ),
    );
  }
}
