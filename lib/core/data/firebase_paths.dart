import 'package:cloud_firestore/cloud_firestore.dart';

class FirebasePaths {
  static final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  static CollectionReference otherUsersRef(String myId) => firestoreInstance.collection("chats").doc(myId).collection("users");


  static DocumentReference publicInfoDocRef(String id) => firestoreInstance.collection("public_info").doc(id);
}
