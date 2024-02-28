import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bts/constante/Style.dart';
import 'package:ecommerce_bts/models/produit.dart';
import 'package:ecommerce_bts/models/produit_categori.dart';
import 'package:ecommerce_bts/models/user.dart';
import 'package:ecommerce_bts/provider/pannel_provider.dart';
import 'package:ecommerce_bts/service/auth_service.dart';
import 'package:ecommerce_bts/ui/DetailsItemScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_bts/components/BottomNavigationBars.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
// import 'package:text_flutter/constante/Style.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});
  static String id = '/FavoriteScreen';

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final player = AudioPlayer();

  Future<void> getProductData() async {
    List<Produit> dataLists = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Products').get();

      if (querySnapshot.docs.isNotEmpty) {
        print('Aucune donnée trouvée dans la collection.-----');

        dataLists = querySnapshot.docs.map((doc) {
          Timestamp t = doc['timestamp'];

          return Produit(
              id: doc.id,
              userId: doc['userId'],
              code: doc['code'],
              nom: doc['nom'],
              description: doc['description'],
              imagePath: doc['imageUrl'],
              prix: doc['prix'],
              timestamp: doc['timestamp'],
              dateTime: t.toDate(),
              categorie: CategorieProduit(
                  iud: doc['categorie'],
                  code: doc['categorieCode'],
                  nom: doc['categorieName'],
                  imageUrl: ""));
        }).toList();
        setState(() {
          dataProductList = dataLists;
          isLoadingproduct = false;
        });
      } else {
        if (kDebugMode) {
          print('Aucune donnée trouvée dans la collection.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des données depuis Firebase: $e');
      }
    }
  }

  @override
  void initState() {
    getProductData();
    super.initState();
  }

  bool isLoadingproduct = true;
  List<Produit> dataProductList = [];
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
    final authService = Provider.of<AuthService>(context);
    final pannelProviders = Provider.of<PannelProviders>(context);

    List<Produit> dataProductListFiltter = [];
    for (var element in dataProductList) {
      if (authService.user != null &&
          authService.user!.favorites.contains(element.id)) {
        dataProductListFiltter.add(element);
      }
    }
    log("message ${dataProductListFiltter.length}");
    return Scaffold(
      bottomNavigationBar: BottomNavigationBars(3),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Texte en haut
          Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey))),
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Favorite\'s',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
              child: isLoadingproduct
                  ? ListView.builder(
                      controller: _scrollController,
                      itemCount: 15,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                    )
                  : dataProductListFiltter.isEmpty
                      ? ListView(
                          controller: _scrollController,
                          children: [
                            ListTile(
                              title: Center(
                                child: Container(
                                    margin: const EdgeInsets.only(top: 23),
                                    padding: const EdgeInsets.all(12),
                                    decoration: Styles.decContainer1,
                                    child: const Center(
                                      child: Text(
                                        "Aucun produit dans les favorites",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    )),
                              ),
                            )
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: dataProductListFiltter.length,
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            var item = dataProductListFiltter[
                                index]; // Nombre d'éléments dans la liste
                            return ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailsItemScreen(
                                          item)), // Remplacez NewScreen() par le widget de votre nouvelle page
                                );
                              },
                              style: ListTileStyle.drawer,
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    item.nom,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        var fav = authService.user!.favorites;
                                        if (fav.contains(item.id)) {
                                          fav.remove(item.id);
                                        } else {
                                          fav.add(item.id);
                                        }
                                        Users currentUser = authService.user!;
                                        currentUser.favorites = fav;
                                        authService.updateUser(currentUser);
                                      },
                                      icon: const Icon(
                                        Icons.favorite,
                                        color: Colors.redAccent,
                                      ))
                                ],
                              ),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "\$${item.prix}",
                                    style: const TextStyle(
                                        color: Colors.orangeAccent,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final list =
                                          pannelProviders.pannelProduct;
                                      if (list.contains(ProductPannel(
                                          produit: item, qte: 1))) {
                                        final currentProd = list.indexOf(
                                          ProductPannel(produit: item, qte: 1),
                                        );
                                        list[currentProd].qte =
                                            list[currentProd].qte + 1;
                                        log("okkkkkkkk");
                                      } else {
                                        pannelProviders.updateQnantity();
                                        pannelProviders.addNewProduct(
                                            ProductPannel(
                                                produit: item, qte: 1));
                                      }
                                      player.play(
                                          AssetSource("images/allert.wav"));

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Produit ajouter avec succes",
                                          ),
                                        ),
                                      );
                                      // Navigator.pushNamedAndRemoveUntil(
                                      //     context, HomeScreen.id, (route) => false);
                                      // Action à effectuer lorsque le bouton est pressé
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 0),
                                      backgroundColor: Colors.grey
                                          .shade100, // Couleur de fond orange
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            20.0), // Bords arrondis
                                      ),
                                    ),
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      child: Text(
                                        'Ajouter',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: CachedNetworkImage(
                                  width: 70,
                                  height: 200,
                                  imageUrl: item.imagePath,
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
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
