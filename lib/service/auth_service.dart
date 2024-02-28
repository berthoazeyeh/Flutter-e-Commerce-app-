import 'dart:developer';

import 'package:ecommerce_bts/models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService extends ChangeNotifier {
  // instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // instance of firebase
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  Users? _user;

  Users? get user => _user;
  // sign user in
  // Fonction pour mettre à jour l'utilisateur actuel
  void updateUser(Users newUser) {
    _user = newUser;
    notifyListeners();
  }

  Future<void> updateProfilUser(String userId, String url, Users user) async {
    Users user1 = user;
    user1.profilUrl = url;
    try {
      await _fireStore
          .collection('users')
          .doc(userId)
          .update({"profilUrl": url});
      updateUser(user1);
      log(user1.profilUrl);
    } catch (e) {}
  }

  // Fonction pour récupérer les données utilisateur personnalisées depuis Firestore
  Future<void> fetchUserData() async {
    if (_firebaseAuth.currentUser != null) {
      String? token = await getToken();

      _fireStore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .update({"token": token});
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .get();
      // Mettez à jour l'utilisateur avec les données personnalisées
      if (userDoc.data() != null) {
        // print("sdsdsd" + Users.fromMap(userDoc.data()!).toString());
        updateUser(Users.fromJson(userDoc.data()!));
      }
    }
  }

  Future<UserCredential> signInWithEmailandPassword(
      String email, String password) async {
    try {
      // sign in
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      String? token = await getToken();
      // add a now document for the user in users collection if it don't altready exists
      _fireStore
          .collection('users')
          .doc(userCredential.user!.uid)
          .update({"token": token});
      _fireStore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      }, SetOptions(merge: true));

      return userCredential;
    }
    // catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<String?> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (kDebugMode) {
      print('Token:------ $token');
    }

    return token;
  }

  void configureFirebaseMessaging() {
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Gérer les notifications lorsque l'application est en premier plan
      if (kDebugMode) {
        print('Message en premier plan: $message');
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Gérer les notifications lorsque l'application est en arrière-plan ou fermée
      if (kDebugMode) {
        print('Message ouvert: $message');
      }
    });
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    // Gérer les notifications en arrière-plan
    if (kDebugMode) {
      print('Message en arrière-plan: $message');
    }
  }

  // create a new user
  Future<UserCredential> signUpWithEmailandPassword(
      String email, password, nom) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String? token = await getToken();
      // after creating the user. create a new document for the user in the user collection
      _fireStore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'nom': nom,
        "isAdmin": false,
        "profilUrl":
            "https://api-private.atlassian.com/users/7831f16b18333c732e152c74f1863d18/avatar",
        "status": false,
        "token": token,
        'favorites': []
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

// void _sendNotification(String targetToken) async {
//     await FirebaseMessaging.instance.sendMessage(to:  targetToken,data: {
//       'notification': {
//         'title': 'Titre de la notification',
//         'body': 'Corps de la notification',
//       },
//       'data': {
//         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//       },
//     });
//   }
  // sign user out
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
