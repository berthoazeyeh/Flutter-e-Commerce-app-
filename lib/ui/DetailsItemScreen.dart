import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_bts/models/produit.dart';
import 'package:ecommerce_bts/provider/pannel_provider.dart';
import 'package:ecommerce_bts/service/delayed_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DetailsItemScreen extends StatefulWidget {
  Produit data;
  DetailsItemScreen(this.data, {super.key});
  static String id = '/DetailsItemScreen';

  @override
  State<DetailsItemScreen> createState() => _DetailsItemScreenState();
}

class _DetailsItemScreenState extends State<DetailsItemScreen> {
  // Valeur initiale du champ
  int qte = 1;
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    final pannelProviders = Provider.of<PannelProviders>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(children: [
          Align(
            alignment: Alignment.topCenter,
            child: DelayedAnimation(
              delay: 1000,
              child: Container(
                height: MediaQuery.of(context).size.height * .4,
                child: CachedNetworkImage(
                  imageUrl: widget.data.imagePath,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        // colorFilter: const ColorFilter.mode(
                        //     Colors.red, BlendMode.colorBurn)
                      ),
                    ),
                  ),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),

                //  DecorationImage(
                //   image: AssetImage(widget.data),
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
            // child: Image.asset('assets/images/done.jpg')
          ),

          // Container(
          //   decoration: BoxDecoration(
          //       border: Border.all(color: Colors.white),
          //       image: const DecorationImage(
          //         image: AssetImage('assets/images/done.jpg'),
          //         fit: BoxFit.cover,
          //       ),
          //       borderRadius: BorderRadius.zero),
          //   height: 250,
          // ),
          Container(
            height: MediaQuery.of(context).size.height * .6 + 2,
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .4 - 2),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: Colors.grey.shade300,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.data.nom,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final list = pannelProviders.pannelProduct;
                          if (list.contains(
                              ProductPannel(produit: widget.data, qte: 1))) {
                            final currentProd = list.indexOf(
                              ProductPannel(produit: widget.data, qte: 1),
                            );
                            list[currentProd].qte = list[currentProd].qte + 1;
                            log("okkkkkkkk");
                          } else {
                            pannelProviders.updateQnantity();
                            pannelProviders.addNewProduct(
                                ProductPannel(produit: widget.data, qte: qte));
                          }
                          player.play(AssetSource("images/allert.wav"));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Produit ajouter avec succes",
                              ),
                            ),
                          );
                          // Action à effectuer lorsque le bouton est pressé
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.orange, // Couleur de fond orange
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20.0), // Bords arrondis
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0.0),
                          child: Text(
                            'Ajouter au Panier',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${widget.data.prix}",
                        style: const TextStyle(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        spacing: 0,
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          IconButton(
                              padding: const EdgeInsets.all(
                                  0.0), // Enlève tout le padding
                              onPressed: () {
                                if (qte > 1) {
                                  setState(() {
                                    qte--;
                                  });
                                }
                              },
                              icon: const Icon(Icons.remove)),

                          Text(
                            qte.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                              padding: const EdgeInsets.all(
                                  0.0), // Enlève tout le padding
                              onPressed: () {
                                setState(() {
                                  qte++;
                                });
                              },
                              icon: const Icon(Icons.add)),
                          // TextButton(
                          //     style: ButtonStyle(),
                          //     onPressed: () {},
                          //     child: Text("+")),
                        ],
                      ),
                    ],
                  ),
                  const Text(
                    "Date d'ajout",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6.0),
                  Container(
                    width: double.infinity,
                    height: 2.0,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey,
                          Colors.grey,
                          Colors.orange,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    (widget.data.dateTime.toLocal().toString())
                        .split(" ")
                        .reversed
                        .join(" "),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        wordSpacing: 4,
                        letterSpacing: 2),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    width: double.infinity,
                    height: 2.0, // Épaisseur du Divider
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange,
                          Colors.grey,
                          Colors.grey,
                        ], // Couleurs du dégradé
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Text(
                  //   widget.data.imagePath,
                  //   style: const TextStyle(fontWeight: FontWeight.normal),
                  // ),
                  // const SizedBox(height: 6.0),
                  Text(
                    widget.data.description,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, letterSpacing: 2),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
