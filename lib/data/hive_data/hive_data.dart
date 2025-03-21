import 'dart:convert';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveData {
  static late Box box;
  static late Box secureBox;

  final List<int> generateHiveKey = List<int>.generate(32, (i) => Random.secure().nextInt(256));

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  // Initialize regular Hive box
  static Future<void> initHiveData() async {
    box = await Hive.openBox("box");
  }

  // Initialize secure Hive box with encryption
  Future<void> initSecureHiveData() async {
    final String? savedHiveKey = await secureStorage.read(key: 'hiveKey');

    //If savedHiveKey exists
    if (savedHiveKey != null) {
      final hiveKey = base64Url.decode(savedHiveKey);
      secureBox = await Hive.openBox("secureBox", encryptionCipher: HiveAesCipher(hiveKey));
    } else {
      final hiveKey = generateHiveKey;
      await secureStorage.write(key: 'hiveKey', value: base64Url.encode(hiveKey));
      secureBox = await Hive.openBox("secureBox", encryptionCipher: HiveAesCipher(hiveKey));
    }

  }

  Future<dynamic> getData({required String key}) async => await box.get(key);

  Future<void> setData({required String key, required dynamic value}) async => await box.put(key, value);

  Future<void> deleteData({required String key}) async => await box.delete(key);




  // // Method to retrieve secure data
  // Future<String?> getSecureString({required String key}) async {
  //   final String? savedHiveKey = await secureStorage.read(key: 'hiveKey');
  //
  //   // If saved Key exists
  //   if (savedHiveKey != null) {
  //
  //     if(secureBox.isOpen == true){
  //       final secureData = secureBox.get(key);
  //       return secureData;
  //     }else{
  //       final hiveKey = base64Url.decode(savedHiveKey);
  //       secureBox = await Hive.openBox("secureBox", encryptionCipher: HiveAesCipher(hiveKey));
  //       final secureData = secureBox.get(key);
  //       return secureData;
  //     }
  //
  //   } else {
  //     return null;
  //   }
  // }
  //
  // Future<void> setSecureString({required String key, required String value}) async{
  //   final String? savedHiveKey = await secureStorage.read(key: 'hiveKey');
  //
  //   // If saved Key exists
  //   if (savedHiveKey != null) {
  //
  //     if(secureBox.isOpen == true){
  //       await secureBox.put(key, value);
  //     }else{
  //       final hiveKey = base64Url.decode(savedHiveKey);
  //       secureBox = await Hive.openBox("secureBox", encryptionCipher: HiveAesCipher(hiveKey));
  //       await secureBox.put(key, value);
  //     }
  //
  //   }
  // }

  Future<void> setSecureData({required String key, required dynamic value}) async {
    final String? savedHiveKey = await secureStorage.read(key: 'hiveKey');
    if (savedHiveKey != null) {
      if (secureBox.isOpen) {
        await secureBox.put(key, value);
      } else {
        final hiveKey = base64Url.decode(savedHiveKey);
        secureBox = await Hive.openBox("secureBox", encryptionCipher: HiveAesCipher(hiveKey));
        await secureBox.put(key, value);
      }
    }
  }

  Future<dynamic> getSecureData({required String key}) async {
    final String? savedHiveKey = await secureStorage.read(key: 'hiveKey');
    if (savedHiveKey != null) {
      if (secureBox.isOpen) {
        return secureBox.get(key);
      } else {
        final hiveKey = base64Url.decode(savedHiveKey);
        secureBox = await Hive.openBox("secureBox", encryptionCipher: HiveAesCipher(hiveKey));
        return secureBox.get(key);
      }
    }
    return null;
  }



}