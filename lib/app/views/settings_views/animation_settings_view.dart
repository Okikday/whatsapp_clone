import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/app/controllers/app_animation_settings.dart';

class AnimationSettingsView extends StatelessWidget {
  AnimationSettingsView({super.key});

  final Map<String, Curve> curveOptions = {
    'linear': CustomCurves.linear,
    'ease': CustomCurves.ease,
    'decelerate': CustomCurves.decelerate,
    'fastSlowInOut': CustomCurves.fastSlowInOut,
    'bounceOut': CustomCurves.bounceOut,
    'bounceIn': CustomCurves.bounceIn,
    'easeOutSine': CustomCurves.easeOutSine,
    'easeInOutSine': CustomCurves.easeInOutSine,
    'easeOutCirc': CustomCurves.easeOutCirc,
    'easeInOutCirc': CustomCurves.easeInOutCirc,
    'instant': CustomCurves.instantSpring,
    'defaultIos': CustomCurves.defaultIosSpring,
    'bouncy': CustomCurves.bouncySpring,
    'snappy': CustomCurves.snappySpring,
    'interactive': CustomCurves.interactiveSpring,
  };


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          "Page Animation Settings",
          fontSize: 24,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          // Find the current curve's name by comparing with our map values.
          final currentCurveName = curveOptions.entries.firstWhere(
                (entry) => entry.value == appAnimationSettingsController.curve,
            orElse: () => MapEntry('easeOutCirc', CustomCurves.easeOutCirc),
          ).key;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Curve selection dropdown
              const CustomText(
                'Select Animation Curve',
                fontSize: 16,
              ),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: currentCurveName,
                isExpanded: true,
                items: curveOptions.keys.map((String name) {
                  return DropdownMenuItem<String>(
                    value: name,
                    child: CustomText(name, fontSize: 16),
                  );
                }).toList(),
                onChanged: (String? newName) {
                  if (newName != null) {
                    appAnimationSettingsController.curve = curveOptions[newName]!;
                  }
                },
              ),

              const SizedBox(height: 24),
              // Transition Duration slider
              CustomText(
                'Transition Duration (${appAnimationSettingsController.transitionDuration.inMilliseconds} ms)',
                fontSize: 16,
              ),
              Slider(
                value: appAnimationSettingsController.transitionDuration.inMilliseconds.toDouble(),
                min: 100,
                max: 5000,
                divisions: 490,
                label: '${appAnimationSettingsController.transitionDuration.inMilliseconds} ms',
                onChanged: (double value) {
                  appAnimationSettingsController.transitionDuration = Duration(milliseconds: value.toInt());
                },
              ),
              const SizedBox(height: 24),
              // Reverse Transition Duration slider
              CustomText(
                'Reverse Transition Duration (${appAnimationSettingsController.reverseTransitionDuration.inMilliseconds} ms)',
                fontSize: 16,
              ),
              Slider(
                value: appAnimationSettingsController.reverseTransitionDuration.inMilliseconds.toDouble(),
                min: 100,
                max: 5000,
                divisions: 490,
                label: '${appAnimationSettingsController.reverseTransitionDuration.inMilliseconds} ms',
                onChanged: (double value) {
                  appAnimationSettingsController.reverseTransitionDuration = Duration(milliseconds: value.toInt());
                },
              ),
              const Spacer(),
              // Reset Button
              Center(
                child: CustomElevatedButton(
                  pixelHeight: 48,
                  onClick: () {
                    appAnimationSettingsController.resetToDefault();
                    CustomSnackBar.showSnackBar(context, content: "Reset animations to default");
                  },
                  label: "Reset to Default",
                  textSize: 14,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}





