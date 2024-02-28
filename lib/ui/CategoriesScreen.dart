import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bts/models/produit_categori.dart';
import 'package:ecommerce_bts/ui/produit_category_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_bts/components/BottomNavigationBars.dart';
import 'package:ecommerce_bts/constante/Style.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});
  static String id = '/CategoriesScreen';

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var catList = [
    "assets/images/cate1.png",
    "assets/images/cate2.png",
    "assets/images/cate3.png",
    "assets/images/cate4.png",
    "assets/images/cate1.png",
    "assets/images/cate2.png",
    "assets/images/cate3.png",
    "assets/images/cate4.png",
    "assets/images/cate4.png",
    "assets/images/cate1.png",
    "assets/images/cate2.png",
    "assets/images/cate3.png",
    "assets/images/cate4.png",
  ];
  Future<void> getCategorieData() async {
    List<CategorieProduit> dataLists = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('product_category')
          .orderBy('nom', descending: false)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        dataLists = querySnapshot.docs
            .map((doc) => CategorieProduit(
                  iud: doc.id,
                  code: doc['code'],
                  nom: doc['nom'],
                  imageUrl: doc['image_url'],
                ))
            .toList();
        setState(() {
          dataList = dataLists;
        });
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        if (kDebugMode) {
          print('Aucune donnée trouvée dans la collection.');
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (kDebugMode) {
        print('Erreur lors de la récupération des données depuis Firebase: $e');
      }
    }
  }

  @override
  void initState() {
    getCategorieData();
    super.initState();
    // FirebaseFirestore.instance.collection('users').snapshots().
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        // setState(() {
        //   isLoading = false;
        // });
      }
    });
  }

  bool isLoading = true;
  List<CategorieProduit> dataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text(
          "Categories",
          style: TextStyle(fontSize: 25.0),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add_box_sharp))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(top: 0),
          child: Wrap(
            children: [
              Center(
                child: Wrap(
                    spacing: 15.0,
                    runSpacing: 15.0,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.spaceBetween,
                    children: isLoading
                        ? catList.map((item) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade200,
                              highlightColor: Colors.grey.shade300,
                              child: Container(
                                  // margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 8.0),
                                  decoration: Styles.decContainer,
                                  width:
                                      (MediaQuery.of(context).size.width / 2) -
                                          33,
                                  height: 160,
                                  child: null),
                            );
                          }).toList()
                        : dataList.map((item) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ProduitCategoryScreen(category: item)));
                              },
                              child: Container(
                                // margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 8.0),
                                decoration: Styles.decContainer,
                                width: (MediaQuery.of(context).size.width / 2) -
                                    33,
                                // height: 60,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CachedNetworkImage(
                                      height: 100,
                                      // width: 80,
                                      imageUrl: item.imageUrl,
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
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      item.nom,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.orangeAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList()),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBars(1),
    );
  }
}
