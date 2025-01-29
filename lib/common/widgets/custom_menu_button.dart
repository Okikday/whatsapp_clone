// import 'package:flutter/material.dart';

// class CustomMenuButton extends StatelessWidget {
//   final List<Widget> children;
//   final Offset offset;
//   final Color? backgroundColor;
//   final ShapeBorder? shape;
//   final double elevation;

//   const CustomMenuButton({
//     super.key,
//     required this.children,
//     this.offset = Offset.zero,
//     this.backgroundColor,
//     this.shape,
//     this.elevation = 8.0,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context).push(
//           _PopupMenuRoute(
//             offset: offset,
//             backgroundColor: backgroundColor,
//             shape: shape,
//             elevation: elevation,
//             children: children,
//           ),
//         );
//       },
//       child: const Icon(Icons.more_vert),
//     );
//   }
// }

// class _PopupMenuRoute extends PopupRoute<void> {
//   final Offset offset;
//   final Color? backgroundColor;
//   final ShapeBorder? shape;
//   final double elevation;
//   final List<Widget> children;

//   _PopupMenuRoute({
//     required this.offset,
//     required this.backgroundColor,
//     required this.shape,
//     required this.elevation,
//     required this.children,
//   });

//   @override
//   Color get barrierColor => Colors.black54;

//   @override
//   bool get barrierDismissible => true;

//   @override
//   String get barrierLabel => 'Popup Menu';

//   @override
//   Duration get transitionDuration => const Duration(milliseconds: 300);

//   @override
//   Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
//     return GestureDetector(
//       onTap: () => Navigator.of(context).pop(),
//       behavior: HitTestBehavior.opaque,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: SafeArea(
//           child: Stack(
//             children: [
//               Positioned(
//                 left: offset.dx,
//                 top: offset.dy,
//                 child: Material(
//                   elevation: elevation,
//                   shape: shape,
//                   color: backgroundColor,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: children,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }