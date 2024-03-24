// ignore: file_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_bts/constante/Style.dart';
import 'package:ecommerce_bts/provider/pannel_provider.dart';
import 'package:ecommerce_bts/service/delayed_animation.dart';
import 'package:ecommerce_bts/ui/DetailsItemScreen.dart';
import 'package:ecommerce_bts/ui/search_place_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_bts/components/BottomNavigationBars.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ShoppingCartSreen extends StatefulWidget {
  const ShoppingCartSreen({super.key});
  static String id = '/ShoppingCartSreen';

  @override
  State<ShoppingCartSreen> createState() => _ShoppingCartSreenState();
}

class _ShoppingCartSreenState extends State<ShoppingCartSreen> {
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
    final pannelProviders = Provider.of<PannelProviders>(context);
    if (kDebugMode) {
      print("ShoppingCartSreen ---${pannelProviders.cartQuantityItems}");
      print(pannelProviders.totalPrice);
    }
    return Scaffold(
      bottomNavigationBar: BottomNavigationBars(2),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey))),
            margin: const EdgeInsets.only(top: 18),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'MON PANIER',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {
                    pannelProviders.clearPannel();
                  },
                  child: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
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
              child: pannelProviders.pannelProduct.isEmpty
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
                                    "Vous n'avez sélectionné aucun appareil. Sélectionnez des produits et ils s'afficheront ici.",
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
                      itemCount: pannelProviders.pannelProduct.length,
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        var item = pannelProviders.pannelProduct[
                            index]; // Nombre d'éléments dans la liste
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
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 80.0, // Largeur fixe
                                    height: 100.0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          10.0), // Bords arrondis
                                      child: CachedNetworkImage(
                                        height: 100,
                                        // width: 80,
                                        imageUrl: item.produit.imagePath,
                                        imageBuilder:
                                            (context, imageProvider) =>
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
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      (item.produit.categorie
                                                              .nom)
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.grey,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        final list =
                                                            pannelProviders
                                                                .pannelProduct;
                                                        if (list.contains(
                                                            ProductPannel(
                                                                produit: item
                                                                    .produit,
                                                                qte: 1))) {
                                                          list.remove(
                                                              ProductPannel(
                                                                  produit: item
                                                                      .produit,
                                                                  qte: 1));
                                                          pannelProviders
                                                              .updateUser(list);
                                                        }
                                                        pannelProviders
                                                            .reduiceQnantity();
                                                        ScaffoldMessenger.of(
                                                                context)
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "\$${item.qte * item.produit.prix}",
                                                  style: const TextStyle(
                                                      color:
                                                          Colors.orangeAccent,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                      0.0), // Enlève tout le padding
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade100,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Wrap(
                                                    spacing: 0,
                                                    alignment:
                                                        WrapAlignment.center,
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .center,
                                                    children: [
                                                      IconButton(
                                                          padding: const EdgeInsets
                                                                  .all(
                                                              0.0), // Enlève tout le padding
                                                          onPressed: () {},
                                                          icon: const Icon(
                                                            Icons.remove,
                                                            color: Colors.grey,
                                                          )),
                                                      Text("${item.qte}",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      IconButton(
                                                          padding: const EdgeInsets
                                                                  .all(
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
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          // Container en bas
          if (pannelProviders.pannelProduct.isNotEmpty)
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
                    onPressed: () {
                      // pannelProviders.clearPannel();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SearchPlaceScreen()), // Remplacez NewScreen() par le widget de votre nouvelle page
                      );

                      // Action à effectuer lorsque le bouton est pressé
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.orangeAccent, // Couleur de fond orange
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0), // Bords arrondis
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'PASSER A L\'ACHAT',
                        style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.black,
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
