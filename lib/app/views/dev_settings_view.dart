import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/app/views/settings_views/animation_settings_view.dart';

class DevSettingsView extends StatelessWidget {
  const DevSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const CustomText('Developer Settings', fontSize: 24,),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.animation, color: theme.iconTheme.color),
            title: const CustomText('Animation Settings',),
            trailing: Icon(Icons.arrow_forward_ios, color: theme.iconTheme.color),
            onTap: () => Get.to(() => AnimationSettingsView()),
          ),

        ],
      ),
    );
  }
}