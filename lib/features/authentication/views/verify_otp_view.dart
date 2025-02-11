// import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
// import 'package:flutter/material.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
//
// class VerifyOtpView extends StatefulWidget {
//   const VerifyOtpView({super.key});
//
//   @override
//   State<VerifyOtpView> createState() => _VerifyOtpViewState();
// }
//
// class _VerifyOtpViewState extends State<VerifyOtpView> {
//   String otpCode = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Verify Phone number'),
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.more_vert),
//             onPressed: () {
//
//             },
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           // Main content: OTP field and instruction
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const CustomText(
//                   'Enter the OTP sent to your phone',
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 20),
//                 PinCodeTextField(
//                   appContext: context,
//                   length: 4,
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   onChanged: (value) {
//                     setState(() {
//                       otpCode = value;
//                     });
//                   },
//                   pinTheme: PinTheme(
//                     shape: PinCodeFieldShape.box,
//                     borderRadius: BorderRadius.circular(8),
//                     fieldHeight: 60,
//                     fieldWidth: 50,
//                     activeFillColor: Colors.white,
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//               ],
//             ),
//           ),
//           // Next button fixed at the bottom using Positioned inside the Stack
//           Positioned(
//             left: 16,
//             right: 16,
//             bottom: 16,
//             child: CustomElevatedButton(
//               pixelHeight: 48,
//               label: "Next",
//               textSize: 15,
//               onClick: (){
//
//               },
//             )
//           ),
//         ],
//       ),
//     );
//   }
// }
