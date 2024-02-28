import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bts/models/produit_categori.dart';

class Produit implements Comparable<Produit> {
  late String id; // Identifiant unique du produit
  late String code;
  late String userId;
  late String nom;
  late String description;
  late double prix;
  late String imagePath; // Chemin de l'image du produit
  late CategorieProduit categorie;
  Timestamp? timestamp = Timestamp.now();
  late DateTime dateTime;
  // Chemin de l'image du produit

  @override
  int compareTo(Produit other) {
    // Compare les quantités
    return (id).compareTo(other.id);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Produit && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
  Produit(
      {required this.id,
      required this.code,
      required this.nom,
      required this.description,
      required this.categorie,
      required this.userId,
      required this.prix,
      required this.imagePath,
      required timestamp,
      required this.dateTime});
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'code': code,
      'description': description,
      'userId': userId,
      'prix': prix,
      'categorie': categorie.toJson(),
      'imagePath': imagePath,
      'timestamp': timestamp
    };
  }

  Produit.fromJson(dynamic map) {
    id = map['id'];
    nom = map['nom'];
    code = map['code'];
    description = map['description'];
    userId = map['userId'];
    categorie = CategorieProduit(
        code: map['categorieCode'],
        nom: map['categorieName'],
        iud: map['categorie'],
        imageUrl: "imageUrl");
    prix = map['prix'];
    imagePath = map['imagePath'];
    timestamp = map['timestamp'];
  }
}
