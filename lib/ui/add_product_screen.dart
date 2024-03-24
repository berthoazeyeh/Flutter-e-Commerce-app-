import 'dart:developer';
import 'dart:io';

import 'package:ecommerce_bts/models/produit.dart';
import 'package:ecommerce_bts/models/produit_categori.dart';
import 'package:ecommerce_bts/service/auth_service.dart';
import 'package:ecommerce_bts/service/delayed_animation.dart';
import 'package:ecommerce_bts/service/product_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  CategorieProduit? _selectedCategory;
  List<CategorieProduit> _categories = [];
  bool isLoading = false;
  File? currentFile;
  String productName = "";
  String productDescription = "";
  double productprice = 0.0;
  Future<void> getImageCaptured(ImageSource source) async {
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
        setState(() {
          currentFile = File(image.path);
        });
        print(image.path);
      } catch (e) {
        if (kDebugMode) {
          print('Erreur lors du téléversement de l\'image : $e');
        }
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  void showImageSourceDialog(BuildContext context) {
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
                        getImageCaptured(ImageSource.gallery);
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
                        getImageCaptured(ImageSource.camera);

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

  Future<void> loadCategories() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('product_category').get();
      List<CategorieProduit> categories = [];
      for (var doc in querySnapshot.docs) {
        categories.add(CategorieProduit(
          iud: doc.id,
          nom: doc['nom'],
          code: doc['code'],
          imageUrl: doc['image_url'],
        ));
      }
      log(categories.length.toString());
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors du chargement des catégories: $e');
      }
    }
  }

  String extraireDeuxPremieresLettres(String phrase) {
    List<String> mots = phrase.split(" ");
    List<String> deuxPremieresLettres = [];

    for (String mot in mots) {
      if (mot.isNotEmpty) {
        deuxPremieresLettres.add(mot.substring(0, 2).toUpperCase());
      }
    }

    return deuxPremieresLettres.join("");
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un produit'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Visibility(
                  visible: currentFile != null,
                  child: Container(
                    // height: 30,
                    decoration: BoxDecoration(color: Colors.grey.shade100),
                    child: currentFile != null
                        ? Image.file(
                            fit: BoxFit.cover,
                            currentFile!,
                            height: MediaQuery.of(context).size.height * 0.2,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                DelayedAnimation(
                  delay: 500,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nom du produit',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    onChanged: (value) {
                      setState(() {
                        productName = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le nom du produit';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                DelayedAnimation(
                  delay: 1000,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Prix (FCFA)',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        productprice =
                            value.isNotEmpty ? double.parse(value) : 0.0;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le prix';
                      } else if (int.parse(value) < 100) {
                        return 'Le prix doit etre superieur a 100';
                      }
                      // You can add more validation for the price format here
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                DelayedAnimation(
                  delay: 1500,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    onChanged: (value) {
                      setState(() {
                        productDescription = value;
                      });
                    },
                    maxLines: null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer la description';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                DelayedAnimation(
                  delay: 2000,
                  child: DropdownButtonFormField(
                    value: _selectedCategory,
                    items: _categories.map((CategorieProduit category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(category
                                      .imageUrl), // Utilisez l'URL de l'image de la catégorie
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              category.nom,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis),
                            ), // Affichez le nom de la catégorie
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _formKey.currentState!.validate();
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Catégorie',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 40),
                DelayedAnimation(
                  delay: 2500,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 18)),
                    onPressed: () {
                      showImageSourceDialog(context);
                    },
                    child: const Text(
                      'Choisir/Capturer une photo',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Visibility(
                    visible: isLoading, child: LinearProgressIndicator()),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent,
                      padding: const EdgeInsets.symmetric(vertical: 18)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (currentFile != null) {
                        setState(() {
                          isLoading = true;
                        });
                        PrductServices.addNewPeoduct(
                                currentFile!,
                                Produit(
                                    id: "id",
                                    userId: "complete",
                                    code: extraireDeuxPremieresLettres(
                                        productName),
                                    nom: productName,
                                    description: productDescription,
                                    categorie: _selectedCategory!,
                                    prix: productprice,
                                    imagePath: "imagePath",
                                    timestamp: Timestamp.now(),
                                    dateTime: Timestamp.now().toDate()),
                                authService.user!.uid)
                            .then((value) {
                          log("Ajoute effectuer ave csucces");

                          setState(() {
                            isLoading = false;
                            Navigator.of(context).pop();
                          });
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Choisissez une image pour le produit",
                            ),
                          ),
                        );
                      }
                      // Form is valid, you can proceed with adding the product
                    }
                  },
                  child: Text(
                    'Ajouter le produit'.toUpperCase(),
                    style: const TextStyle(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
