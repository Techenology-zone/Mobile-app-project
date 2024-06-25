// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors


import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:my_tutor_mob_app/pages/favorites_page.dart';
import 'package:my_tutor_mob_app/pages/home_page.dart';
import 'package:my_tutor_mob_app/pages/self_profile_page.dart';

import 'package:my_tutor_mob_app/utils/custom_drawer.dart';
import 'package:my_tutor_mob_app/utils/new_app_bar.dart';
class PageInitializer extends StatefulWidget {
  
  const PageInitializer({super.key});

  @override
  State<PageInitializer> createState() => _PageInitializerState();
}

class _PageInitializerState extends State<PageInitializer> {
    void _navigatePages(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
 
  int _selectedIndex= 0;
  
  final List _pages = [
    HomePage(),
    FavoritesPage(),
    SelfProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(

          appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          // leading: IconButton(
          // icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.inversePrimary,), // Replace with your icon (e.g., Icons.menu)
          // onPressed: () {
          //   Scaffold.of(context).openDrawer();
          // },
          // ),
          title: NewAppBar()
          ),

          drawer: CustomDrawer(),
          bottomNavigationBar: Padding(
        
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
          child: GNav(
      
          backgroundColor: Theme.of(context).colorScheme.background,
          gap: 8,
      
          iconSize: 25,
          tabBackgroundColor: Theme.of(context).colorScheme.tertiary,
          padding: EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.inversePrimary,
          activeColor: Theme.of(context).colorScheme.inversePrimary,
          
          onTabChange: (index){

           _navigatePages(index);
            
            
          },
          tabs: [
            GButton(icon: Icons.home_outlined, text: "Home"),
            GButton(icon: Icons.favorite_border, text: "Favorites"),
            GButton(icon: Icons.person_outlined, text: "Me"),
          ],
        ),
      ),
      body: _pages[_selectedIndex]
      );
      
    
  }
}