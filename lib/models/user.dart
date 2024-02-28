import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  late String uid;
  late String nom;
  late String email;
  late bool status;
  late String profilUrl; // Changement ici : profilUrl peut être null
  String? token; // Changement ici : profilUrl peut être null
  late bool isAdmin;
  late List<dynamic> favorites;
  late Timestamp timestamp;

  // Constructeur
  Users(
      {required this.uid,
      required this.nom,
      required this.email,
      required this.status,
      required this.profilUrl, // Changement ici : profilUrl peut être null
      this.token, // Changement ici : profilUrl peut être null
      required this.isAdmin,
      required this.favorites,
      required this.timestamp});

  Users.fromJson(dynamic map) {
    uid = map['uid'];
    nom = map['nom'];
    email = map['email'];
    status = map['status'];
    profilUrl = map['profilUrl'];
    token = map['token'];
    isAdmin = map['isAdmin'];
    favorites = map['favorites'];
    timestamp = map['timestamp'];
  }
  static Users fromMap(dynamic map) {
    return Users(
        uid: map['uid'],
        nom: map['nom'],
        email: map['email'],
        status: map['status'],
        profilUrl: map['profilUrl'],
        token: map['token'],
        isAdmin: map['isAdmin'],
        favorites: map['favorites'],
        timestamp: map['timestamp']);
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'nom': nom,
      'email': email,
      'status': status,
      'profilUrl': profilUrl,
      'token': token,
      'isAdmin': isAdmin,
      'favorites': favorites,
      'timestamp': timestamp
    };
  }
}

