// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_bts/constante/Style.dart';
import 'package:ecommerce_bts/provider/pannel_provider.dart';
import 'package:ecommerce_bts/service/auth_service.dart';
import 'package:ecommerce_bts/service/delayed_animation.dart';
import 'package:ecommerce_bts/ui/DetailsItemScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:progress_dialog2/progress_dialog2.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class TerminateCommandeSreen extends StatefulWidget {
  dynamic data;
  TerminateCommandeSreen({super.key, required this.data});
  static String id = '/ShoppingCartSreen';

  @override
  State<TerminateCommandeSreen> createState() => _ShoppingCartSreenState();
}

class _ShoppingCartSreenState extends State<TerminateCommandeSreen> {
  List<Map<String, dynamic>> produit = [
    {
      'name': "Banana",
      'price': 16.7,
      'image': "assets/images/ban.png",
      'categorie': "Fruits",
      'isFavorite': true,
      'qte': 9
    },
    {
      'name': "Broccoli",
      'price': 16.7,
      'image': "assets/images/broccoli.png",
      'categorie': "Vegetable",
      'isFavorite': true,
      'qte': 8
    },
    {
      'name': "Oyster",
      'price': 16.7,
      'image': "assets/images/oyster.png",
      'categorie': "Fruits",
      'isFavorite': true,
      'qte': 4
    },
    {
      'name': "Banana",
      'price': 16.7,
      'image': "assets/images/ban.png",
      'categorie': "Fruits",
      'isFavorite': true,
      'qte': 9
    },
    {
      'name': "Broccoli",
      'price': 16.7,
      'image': "assets/images/broccoli.png",
      'categorie': "Vegetable",
      'isFavorite': true,
      'qte': 8
    },
    {
      'name': "Oyster",
      'price': 16.7,
      'image': "assets/images/oyster.png",
      'categorie': "Fruits",
      'isFavorite': true,
      'qte': 4
    },
    {
      'name': "Banana",
      'price': 16.7,
      'image': "assets/images/ban.png",
      'categorie': "Fruits",
      'isFavorite': true,
      'qte': 9
    },
    {
      'name': "Broccoli",
      'price': 16.7,
      'image': "assets/images/broccoli.png",
      'categorie': "Vegetable",
      'isFavorite': true,
      'qte': 8
    },
    {
      'name': "Oyster",
      'price': 16.7,
      'image': "assets/images/oyster.png",
      'categorie': "Fruits",
      'isFavorite': true,
      'qte': 4
    },
  ];
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    final pannelProviders = Provider.of<PannelProviders>(context);
    if (kDebugMode) {
      print("ShoppingCartSreen ---${pannelProviders.cartQuantityItems}");
      print(pannelProviders.totalPrice);
    }
    final ProgressDialog pr =
        ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: 'Chargement ...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: const CircularProgressIndicator(
          color: Colors.green,
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progressTextStyle: const TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: const TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 3,
        title: const Text(
          'Terminer Votre commande',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Texte en haut
          Container(
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.green, width: 3))),
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Point de livarison',
                  maxLines: 3,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                Wrap(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.redAccent,
                    ),
                    Text(
                      widget.data["title"],
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Position geographique',
                          maxLines: 3,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        Wrap(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.pin_drop_outlined,
                              color: Colors.redAccent,
                            ),
                            Text(
                              "latitude: ${widget.data["latitude"]}",
                              style: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        Wrap(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.pin_drop_outlined,
                              color: Colors.redAccent,
                            ),
                            Text(
                              "longitude: ${widget.data["longitude"]}",
                              style: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ListView au milieu
          Expanded(
            child: Scrollbar(
              interactive: true,
              controller: _scrollController,
              radius: const Radius.circular(8),
              thickness: 10,
              thumbVisibility: true,
              child: ListView.builder(
                itemCount: pannelProviders.pannelProduct.length,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  var item = pannelProviders
                      .pannelProduct[index]; // Nombre d'éléments dans la liste
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailsItemScreen(item
                                .produit)), // Remplacez NewScreen() par le widget de votre nouvelle page
                      );
                    },
                    title: DelayedAnimation(
                      delay: 500 + (index - 1) * 500,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 80.0, // Largeur fixe
                            height: 100.0,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(10.0), // Bords arrondis
                              child: CachedNetworkImage(
                                height: 100,
                                // width: 80,
                                imageUrl: item.produit.imagePath,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: Colors.grey.shade100,
                                  highlightColor: Colors.grey.shade200,
                                  child: Container(
                                    margin: const EdgeInsets.all(5),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 4.0),
                                    decoration: Styles.decContainer,
                                    width: 73,
                                    height: 65,
                                    child: null,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          (item.produit.categorie.nom)
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                            fontSize: 15,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            final list =
                                                pannelProviders.pannelProduct;
                                            if (list.contains(ProductPannel(
                                                produit: item.produit,
                                                qte: 1))) {
                                              list.remove(ProductPannel(
                                                  produit: item.produit,
                                                  qte: 1));
                                              pannelProviders.updateUser(list);
                                            }
                                            pannelProviders.reduiceQnantity();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Produit supprimé avec succes",
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      item.produit.nom,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "\$${item.qte * item.produit.prix}",
                                        style: const TextStyle(
                                            color: Colors.orangeAccent,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(
                                            0.0), // Enlève tout le padding
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Wrap(
                                          spacing: 0,
                                          alignment: WrapAlignment.center,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            IconButton(
                                                padding: const EdgeInsets.all(
                                                    0.0), // Enlève tout le padding
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.remove,
                                                  color: Colors.grey,
                                                )),
                                            Text("${item.qte}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            IconButton(
                                                padding: const EdgeInsets.all(
                                                    0.0), // Enlève tout le padding
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.add,
                                                  color: Colors.grey,
                                                )),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Container en bas

          Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey))),
            padding: const EdgeInsets.all(16.0),
            // color: Colors.blue, // Couleur de fond du conteneur
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Total: ${pannelProviders.cartQuantityItems}'
                        " Produits",
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        'Total: ${pannelProviders.totalPrice} FCFA',
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String emailBody = '''
    <!DOCTYPE html>
    <html lang="fr">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Juared shop</title>
    </head>
    <body style="font-family: Arial, sans-serif;">

        <div style="max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #ccc; border-radius: 5px;">
            <h2 style="text-align: center;">Demande de livraison</h2>
            <p>Bonjour,</p>
            
            <p>Nous souhaitons faire une demande de livraison pour les articles suivants :</p>
            
            <ul>''';
                    for (var i = 0;
                        i < pannelProviders.pannelProduct.length;
                        i++) {
                      final data = pannelProviders.pannelProduct[i];
                      emailBody +=
                          '<li>${i + 1}: ${data.produit.nom} - prix: ${data.produit.prix} - qte: ${data.qte}</li>';
                    }
                    emailBody += '''
            </ul>
            <p>Merci de suivre ce lien pour la livraison : <a href=https://www.google.com/maps/dir/?api=1&destination=${widget.data["latitude"]},${widget.data["longitude"]}&dir_action=navigate>lien: https://www.google.com/maps/dir/?api=1&destination=${widget.data["latitude"]},${widget.data["longitude"]}&dir_action=navigate</a></p>            
            <p><strong>Adresse de livraison :</strong></p>
            <p>Nom et prénom: ${authService.user?.nom}<br>
            <p>Email: ${authService.user?.email}<br>
            <p>Identifiant: ${authService.user?.uid}<br>
               Adresse: ${widget.data["title"]}<br>
               Ville: ${widget.data["title"]}<br>
               Pays: Cameroun</p>
            
            <p>Merci de prendre les mesures nécessaires pour effectuer la livraison dans les meilleurs délais.</p>
            
            <p>Cordialement,<br>
              Administraition de Juareb Shop </p>
        </div>

    </body>
    </html>
  ''';
                    final Email email = Email(
                      body: emailBody,
                      subject: 'Livraison',
                      recipients: ['dongfackkevine222@gmail.com'],
                      cc: [],
                      bcc: [],
                      isHTML: true,
                    );

                    FlutterEmailSender.send(email)
                        .then((value) => {log("hhhhhhhhhhhhh")});

                    // Action à effectuer lorsque le bouton est pressé
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Couleur de fond orange
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Bords arrondis
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Valider ma commande',
                      style: TextStyle(
                          letterSpacing: 2,
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
