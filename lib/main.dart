import 'package:ecommerce_bts/api/firebase_api.dart';
import 'package:ecommerce_bts/provider/UserProvider.dart';
import 'package:ecommerce_bts/provider/pannel_provider.dart';
import 'package:ecommerce_bts/service/auth_gate.dart';
import 'package:ecommerce_bts/service/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_bts/ui/CategoriesScreen.dart';
import 'package:ecommerce_bts/ui/FavoriteScreen.dart';
import 'package:ecommerce_bts/ui/HomeSreen.dart';
import 'package:ecommerce_bts/ui/LogInScreen.dart';
import 'package:ecommerce_bts/ui/ProfileScreen.dart';
// import 'package:ecommerce_bts/ui/OndoardingSreen.dart';
import 'package:ecommerce_bts/ui/ShoppingCartSreen.dart';
import 'package:ecommerce_bts/ui/SignInScreen.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

// class UserProvider {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   Users getUser(String event) {
//     // final data = _fireStore.collection("users").doc(event).snapshots();

//     return Users(token: "value['token']");
//   }

//   // instance of firebase
//   // final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
//   Stream<Users?> get Uid {
//     return _firebaseAuth.authStateChanges().map((event) {
//       if (event != null) {
//         return getUser(event.uid);
//       } else {
//         return null;
//       }
//     });
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseApi().initNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (content) => UserProviders(),
        ),
        ChangeNotifierProvider(
          create: (content) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (content) => PannelProviders(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: AuthGate.id,
          routes: {
            HomeScreen.id: (context) => const HomeScreen(),
            AuthGate.id: (context) => const AuthGate(),
            ShoppingCartSreen.id: (context) => const ShoppingCartSreen(),
            FavoriteScreen.id: (context) => const FavoriteScreen(),
            CategoriesScreen.id: (context) => const CategoriesScreen(),
            ProfileScreen.id: (context) => const ProfileScreen(),
            SignInScreen.id: (context) => const SignInScreen(),
            LogInScreen.id: (context) => const LogInScreen(),
          }
          // home: SignInScreen(),
          ),
    );
  }
}
