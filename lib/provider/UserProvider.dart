import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:ecommerce_bts/models/user.dart';

enum AuthStatus { authenticated, unauthenticated }

class UserProviders extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // instance of firebase
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  Users? _user;
  AuthStatus _authStatus = AuthStatus.unauthenticated;

  AuthStatus get authStatus => _authStatus;
  Users? get user => _user;

  void setAuthStatus(AuthStatus authStatu) {
    _authStatus = authStatu;
    notifyListeners();
  }

  void updateUser(Users newUser) {
    _user = newUser;
    notifyListeners();
  }

  void setUser(Users? user) {
    _user = user;
    _authStatus = AuthStatus.authenticated;
    notifyListeners();
  }

  void signOut() {
    _user = null;
    _authStatus = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<String?> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (kDebugMode) {
      print('Token:------ $token');
    }

    return token;
  }

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
}
