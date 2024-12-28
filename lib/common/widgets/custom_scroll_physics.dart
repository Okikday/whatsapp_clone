import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class CustomScrollPhysics extends ScrollPhysics {
  final ScrollPhysicsBehavior behavior;

  const CustomScrollPhysics({
    super.parent,
    this.behavior = ScrollPhysicsBehavior.android,
  });

  factory CustomScrollPhysics.android({ScrollPhysics? parent}) {
    return CustomScrollPhysics(behavior: ScrollPhysicsBehavior.android, parent: parent);
  }

  factory CustomScrollPhysics.ios({ScrollPhysics? parent}) {
    return CustomScrollPhysics(behavior: ScrollPhysicsBehavior.ios, parent: parent);
  }

  factory CustomScrollPhysics.springyGlow({ScrollPhysics? parent}) {
    return CustomScrollPhysics(behavior: ScrollPhysicsBehavior.springyGlow, parent: parent);
  }

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(behavior: behavior, parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    switch (behavior) {
      case ScrollPhysicsBehavior.android:
        return ClampingScrollSimulation(
          position: position.pixels,
          velocity: velocity,
          tolerance: toleranceFor(position),
        );
      case ScrollPhysicsBehavior.ios:
        return BouncingScrollSimulation(
          spring: const SpringDescription(
            mass: 50, // Adjust mass, stiffness, and damping as needed
            stiffness: 100,
            damping: 10,
          ),
          position: position.pixels,
          velocity: velocity,
          leadingExtent: position.minScrollExtent,
          trailingExtent: position.maxScrollExtent,
          tolerance: toleranceFor(position),
        );
      case ScrollPhysicsBehavior.springyGlow:
        return SpringSimulation(
          const SpringDescription(
            mass: 50,
            stiffness: 100,
            damping: 10,
          ),
          position.pixels,
          position.maxScrollExtent,
          velocity,
        );
    }
  }
}

enum ScrollPhysicsBehavior {
  android,
  ios,
  springyGlow,
}