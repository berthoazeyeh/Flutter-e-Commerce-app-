import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:ecommerce_bts/models/produit.dart';
import 'package:flutter/material.dart';

class ProductPannel implements Comparable<ProductPannel> {
  int qte;
  Produit produit;

  ProductPannel({required this.produit, required this.qte});
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductPannel &&
          runtimeType == other.runtimeType &&
          produit == other.produit;

  @override
  int get hashCode => produit.hashCode;

  @override
  int compareTo(ProductPannel other) {
    return (produit).compareTo(other.produit);
  }
}

class PannelProviders extends ChangeNotifier {
  List<ProductPannel> _pannel = [];
  double _totalPrice = 0;
  int _cartQuantityItems = 0;

  final GlobalKey<CartIconKey> _cartKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) _runAddToCartAnimation;
  List<ProductPannel> get pannelProduct => _pannel;
  double get totalPrice => _totalPrice;

  Function(GlobalKey) get runAddToCartAnimation => _runAddToCartAnimation;
  void setRunAddToCartAnimation(runAddToCartAnimation) {
    _runAddToCartAnimation = runAddToCartAnimation;
  }

  GlobalKey<CartIconKey> get cartKey => _cartKey;
  void updateQnantity() {
    _totalPrice = 0.0;
    for (var element in _pannel) {
      _totalPrice = _totalPrice + element.produit.prix * element.qte;
    }
    _cartQuantityItems++;
    notifyListeners();
  }

  void reduiceQnantity() {
    _totalPrice = 0.0;
    for (var element in _pannel) {
      _totalPrice = _totalPrice + element.produit.prix * element.qte;
    }
    _cartQuantityItems--;
    notifyListeners();
  }

  int get cartQuantityItems => _cartQuantityItems;
  void updateUser(List<ProductPannel> newUser) {
    _totalPrice = 0.0;
    for (var element in _pannel) {
      _totalPrice = _totalPrice + element.produit.prix * element.qte;
    }
    _pannel = newUser;
    notifyListeners();
  }

  void addNewProduct(ProductPannel newUser) {
    _totalPrice = _totalPrice + newUser.produit.prix;
    final tmp = _pannel;
    tmp.add(newUser);
    _pannel = tmp;
    notifyListeners();
  }

  void clearPannel() {
    _pannel = [];
    _totalPrice = 0.0;
    _cartQuantityItems = 0;
    notifyListeners();
  }
}
