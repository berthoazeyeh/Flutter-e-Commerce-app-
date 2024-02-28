import 'package:flutter/material.dart';

class Styles {
  static BoxDecoration decContainer = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: const [
      BoxShadow(
          color: Color.fromARGB(221, 145, 137, 137),
          offset: Offset(2, 3),
          blurRadius: 5.0)
    ],
  );
  static BoxDecoration decContainer1 = BoxDecoration(
    // image: DecorationImage(image: AssetImage("assets/images/cate1.png")),
    color: Colors.white,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: const [
      BoxShadow(
          color: Color.fromARGB(221, 145, 137, 137),
          offset: Offset(2, 3),
          blurRadius: 5.0)
    ],
  );
  static BoxDecoration decContainer3 = const BoxDecoration(
    image: DecorationImage(image: AssetImage("assets/images/cate1.png")),
  );
}
