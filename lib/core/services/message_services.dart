
import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/core/data/firebase_paths.dart';
import 'package:whatsapp_clone/core/services/connection_services.dart';
import 'package:whatsapp_clone/data/app_data.dart';

class MessageServices{
  MessageServices._instance() {
    if(_myId.isEmpty){
      // re-assign userId
      _myId = AppData.userId ?? "";
    }
    if(_myId.isEmpty) return;

    load();
    log("Initialized Message Services");
  }

  static final MessageServices instance = MessageServices._instance();

  static String _myId = "";
  static final Set<String> _usersIdSet = {};
  static StreamSubscription? _otherUsersSub;

  Set<StreamSubscription> userMsgsSubSet = {};

  start(){
    log("Started Message Services");
  }

  load() async{
    final bool isOnline = await ConnectionServices.instance.isDeviceOnline();

    if(!isOnline) return;

    log("Started listening for other users");
    _listenForOtherUsers();

  }

  void _listenForOtherUsers(){
    _otherUsersSub?.cancel();

    final CollectionReference otherUsersRef = FirebasePaths.otherUsersRef(_myId);
    _otherUsersSub = otherUsersRef.snapshots().listen((QuerySnapshot querySnapshot){
      for (final QueryDocumentSnapshot event in querySnapshot.docs) {
        if(!event.exists) continue;
        _usersIdSet.add(event.id);
      }

      final Set<String> existingUserIds = querySnapshot.docs.map((doc) => doc.id).toSet();
      _usersIdSet.removeWhere((userId) => !existingUserIds.contains(userId));

      log("Messages from ${_usersIdSet.length} users");
    });
  }





  addToWatchList(){
    for (final String element in _usersIdSet) {
      final CollectionReference receivedMsgsRef = FirebasePaths.otherUsersRef(_myId).doc(element).collection("received");
      final StreamSubscription msgStreamSub = receivedMsgsRef.snapshots().listen((event){

      });
      // userMsgsSubSet.add(value)
    }
  }

  _loadMsgs(){

  }


}