import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bts/models/produit.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PrductServices {
  // final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  static Future<String> addNewPeoduct(
      File file, Produit p, String userId) async {
    var tmp = p;
    String message = "";
    final FirebaseFirestore fireStore = FirebaseFirestore.instance;
    final collection = fireStore.collection("Products");
    final prod = collection.doc();
    tmp.id = prod.id;
    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');

      // Téléversez l'image sur Firebase Storage
      await storageReference.putFile(file);

      // Obtenez l'URL de téléchargement de l'image
      String downloadURL = await storageReference.getDownloadURL();
      await collection.doc(prod.id).set({
        'iud': prod.id,
        'code': tmp.code,
        'nom': tmp.nom,
        'imageUrl': downloadURL,
        'description': tmp.description,
        'categorie': tmp.categorie.iud,
        'categorieName': tmp.categorie.nom,
        'categorieCode': tmp.categorie.code,
        "userId": userId,
        'prix': tmp.prix,
        'timestamp': tmp.timestamp
      }).then((value) => {message = "Produit ajouté"});
    } catch (e) {
      print(e);
      return message;
    }
    return message;
  }
}
