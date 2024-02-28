// ignore: file_names
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:super_bottom_navigation_bar/super_bottom_navigation_bar.dart';
import 'package:ecommerce_bts/ui/CategoriesScreen.dart';
import 'package:ecommerce_bts/ui/FavoriteScreen.dart';
import 'package:ecommerce_bts/ui/HomeSreen.dart';
import 'package:ecommerce_bts/ui/ProfileScreen.dart';
import 'package:ecommerce_bts/ui/ShoppingCartSreen.dart';

// ignore: must_be_immutable
class BottomNavigationBars extends StatelessWidget {
  BottomNavigationBars(this.sellectedNav, {super.key});
  int sellectedNav;
  @override
  Widget build(BuildContext context) {
    return SuperBottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: sellectedNav,
      height: 50.0,
      elevation: 0,
      items: const [
        SuperBottomNavigationBarItem(
          selectedIconColor: Colors.orange,
          unSelectedIconColor: Colors.black,
          selectedIcon: Icons.home,
          unSelectedIcon: Icons.home,
          borderBottomWidth: 1,
          highlightColor: Colors.white,
          borderBottomColor: Colors.white,
          backgroundShadowColor: Colors.white,
        ),
        SuperBottomNavigationBarItem(
          selectedIconColor: Colors.orange,
          unSelectedIconColor: Colors.black,
          selectedIcon: Icons.sync_alt,
          unSelectedIcon: Icons.sync_alt,
          borderBottomWidth: 1,
          highlightColor: Colors.white,
          borderBottomColor: Colors.white,
          backgroundShadowColor: Colors.white,
        ),
        SuperBottomNavigationBarItem(
          selectedIconColor: Colors.orange,
          unSelectedIconColor: Colors.black,
          selectedIcon: Icons.shopping_cart,
          unSelectedIcon: Icons.shopping_cart,
          borderBottomWidth: 1,
          highlightColor: Colors.white,
          borderBottomColor: Colors.white,
          backgroundShadowColor: Colors.white,
        ),
        SuperBottomNavigationBarItem(
          selectedIconColor: Colors.orange,
          unSelectedIconColor: Colors.black,
          selectedIcon: Icons.favorite,
          unSelectedIcon: Icons.favorite,
          borderBottomWidth: 1,
          highlightColor: Colors.white,
          borderBottomColor: Colors.white,
          backgroundShadowColor: Colors.white,
        ),
        SuperBottomNavigationBarItem(
          selectedIconColor: Colors.orange,
          unSelectedIconColor: Colors.black,
          selectedIcon: Icons.person,
          unSelectedIcon: Icons.person,
          borderBottomWidth: 1,
          highlightColor: Colors.white,
          borderBottomColor: Colors.white,
          backgroundShadowColor: Colors.white,
        ),
      ],
      onSelected: (index) {
        if (index == 0) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomeScreen.id,
            (route) => false,
            arguments: {
              'onBoad': false,
            },
          );
        }
        if (index == 1) {
          Navigator.pushNamed(context, CategoriesScreen.id);
        }
        if (index == 2) {
          Navigator.pushNamed(context, ShoppingCartSreen.id);
        }
        if (index == 3) {
          Navigator.pushNamed(context, FavoriteScreen.id);
        }
        if (index == 4) {
          Navigator.pushNamed(
            context,
            ProfileScreen.id,
          );
        }
        print('tab $index');
      },
    );
  }
}
