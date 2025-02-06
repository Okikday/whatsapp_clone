// file: animation_settings_view.dart
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/app/controllers/app_animation_settings.dart';

class AnimationSettingsView extends StatelessWidget {
  AnimationSettingsView({super.key});

  // Create a map of curve names to their instances.
  // This covers all curves (and indirectly the Spring-based ones via fromSpring).
final Map<String, Curve> curveOptions = {
  // Flutter's built-in curves:
  'Linear': Curves.linear,
  'Ease': Curves.ease,
  'EaseIn': Curves.easeIn,
  'EaseOut': Curves.easeOut,
  'EaseInOut': Curves.easeInOut,
  'FastOutSlowIn': Curves.fastOutSlowIn,
  'Decelerate': Curves.decelerate,

  // Custom spring-based curves:
  'Instant (Spring)': CustomCurves.instant,
  'Default iOS (Spring)': CustomCurves.defaultIos,
  'Bouncy (Spring)': CustomCurves.bouncy,
  'Snappy (Spring)': CustomCurves.snappy,
  'Interactive (Spring)': CustomCurves.interactive,
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
            orElse: () =>
                 MapEntry('Custom', CustomCurves.defaultIos),
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
                    appAnimationSettingsController.curve =
                        curveOptions[newName]!;
                  }
                },
              ),
              const SizedBox(height: 24),
              // Transition Duration slider
              CustomText(
                'Transition Duration (${appAnimationSettingsController.transitionDuration} ms)',
                fontSize: 16,
              ),
              Slider(
                value:
                    appAnimationSettingsController.transitionDuration.toDouble(),
                min: 100,
                max: 5000,
                divisions: 490,
                label:
                    '${appAnimationSettingsController.transitionDuration} ms',
                onChanged: (double value) {
                  appAnimationSettingsController.transitionDuration =
                      value.toInt();
                },
              ),
              const SizedBox(height: 24),
              // Reverse Transition Duration slider
              CustomText(
                'Reverse Transition Duration (${appAnimationSettingsController.reverseTransitionDuration} ms)',
                fontSize: 16,
              ),
              Slider(
                value: appAnimationSettingsController
                    .reverseTransitionDuration
                    .toDouble(),
                min: 100,
                max: 5000,
                divisions: 490,
                label:
                    '${appAnimationSettingsController.reverseTransitionDuration} ms',
                onChanged: (double value) {
                  appAnimationSettingsController.reverseTransitionDuration =
                      value.toInt();
                },
              ),
              const Spacer(),
              // Reset Button
              Center(
                child: CustomElevatedButton(
                  pixelHeight: 48,
                  onClick: () =>
                      appAnimationSettingsController.resetToDefault(),
                  label: "Reset to Default",
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
