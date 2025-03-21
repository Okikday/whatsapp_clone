import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whatsapp_clone/common/app_constants.dart';
import 'package:whatsapp_clone/common/assets_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Utilities {
  /// Returns an [ImageProvider] based on the input parameters.
  ///
  /// - If an explicit [imgsrc] is provided, its branch is used:
  ///   - `ImageSource.file`: returns a [FileImage] if [imgfile] is non-null.
  ///   - `ImageSource.network`: returns a [CachedNetworkImageProvider] if [imgurl]
  ///     is non-empty and valid.
  /// - If [imgsrc] is omitted, the provider is automatically deduced:
  ///   - Uses [FileImage] if [imgfile] is provided.
  ///   - Otherwise, uses [CachedNetworkImageProvider] if [imgurl] is valid.
  /// - If neither option is valid, falls back to an [AssetImage].
  static ImageProvider imgProvider({
    File? imgfile,
    String? imgurl,
    ImageSource? imgsrc,
    String defaultAssetImage = ImagesStrings.imgPlaceholder,
  }) {
    // If the image source is explicitly provided, use that branch.
    if (imgsrc != null) {
      if (imgsrc == ImageSource.file && imgfile != null) {
        return FileImage(imgfile);
      } else if (imgsrc == ImageSource.network &&
          imgurl != null &&
          imgurl.trim().isNotEmpty) {
        final uri = Uri.tryParse(imgurl);
        if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
          return CachedNetworkImageProvider(imgurl);
        }
      }
      // If the explicit branch fails (or the needed parameter is missing),
      // fall back to the placeholder.
      return AssetImage(defaultAssetImage);
    }

    // If no explicit image source is provided, deduce automatically.
    if (imgfile != null) {
      return FileImage(imgfile);
    }
    if (imgurl != null && imgurl.trim().isNotEmpty) {
      final uri = Uri.tryParse(imgurl);
      if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
        return CachedNetworkImageProvider(imgurl);
      }
    }
    // Fallback to the placeholder asset image.
    return AssetImage(defaultAssetImage);
  }

  static PageRouteBuilder customPageRouteBuilder(
      Widget child, {
        Curve? curve,
        Duration transitionDuration = Durations.medium3,
        Duration reverseTransitionDuration = Durations.medium1,
      }) {
    curve = curve ?? CustomCurves.defaultIosSpring;
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return child;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final Animation<Offset> offsetAnimation = animation.drive(
          Tween(begin: const Offset(0.0, 0.1), end: Offset.zero).chain(CurveTween(curve: curve!)),
        );
        final Animation<double> reverseFadeAnimation = animation.drive(
          Tween<double>(begin: 0, end: 1.0).chain(CurveTween(curve: Curves.fastOutSlowIn)),
        );

        if (animation.status == AnimationStatus.reverse) {
          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(opacity: reverseFadeAnimation, child: child),
          );
        }
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
    );
  }
}

/// A class representing a result that can be either a success or a failure.
class Result<T> {
  final T? value;
  final String? error;
  final dynamic unavailable;

  /// Private constructor to initialize the [value] and [error].
  const Result._({this.value, this.error, this.unavailable});

  /// Factory constructor for a successful result.
  factory Result.success(T value) {
    return Result._(value: value);
  }

  /// Factory constructor for a failed result.
  factory Result.error(String error) {
    log("error: $error");
    return Result._(error: error);
  }

  factory Result.unavailable(dynamic unavailable) {
    log("unavailable: $unavailable");
    return Result._(unavailable: unavailable);
  }

  /// Indicates whether the result is successful.
  bool get isSuccess => error == null && unavailable == null;

  /// Indicates whether the result is a failure.
  bool get isError => error != null;

  /// Indicates whether unavailable
  bool get isUnavailable => unavailable != null;
}