final data = [
  {
    "code": "ORD",
    "nom": "Ordinateurs",
    "image_url":
        "https://firebasestorage.googleapis.com/v0/b/ecommerce-bts.appspot.com/o/ordi.png?alt=media&token=011c1e66-3af1-4231-8483-80a4411443b7",
  },
  {
    "code": "LAP",
    "nom": "Laptops",
    "image_url":
        "https://firebasestorage.googleapis.com/v0/b/ecommerce-bts.appspot.com/o/laptop-deals.jpg?alt=media&token=31b1a49d-3d08-4c1a-91fa-e9334a95edca"
  },
  {
    "code": "DTP",
    "nom": "Desktops",
    "image_url":
        "https://firebasestorage.googleapis.com/v0/b/ecommerce-bts.appspot.com/o/desktop.jpg?alt=media&token=c01046e1-65a4-48ae-88da-d268e0fdf6cf"
  },
  {
    "code": "CPU",
    "nom": "Processeurs",
    "image_url":
        "https://firebasestorage.googleapis.com/v0/b/ecommerce-bts.appspot.com/o/proces.jpg?alt=media&token=e48bedf9-cfaf-4ec5-bbed-85f08ec45446"
  },
  {
    "code": "GPU",
    "nom": "Cartes graphiques",
    "image_url":
        "https://firebasestorage.googleapis.com/v0/b/ecommerce-bts.appspot.com/o/cartegrap.jpg?alt=media&token=31f0954f-1464-4221-a3c8-85f547a903e1"
  },
  {
    "code": "MB",
    "nom": "Cartes mères",
    "image_url":
        "https://firebasestorage.googleapis.com/v0/b/ecommerce-bts.appspot.com/o/carteMere.jpg?alt=media&token=a6edd2bf-4908-4e2d-95c4-ba3a3047df25"
  },
  {
    "code": "RAM",
    "nom": "Mémoire RAM",
    "image_url":
        "https://firebasestorage.googleapis.com/v0/b/ecommerce-bts.appspot.com/o/Ram.jpg?alt=media&token=16157c8f-81bd-42c0-bcea-30e12ae2ea9c"
  },
  {
    "code": "HDD",
    "nom": "Disques durs",
    "image_url":
        "https://firebasestorage.googleapis.com/v0/b/ecommerce-bts.appspot.com/o/difference-disque-dur-hdd-sdd.jpg?alt=media&token=d061c3b1-286d-4939-8103-42322c32390d"
  },
  {
    "code": "MOU",
    "nom": "Souris",
    "image_url":
        "https://firebasestorage.googleapis.com/v0/b/ecommerce-bts.appspot.com/o/3-Tasten-Maus_Microsoft.jpg?alt=media&token=494aea65-d307-43d6-9690-d86b5f852ed9"
  },
  {
    "code": "KBD",
    "nom": "Claviers",
    "image_url":
        "https://firebasestorage.googleapis.com/v0/b/ecommerce-bts.appspot.com/o/clavier.jpg?alt=media&token=a1641c5d-42f1-4fd6-a287-1f49e4aea4d7"
  },
  {
    "code": "MON",
    "nom": "Moniteurs",
    "image_url":
        "https://firebasestorage.googleapis.com/v0/b/ecommerce-bts.appspot.com/o/Moniteurs.jpg?alt=media&token=f5330356-ff57-42fd-9048-5c89aa1ce2ec"
  },
  {
    "code": "PRN",
    "nom": "Imprimantes",
    "image_url":
        "https://firebasestorage.googleapis.com/v0/b/ecommerce-bts.appspot.com/o/Imprimantesjpg.jpg?alt=media&token=fe51b3a5-ddb5-4655-ac61-aafccac31a2b"
  },
  {
    "code": "SCAN",
    "nom": "Scanners",
    "image_url":
        "https://firebasestorage.googleapis.com/v0/b/ecommerce-bts.appspot.com/o/Scanners.jpg?alt=media&token=08bae31b-37fa-48c3-8d34-1cd1c9df2c66"
  },
  {
    "code": "CAM",
    "nom": "Webcams",
    "image_url":
        "https://firebasestorage.googleapis.com/v0/b/ecommerce-bts.appspot.com/o/Webcams.jpg?alt=media&token=bcf24083-1e6f-4599-a53e-267b720f3d85"
  },
  {
    "code": "SPK",
    "nom": "Haut-parleurs",
    "image_url":
        "https://firebasestorage.googleapis.com/v0/b/ecommerce-bts.appspot.com/o/Haut-parleurs.jpg?alt=media&token=51157def-25cc-4da9-bce4-d30c783de7d1"
  },
  {
    "code": "HDS",
    "nom": "Casques",
    "image_url":
        "https://firebasestorage.googleapis.com/v0/b/ecommerce-bts.appspot.com/o/Casques.jpg?alt=media&token=cf6a908b-399f-4d7b-84a1-f74000e3cd6f"
  },
  {
    "code": "BAG",
    "nom": "Sacs à dos pour ordinateurs portables",
    "image_url":
        "https://firebasestorage.googleapis.com/v0/b/ecommerce-bts.appspot.com/o/sac-a-dos-ordinateur-portable-15-6-pouces-homme-im.png?alt=media&token=ef8fe29d-dbc7-46ba-b6b5-bbc8a1022a4b"
  },
  {
    "code": "BATT",
    "nom": "Batteries externes",
    "image_url":
        "https://firebasestorage.googleapis.com/v0/b/ecommerce-bts.appspot.com/o/batterie_externe_secours.jpg?alt=media&token=4273f56e-8735-46d1-95dd-db26aa6259f6"
  },
  {
    "code": "LOG",
    "nom": "Logiciels",
    "image_url":
        "https://firebasestorage.googleapis.com/v0/b/ecommerce-bts.appspot.com/o/logiciels-gratuits.jpg?alt=media&token=4a346211-36cb-4bc7-8ca9-f0841f97aa08",
  },
  {
    "code": "WEAR",
    "nom": "Appareils portables",
    "image_url":
        "https://firebasestorage.googleapis.com/v0/b/ecommerce-bts.appspot.com/o/png-clipart-laptop-personal-computer-handheld-devices-computer-repair-technician-laptop-electronics-computer.png?alt=media&token=321beed4-8803-4576-945e-817058d5d590"
  },
  {
    "code": "CAM",
    "nom": "Caméras",
    "image_url":
        "https://firebasestorage.googleapis.com/v0/b/ecommerce-bts.appspot.com/o/honeywell-equip.jpg?alt=media&token=af093e4f-8372-4b48-b92f-d5a9b63fcbb5"
  },
];
