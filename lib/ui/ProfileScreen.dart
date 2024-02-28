import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_bts/service/auth_service.dart';
import 'package:ecommerce_bts/ui/LogInScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_bts/components/BottomNavigationBars.dart';
import 'package:ecommerce_bts/ui/HomeSreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:ecommerce_bts/ui/LogInScreen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static String id = '/ProfileScreen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void signOut() {
    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.signOut();
  }

  Future<void> getImageCaptured(
      ImageSource source, AuthService authService) async {
    final ImagePicker _picker = ImagePicker();

    await Permission.photos.status;
    await Permission.camera.status;
    final XFile? image = await _picker.pickImage(source: source);
    if (kDebugMode) {
      print(image);
    }

    if (image != null) {
      try {
        // Récupérez une référence unique pour l'image
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('images/${DateTime.now()}.png');

        // Téléversez l'image sur Firebase Storage
        await storageReference.putFile(File(image.path));

        // Obtenez l'URL de téléchargement de l'image
        String downloadURL = await storageReference.getDownloadURL();
        authService.updateProfilUser(
            authService.user!.uid, downloadURL, authService.user!);
        // Utilisez downloadURL comme nécessaire (par exemple, sauvegardez-le dans Firebase Database)
        if (kDebugMode) {
          print(
              'Image téléversée avec succès. URL de téléchargement : $downloadURL');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Erreur lors du téléversement de l\'image : $e');
        }
      }
      setState(() {});
    }
  }

  void showImageSourceDialog(BuildContext context, AuthService authService) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Utiliser :',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ListBody(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        getImageCaptured(ImageSource.gallery, authService);
                        // Action à effectuer lorsque l'utilisateur choisit la galerie
                        Navigator.pop(context); // Ferme la boîte de dialogue
                        // Ajoutez ici votre logique pour utiliser la galerie
                      },
                      child: const Row(
                        children: <Widget>[
                          Icon(Icons.photo),
                          Text('Galerie'),
                        ],
                      ),
                    ),
                    const SizedBox(
                        width:
                            20), // Ajoute un espacement entre les deux boutons
                    InkWell(
                      onTap: () {
                        // Action à effectuer lorsque l'utilisateur choisit la caméra
                        getImageCaptured(ImageSource.camera, authService);

                        Navigator.pop(context); // Ferme la boîte de dialogue
                        // Ajoutez ici votre logique pour utiliser la caméra
                      },
                      child: const Row(
                        children: <Widget>[
                          Icon(Icons.camera_alt),
                          Text('Caméra'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final defaultIMG =
      "https://api-private.atlassian.com/users/7831f16b18333c732e152c74f1863d18/avatar";

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    print(authService.user?.toJson());
    if (authService.user != null) {
      log(authService.user!.nom);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Utilisateur'),
        actions: [
          IconButton(
              onPressed: () {
                signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  LogInScreen.id,
                  (route) => false,
                  arguments: {
                    'onBoad': false,
                  },
                );
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomeScreen.id,
            (route) => false,
            arguments: {
              'onBoad': false,
            },
          );
          return true;
        },
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ClipOval(
                    // backgroundImage: NetworkImage(authService.user != null
                    //     ? authService.user!.profilUrl
                    //     : defaultIMG),
                    child: CachedNetworkImage(
                      width: 180,
                      height: 180,
                      imageUrl: authService.user != null
                          ? authService.user!.profilUrl
                          : defaultIMG,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                            // colorFilter: const ColorFilter.mode(
                            //     Colors.red, BlendMode.colorBurn)
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ), // Remplacez par votre image de profil
                  ),
                  const SizedBox(height: 16),
                  Text(
                    authService.user != null
                        ? authService.user!.nom
                        : 'Nom de l\'utilisateur',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    authService.user != null
                        ? authService.user!.email
                        : ' utilisateur@example.com', // Remplacez par l'adresse email de l'utilisateur
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      showImageSourceDialog(context, authService);
                      // Action à effectuer lorsque le bouton est pressé (par exemple, modifier le profil)
                    },
                    child: const Text('Modifier le profil'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Action à effectuer lorsque le bouton est pressé (par exemple, modifier le profil)
                      signOut();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        LogInScreen.id,
                        (route) => false,
                        arguments: {
                          'onBoad': false,
                        },
                      );
                    },
                    child: const Text('Log Out'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBars(4),
    );
  }
}
