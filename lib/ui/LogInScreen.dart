// ignore_for_file: use_build_context_synchronously

import 'package:ecommerce_bts/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_bts/ui/HomeSreen.dart';
import 'package:ecommerce_bts/ui/OndoardingSreen.dart';
import 'package:ecommerce_bts/ui/SignInScreen.dart';
import 'package:provider/provider.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  static String id = '/LogInScreen';

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  final TextEditingController _passeTextFieldController =
      TextEditingController(text: '');

  String passConfirm = "";

  String password = "";

  bool isloading = false;
  signIn() async {
    if (_passeTextFieldController.text.isEmpty ||
        _textFieldController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Veuillez remplir tout les champs",
          ),
        ),
      );
      return;
    }
    if (_passeTextFieldController.text.isNotEmpty &&
        _textFieldController.text.isNotEmpty) {
      // get the auth service
      setState(() {
        isloading = true;
      });
      final authService = Provider.of<AuthService>(context, listen: false);

      try {
        await authService.signInWithEmailandPassword(
          _textFieldController.text,
          _passeTextFieldController.text,
        );
        authService.fetchUserData();
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.id,
          (route) => false,
        );
        setState(() {
          isloading = false;
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.toString(),
              ),
            ),
          );
        }
      }
    }
  }

  bool _passwordVisible = false;
  bool isLoading = true;
  final TextEditingController _textFieldController =
      TextEditingController(text: ''); // Valeur initiale du champ
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    bool? onBoad = (args != null
        ? (args['onBoad'] as bool?)
        : null); // Récupérez la valeur de param2

    return (isLoading && onBoad == null)
        ? const LandingPage()
        : Scaffold(
            body: SingleChildScrollView(
              child: Stack(children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset('assets/images/done.jpg'),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 300),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(20), left: Radius.circular(20)),
                    color: Colors.white,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Log In",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        style: const TextStyle(height: 1),
                        controller: _textFieldController,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          labelText: 'Votre adresse email',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Bordures arrondies
                            borderSide: const BorderSide(
                                color:
                                    Colors.grey), // Couleur de la bordure grise
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        style: const TextStyle(height: 1),
                        onChanged: (value) {},
                        controller: _passeTextFieldController,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Bordures arrondies
                            borderSide: const BorderSide(
                                color:
                                    Colors.grey), // Couleur de la bordure grise
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      ElevatedButton(
                        onPressed: () {
                          signIn();
                          // ApiClient apiService =
                          //     ApiClient(baseUrl: 'https://votre-api.com');
                          // // ignore: avoid_print
                          // print(apiService);

                          // Navigator.pushNamedAndRemoveUntil(
                          //     context, HomeScreen.id, (route) => false);
                          // Action à effectuer lorsque le bouton est pressé
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.orange, // Couleur de fond orange
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20.0), // Bords arrondis
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'LOG IN',
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("Not account?"),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, SignInScreen.id);
                              },
                              child: const Text("Sign In"))
                        ],
                      )
                    ],
                  ),
                ),
              ]),
            ),
          );
  }
}