// class LogModel {
//   final String title;
//   final String errorMessage;
//   final String stackTrace;
//   final String timestamp;
//   final String userId;
//   final Map<String, dynamic> additionalInfo;
//   final String deviceType;
//   final String platformVersion;
//
//   LogModel({
//     required this.title,
//     required this.errorMessage,
//     required this.stackTrace,
//     required this.timestamp,
//     required this.userId,
//     required this.additionalInfo,
//     required this.deviceType,
//     required this.platformVersion,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'title': title,
//       'errorMessage': errorMessage,
//       'stackTrace': stackTrace,
//       'timestamp': timestamp,
//       'userId': userId,
//       'additionalInfo': additionalInfo,
//       'deviceType': deviceType,
//       'platformVersion': platformVersion,
//     };
//   }
//
//   static LogModel fromMap(Map<String, dynamic> map) {
//     return LogModel(
//       title: map['title'],
//       errorMessage: map['errorMessage'],
//       stackTrace: map['stackTrace'],
//       timestamp: map['timestamp'],
//       userId: map['userId'],
//       additionalInfo: Map<String, dynamic>.from(map['additionalInfo']),
//       deviceType: map['deviceType'],
//       platformVersion: map['platformVersion'],
//     );
//   }
// }
//
// class LoggingService {
//   final _logCollection = FirebaseFirestore.instance.collection('errorLogs');
//   late Box _offlineLogsBox;
//   final String userId;
//
//   LoggingService({required this.userId}) {
//     _initializeHive();
//   }
//
//   Future<void> _initializeHive() async {
//     await Hive.initFlutter();
//     _offlineLogsBox = await Hive.openBox('offlineLogs');
//   }
//
//   Future<void> logError({
//     required String title,
//     required String errorMessage,
//     String? stackTrace,
//     Map<String, dynamic>? additionalInfo,
//   }) async {
//     final log = LogModel(
//       title: title,
//       errorMessage: errorMessage,
//       stackTrace: stackTrace ?? 'N/A',
//       timestamp: DateTime.now().toIso8601String(),
//       userId: userId,
//       additionalInfo: additionalInfo ?? {},
//       deviceType: await _getDeviceType(),
//       platformVersion: await _getPlatformVersion(),
//     );
//
//     await _handleLog(log);
//   }
//
//   Future<void> _handleLog(LogModel log) async {
//     if (await _isOffline()) {
//       await _offlineLogsBox.add(log.toMap());
//     } else {
//       await _sendLogToFirebase(log);
//       await syncOfflineLogs();
//     }
//   }
//
//   Future<void> _sendLogToFirebase(LogModel log) async {
//     await _logCollection.doc(log.userId).collection('logs').add(log.toMap());
//     debugPrint('Logs sent to Firebase for user: ${log.userId}');
//   }
//
//   Future<bool> _isOffline() async => (await Connectivity().checkConnectivity()).first == ConnectivityResult.none;
//
//   Future<void> syncOfflineLogs() async {
//     final logs = _offlineLogsBox.values.map((e) => LogModel.fromMap(e)).toList();
//     logs.sort((a, b) => a.timestamp.compareTo(b.timestamp));
//
//     for (int i = logs.length - 1; i >= 0; i--) {
//       try {
//         await _sendLogToFirebase(logs[i]);
//         await _offlineLogsBox.deleteAt(i);
//         debugPrint('Synced and deleted log: ${logs[i].title}');
//       } catch (e) {
//         debugPrint('Failed to sync log: ${logs[i].title}. Error: $e');
//       }
//     }
//
//     debugPrint('Offline logs sync completed.');
//   }
//
//   Future<String> _getDeviceType() async {
//     if (kIsWeb) {
//       return 'Web';
//     } else if (defaultTargetPlatform == TargetPlatform.iOS) {
//       return 'iOS';
//     } else if (defaultTargetPlatform == TargetPlatform.android) {
//       return 'Android';
//     }
//     return 'Unknown';
//   }
//
//   Future<String> _getPlatformVersion() async {
//     final deviceInfo = DeviceInfoPlugin();
//     if (defaultTargetPlatform == TargetPlatform.iOS) {
//       final iosInfo = await deviceInfo.iosInfo;
//       return iosInfo.systemVersion;
//     } else if (defaultTargetPlatform == TargetPlatform.android) {
//       final androidInfo = await deviceInfo.androidInfo;
//       return androidInfo.version.release;
//     }
//     return 'Unknown';
//   }
// }