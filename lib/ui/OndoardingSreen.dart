import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
// import 'package:mydiagnostics/provider/UserProvider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late ValueNotifier<double> valueNotifier = ValueNotifier(100.0);

  bool? network;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: Image(
                  image: AssetImage('assets/images/logo1.jpg'),
                  // image: AssetImage('assets/images/onboading.png'),
                  width: 200,
                  height: 200,
                ),
              ),
              const SizedBox(height: 16),
              Shimmer.fromColors(
                  baseColor: Colors.blueAccent,
                  highlightColor: Colors.black,
                  child: const Text(
                    "Juarob Shop",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
