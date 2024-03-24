import 'dart:developer';

import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bts/models/produit.dart';
import 'package:ecommerce_bts/models/produit_categori.dart';
import 'package:ecommerce_bts/models/user.dart';
import 'package:ecommerce_bts/provider/pannel_provider.dart';
import 'package:ecommerce_bts/service/auth_service.dart';
import 'package:ecommerce_bts/service/delayed_animation.dart';
import 'package:ecommerce_bts/ui/OndoardingSreen.dart';
import 'package:ecommerce_bts/ui/add_product_screen.dart';
import 'package:ecommerce_bts/ui/produit_category_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_bts/components/BottomNavigationBars.dart';
import 'package:ecommerce_bts/constante/Style.dart';
import 'package:ecommerce_bts/ui/CategoriesScreen.dart';
import 'package:ecommerce_bts/ui/DetailsItemScreen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String id = '/HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  bool isLoadingCategorie = true;
  bool isLoadingproduct = true;

  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;
  var _cartQuantityItems = 3;
  final player = AudioPlayer();
  Future<void> insertData(List<Map<String, dynamic>> data) async {
    final CollectionReference productCategories =
        FirebaseFirestore.instance.collection('product_category');

    for (Map<String, dynamic> item in data) {
      final id = productCategories.doc().id;

      await productCategories.doc(id).set(item).then((value) {
        if (kDebugMode) {
          print("Added item with ID: ");
        }
        // Ajouter l'ID Firebase dans l'objet JSON
      }).catchError((error) {
        if (kDebugMode) {
          print("Failed to add item: $error");
        }
      });
    }
    // Afficher les données mises à jour
    if (kDebugMode) {
      print(data);
    }
  }

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
          isLoadingCategorie = false;
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

  Future<void> getProductData() async {
    List<Produit> dataLists = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Products')
          .orderBy('timestamp', descending: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        dataLists = querySnapshot.docs.map((doc) {
          Timestamp t = doc['timestamp'];
          log(t.toDate().toString());
          return Produit(
              id: doc.id,
              userId: doc['userId'],
              code: doc['code'],
              nom: doc['nom'],
              description: doc['description'],
              imagePath: doc['imageUrl'],
              prix: doc['prix'],
              timestamp: t,
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
    getCategorieData();
    getProductData();
    super.initState();
    cartKey.currentState?.runCartAnimation((_cartQuantityItems).toString());
    log("----------------------------------ok");
    // FirebaseFirestore.instance.collection('users').snapshots().
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void clearPannel() {
    _cartQuantityItems = 0;
    cartKey.currentState!.runClearCartAnimation();
  }

  Future<void> _refresh() async {
    // Simuler une opération asynchrone de rafraîchissement des données
    setState(() {
      isLoadingCategorie = true;
      isLoadingproduct = true;
    });
    getCategorieData();
    getProductData();
  }

  var catList = [
    "assets/images/cate1.png",
    "assets/images/cate2.png",
    "assets/images/cate3.png",
    "assets/images/cate4.png",
    "assets/images/cate1.png",
    "assets/images/cate2.png",
    "assets/images/cate3.png",
    "assets/images/cate4.png",
  ];
  List<CategorieProduit> dataList = [];
  List<Produit> dataProductList = [];
  List<Map<String, dynamic>> produit = [
    {
      'name': "Orange",
      'price': 16.7,
      'image': "assets/images/prod1.png",
      'categorie': "",
      'isFavorite': true,
    },
    {
      'name': "Garlic",
      'price': 9.7,
      'image': "assets/images/prod2.png",
      'categorie': "",
      'isFavorite': false,
    },
    {
      'name': "Broccoli",
      'price': 5.79,
      'image': "assets/images/prod3.png",
      'categorie': "",
      'isFavorite': false,
    },
    {
      'name': "Red onion",
      'price': 12.7,
      'image': "assets/images/prod4.png",
      'categorie': "",
      'isFavorite': true,
    },
    {
      'name': "Banana",
      'price': 61.7,
      'image': "assets/images/prod5.png",
      'categorie': "",
      'isFavorite': false,
    },
    {
      'name': "Tomato",
      'price': 13.7,
      'image': "assets/images/prod6.png",
      'categorie': "",
      'isFavorite': false,
    },
    {
      'name': "Patatos",
      'price': 10.7,
      'image': "assets/images/prod7.png",
      'categorie': "",
      'isFavorite': true,
    },
    {
      'name': "Orange",
      'price': 6.7,
      'image': "assets/images/prod8.png",
      'categorie': "",
      'isFavorite': true
    },
  ];
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final pannelProviders = Provider.of<PannelProviders>(context);
    if (kDebugMode) {
      print(pannelProviders.cartQuantityItems);
    }
    if (kDebugMode) {
      print("-------------------${pannelProviders.pannelProduct.length}");
    }
    // print("ggggggggggggggggggg${dataProductList.length}");
    cartKey.currentState
        ?.runCartAnimation((pannelProviders.cartQuantityItems).toString());

    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    bool? onBoad = (args != null ? (args['onBoad'] as bool?) : null);
    if (authService.user != null) {
      log(authService.user!.favorites.toString());
    }
    return (isLoading && onBoad == null)
        ? const LandingPage()
        : RefreshIndicator(
            onRefresh: _refresh,
            child: AddToCartAnimation(
              // To send the library the location of the Cart icon
              cartKey: cartKey,
              height: 30,
              width: 30,
              opacity: 0.85,
              dragAnimation: const DragToCartAnimationOptions(
                rotation: true,
              ),
              jumpAnimation: const JumpAnimationOptions(),
              createAddToCartAnimation: (runAddToCartAnimation) async {
                // You can run the animation by addToCartAnimationMethod, just pass trough the the global key of  the image as parameter
                this.runAddToCartAnimation = runAddToCartAnimation;
                await cartKey.currentState
                    ?.runCartAnimation((_cartQuantityItems).toString());
                log("----------------------------------ok");
              },
              child: Scaffold(
                bottomNavigationBar: BottomNavigationBars(0),
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(top: 25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Good Morning',
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Juareb Shop',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                // Stack(
                                //   alignment: Alignment
                                //       .topRight, // Alignez le cercle en haut à droite
                                //   children: <Widget>[
                                //     // Icon(Icons.remove),
                                //     IconButton(
                                //       onPressed: () async {

                                //         // Navigator.of(context).push(
                                //         //     ModalBottomSheetRoute(
                                //         //         builder: (context) =>
                                //         //             AddProductScreen(),
                                //         //         isScrollControlled: false));
                                //         // await showTopModalSheet<String?>(
                                //         //     context, const HeaderNotification());
                                //       },
                                //       icon: const Icon(Icons.notifications),
                                //     ),
                                //     Container(
                                //       margin: const EdgeInsets.only(
                                //           top: 8, right: 8),
                                //       width: 10.0, // Largeur du cercle
                                //       height: 10.0, // Hauteur du cercle
                                //       decoration: const BoxDecoration(
                                //         shape: BoxShape.circle,
                                //         color: Colors
                                //             .orangeAccent, // Couleur du cercle
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                InkWell(
                                  onTap: () {
                                    clearPannel();
                                  },
                                  child: AddToCartIcon(
                                    key: cartKey,
                                    icon: const Icon(Icons.shopping_cart),
                                    badgeOptions: const BadgeOptions(
                                      active: true,
                                      backgroundColor: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 0, left: 10),
                        decoration: BoxDecoration(color: Colors.grey.shade100),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Categories',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, CategoriesScreen.id);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                    ))
                              ],
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: isLoadingCategorie
                                    ? catList.map((item) {
                                        return Shimmer.fromColors(
                                          baseColor: Colors.red,
                                          highlightColor: Colors.yellow,
                                          child: Container(
                                            margin: const EdgeInsets.all(5),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0, horizontal: 4.0),
                                            decoration: Styles.decContainer,
                                            width: 73,
                                            height: 65,
                                            child: null,
                                          ),
                                        );
                                      }).toList()
                                    : dataList.map((item) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProduitCategoryScreen(
                                                            category: item)));
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(5),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0, horizontal: 4.0),
                                            decoration: Styles.decContainer,
                                            width: 73,
                                            height: 65,
                                            child: CachedNetworkImage(
                                              imageUrl: item.imageUrl,
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
                                                  const CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),

                                            // Image.network(

                                            //   errorBuilder:
                                            //       (context, error, stackTrace) {
                                            //     return const Icon(Icons.error);
                                            //   },
                                            // ),
                                          ),
                                        );
                                      }).toList(),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'Lasted Products',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Wrap(
                                spacing: 10.0,
                                runSpacing: 15.0,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                alignment: WrapAlignment.spaceBetween,
                                children: isLoadingproduct
                                    ? catList.map((item) {
                                        return Shimmer.fromColors(
                                          baseColor: Colors.grey.shade200,
                                          highlightColor: Colors.grey.shade300,
                                          child: InkWell(
                                            onTap: () {},
                                            child: Container(
                                                decoration:
                                                    Styles.decContainer1,
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2) -
                                                    13,
                                                height: 160,
                                                child: null),
                                          ),
                                        );
                                      }).toList()
                                    : dataProductList.map((item) {
                                        // log(item.dateTime.toString());
                                        final GlobalKey widgetKey = GlobalKey();
                                        return InkWell(
                                          onTap: () {
                                            // Navigator.pushNamed(context, DetailsItemScreen.id);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailsItemScreen(
                                                          item)), // Remplacez NewScreen() par le widget de votre nouvelle page
                                            );
                                          },
                                          child: Container(
                                            decoration: Styles.decContainer1,
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2) -
                                                13,
                                            // height: 170,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      key: widgetKey,
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2) -
                                                          13,
                                                      height: 150,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              item.imagePath,
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder: (context,
                                                                  url) =>
                                                              Shimmer
                                                                  .fromColors(
                                                            baseColor: Colors
                                                                .grey.shade100,
                                                            highlightColor:
                                                                Colors.grey
                                                                    .shade200,
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 4.0,
                                                                  horizontal:
                                                                      4.0),
                                                              decoration: Styles
                                                                  .decContainer,
                                                              width: 73,
                                                              height: 65,
                                                              child: null,
                                                            ),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                        ),

                                                        //   Image.network(
                                                        //       fit: BoxFit.cover,
                                                        //       item.imagePath),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 0,
                                                      left: 0,
                                                      child: IconButton(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          onPressed: () {
                                                            var fav =
                                                                authService
                                                                    .user!
                                                                    .favorites;
                                                            if (fav.contains(
                                                                item.id)) {
                                                              fav.remove(
                                                                  item.id);
                                                            } else {
                                                              fav.add(item.id);
                                                            }
                                                            Users currentUser =
                                                                authService
                                                                    .user!;
                                                            currentUser
                                                                    .favorites =
                                                                fav;
                                                            authService
                                                                .updateUser(
                                                                    currentUser);
                                                          },
                                                          icon: Icon(
                                                            Icons.favorite,
                                                            color: (authService
                                                                            .user !=
                                                                        null &&
                                                                    authService
                                                                        .user!
                                                                        .favorites
                                                                        .contains(item
                                                                            .id))
                                                                ? Colors
                                                                    .redAccent
                                                                : Colors.grey,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        item.nom,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            '\$${item.prix}',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              await runAddToCartAnimation(
                                                                  widgetKey);
                                                              await cartKey
                                                                  .currentState!
                                                                  .runCartAnimation(
                                                                      (pannelProviders.cartQuantityItems +
                                                                              1)
                                                                          .toString());
                                                              final list =
                                                                  pannelProviders
                                                                      .pannelProduct;
                                                              if (list.contains(
                                                                  ProductPannel(
                                                                      produit:
                                                                          item,
                                                                      qte:
                                                                          1))) {
                                                                final currentProd =
                                                                    list.indexOf(
                                                                  ProductPannel(
                                                                      produit:
                                                                          item,
                                                                      qte: 1),
                                                                );
                                                                list[currentProd]
                                                                        .qte =
                                                                    list[currentProd]
                                                                            .qte +
                                                                        1;
                                                                log("okkkkkkkk");
                                                              } else {
                                                                pannelProviders
                                                                    .updateQnantity();
                                                                pannelProviders.addNewProduct(
                                                                    ProductPannel(
                                                                        produit:
                                                                            item,
                                                                        qte:
                                                                            1));
                                                              }
                                                              player.play(
                                                                  AssetSource(
                                                                      "images/allert.wav"));
                                                            },
                                                            child: const Text(
                                                              "AJOUTER ",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .redAccent),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList()),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                floatingActionButton: DelayedAnimation(
                  delay: 1500,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                        builder: (context) => const AddProductScreen(),
                      ))
                          .then((value) {
                        if (kDebugMode) {
                          print("responce $value");
                        }
                      });
                    },
                    backgroundColor:
                        Colors.amberAccent, // Couleur de fond du bouton
                    foregroundColor: Colors.black, // Couleur de l'icône
                    shape: const CircleBorder(),
                    child: const Icon(Icons
                        .add), // Spécifie que le bouton doit être de forme circulaire
                  ),
                ),
              ),
            ),
          );
  }
}
