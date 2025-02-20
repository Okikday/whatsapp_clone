// import 'package:permission_handler/permission_handler.dart';
// import 'package:camera/camera.dart';
// import 'package:whatsapp_clone/common/utilities/utilities.dart';
//
// class CameraUtilities {
//   /// Requests Camera permission for app
//   Future<bool> requestCameraPermission() async {
//     PermissionStatus status = await Permission.camera.request();
//     if (status.isGranted) {
//       return true; // Permission granted
//     } else {
//       openAppSettings(); // Optionally open settings to manually grant permission
//       return false; // Permission denied
//     }
//   }
//
//   Future<List<CameraDescription>> getAvailableCameras() async => await availableCameras();
//   CameraDescription getCamera(List<CameraDescription> cameras, CameraLensDirection direction) =>
//       cameras.firstWhere((camera) => camera.lensDirection == direction);
//
//   ///Sets up camera for use
//   Future<Result<CameraController>> setupCamera(
//     CameraController controller,
//   ) async {
//     try {
//       await controller.initialize();
//       return Result.success(controller);
//     } catch (e) {
//       return Result.error("Unable to initialize Camera");
//     }
//   }
// }
