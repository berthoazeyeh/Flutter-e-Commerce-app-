// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:ecommerce_bts/constante/Style.dart';
import 'package:ecommerce_bts/models/produit.dart';
import 'package:ecommerce_bts/models/produit_categori.dart';
import 'package:ecommerce_bts/ui/DetailsItemScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProduitCategoryScreen extends StatefulWidget {
  CategorieProduit category;
  ProduitCategoryScreen({super.key, required this.category});

  @override
  State<ProduitCategoryScreen> createState() => _ProduitCategoryScreenState();
}

class _ProduitCategoryScreenState extends State<ProduitCategoryScreen> {
  Future<void> getProductData() async {
    List<Produit> dataLists = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Products')
          .where('categorieCode', isEqualTo: widget.category.code)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
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
        setState(() {
          isLoadingproduct = false;
        });
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

  final ScrollController _scrollController = ScrollController();

  bool isLoadingproduct = true;
  List<Produit> dataProductList = [];
  String searchValue = '';
  List<String> _suggestions = [];

  @override
  Widget build(BuildContext context) {
    _suggestions = dataProductList.map((e) => e.nom).toList();
    print("${dataProductList.length} ${isLoadingproduct}");
    return Scaffold(
      appBar: EasySearchBar(
          backgroundColor: Colors.white,
          title: Text(widget.category.nom),
          onSearch: (value) => setState(() => searchValue = value),
          suggestions: _suggestions),
      body: Scrollbar(
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
              : dataProductList.isEmpty
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
                                    "Aucun produit disponible pour cette categorie",
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
                      itemCount: dataProductList.length,
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        var item = dataProductList[
                            index]; // Nombre d'éléments dans la liste
                        return ListTile(
                          // leading: // Image à gauche
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailsItemScreen(
                                      item)), // Remplacez NewScreen() par le widget de votre nouvelle page
                            );
                          },
                          contentPadding: const EdgeInsets.only(
                              top: 15, left: 15, right: 15, bottom: 15),
                          trailing: InkWell(
                            onTap: () {},
                            child: const Text(
                              "AJOUTER",
                              style: TextStyle(
                                  color: Colors.amberAccent, fontSize: 15),
                            ),
                          ),
                          leading: SizedBox(
                            width: 80.0, // Largeur fixe
                            height: 200.0,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(10.0), // Bords arrondis
                              child: CachedNetworkImage(
                                height: 100,
                                // width: 80,
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
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.nom,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "\$${item.prix}",
                                      style: const TextStyle(
                                          color: Colors.orangeAccent,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )),
    );
  }
}
