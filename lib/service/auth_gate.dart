import 'package:ecommerce_bts/service/auth_service.dart';
import 'package:ecommerce_bts/ui/HomeSreen.dart';
import 'package:ecommerce_bts/ui/LogInScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
  static String id = '/AuthGate';

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          authServices.fetchUserData();
          if (snapshot.hasData) {
            authServices.fetchUserData();
            return const HomeScreen();
          }
          // user is NOT logged in
          else {
            return const LogInScreen();
          }
        },
      ),
    );
  }
}
