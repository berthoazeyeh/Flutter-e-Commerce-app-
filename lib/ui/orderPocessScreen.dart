import 'package:flutter/material.dart';
import 'package:ecommerce_bts/ui/HomeSreen.dart';

class OrderProcessScreen extends StatefulWidget {
  const OrderProcessScreen({super.key});

  @override
  State<OrderProcessScreen> createState() => _OrderProcessScreenState();
}

class _OrderProcessScreenState extends State<OrderProcessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 25, bottom: 20),
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text(
                  'Thank You',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
              ),
              const Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage("assets/images/thank.png"),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Your Order in process",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                ],
              )),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, HomeScreen.id, (route) => false);
                  // Action à effectuer lorsque le bouton est pressé
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.orangeAccent, // Couleur de fond orange
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Bords arrondis
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'GO BACK HOME',
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
      ),
    );
  }
}
