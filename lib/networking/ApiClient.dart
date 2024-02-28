import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ecommerce_bts/models/user.dart';

class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // instance of firebase
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
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
        "token": token
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<Map<String, dynamic>> signup(Users user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup_endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur lors de l\'inscription');
    }
  }

  Future<Users> login(Users user) async {
    // Implémentez la logique pour la connexion
    final response = await http.post(
      Uri.parse('$baseUrl/signup_endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user),
    );

    if (response.statusCode == 200) {
      final user = Users.fromJson(jsonDecode(response.body));
      return user;
    } else {
      throw Exception('Erreur lors de l\'authentification');
    }
  }
}
