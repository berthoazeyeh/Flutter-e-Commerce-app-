import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:ecommerce_bts/ui/location_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class SearchPlaceScreen extends StatefulWidget {
  const SearchPlaceScreen({super.key});

  @override
  State<SearchPlaceScreen> createState() => _SearchPlaceScreenState();
}

class _SearchPlaceScreenState extends State<SearchPlaceScreen> {
  final TextEditingController controller = TextEditingController(text: '');
  Prediction? pred;
  @override
  Widget build(BuildContext context) {
    print(controller.selection);
    // if (pred ) {
    print((pred != null));
    // }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        shape: StarBorder(),
        title: const Text("Recherche"),
        // actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.check))],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Rechercher votre localisation pour la livraison",
              style: TextStyle(
                fontFamily: AutofillHints.postalAddress,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: GooglePlaceAutoCompleteTextField(
                  textEditingController: controller,
                  googleAPIKey: "AIzaSyBI8oXdc-lbtvRxuVstY6eXG5G9FNCT4fU",
                  inputDecoration: const InputDecoration(
                      prefixIcon: Icon(Icons.location_on)),
                  debounceTime: 800,
                  countries: const ["cm"],
                  isLatLngRequired: true,
                  getPlaceDetailWithLatLng: (Prediction prediction) {
                    print("placeDetails" + prediction.lng.toString());
                  },
                  itemClick: (Prediction prediction) {
                    setState(() {
                      pred = prediction;
                    });
                    controller.text = prediction.description!;
                    controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: prediction.description!.length));
                  },
                  itemBuilder: (context, index, Prediction prediction) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on),
                          const SizedBox(
                            width: 7,
                          ),
                          Expanded(
                              child: Text("${prediction.description ?? ""}"))
                        ],
                      ),
                    );
                  },
                  // if you want to add seperator between list items
                  seperatedBuilder: const Divider(),
                  // want to show close icon
                  isCrossBtnShown: true,
                  // optional container padding
                  containerHorizontalPadding: 10,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LocationAccess()), // Remplacez NewScreen() par le widget de votre nouvelle page
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Couleur de fond orange
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Bords arrondis
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Text(
                      'Choisir sur la carte',
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (pred != null) {
                      double latitude =
                          double.parse(pred!.lat != null ? pred!.lat! : "0.0");
                      double longitude =
                          double.parse(pred!.lng != null ? pred!.lng! : "0.0");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocationAccess(
                                  havlocation: true,
                                  lats: latitude,
                                  longs: longitude,
                                  title: controller.text,
                                )), // Remplacez NewScreen() par le widget de votre nouvelle page
                      );
                    } else {
                      final materialBanner = MaterialBanner(
                        elevation: 1,
                        backgroundColor: Colors.transparent,
                        forceActionsBelow: true,
                        content: AwesomeSnackbarContent(
                          title: 'Oh Hey!!',
                          message:
                              'This is an example error message that will be shown in the body of materialBanner!',
                          contentType: ContentType.warning,
                          inMaterialBanner: true,
                        ),
                        actions: const [SizedBox.shrink()],
                      );

                      ScaffoldMessenger.of(context)
                        ..hideCurrentMaterialBanner()
                        ..showMaterialBanner(materialBanner);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Couleur de fond orange
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Bords arrondis
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Text(
                      'Confirmer',
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
