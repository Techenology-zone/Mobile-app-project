// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_tutor_mob_app/models/tutorial_post.dart';

import 'package:my_tutor_mob_app/utils/custom_drawer.dart';

//import 'package:my_tutor_mob_app/utils/custom_drawer.dart';
import 'package:my_tutor_mob_app/utils/tutorial_post_card.dart';

class HomePage extends StatefulWidget {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  Future<List<TutorialPost>> searchTutorialPosts(String searchText) async {
  try {
    QuerySnapshot querySnapshot = await _db
        .collection('tutorial_post')
        .where('posttitle', isGreaterThanOrEqualTo: searchText)
        .where('posttitle', isLessThan: searchText + 'z')
        .get();
    return querySnapshot.docs
        .map((doc) => TutorialPost.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  } catch (e) {
    print("Error searching tutorial posts: $e");
    return [];
  }
}

}

class _HomePageState extends State<HomePage> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
        drawer: CustomDrawer(),
        
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('tutorial_post').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final List<TutorialPost> tutorialPosts = snapshot.data!.docs
              .map((doc) => TutorialPost.fromMap(doc.data() as Map<String, dynamic>, doc.id))
              .toList();
            return Column(
              children: [
                // the search button
                Center(
                  child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: 
                            TextField(
                              onSubmitted: (value) {
                                // Trigger search function here with the entered value
                                // You can call a function to filter data based on value
                                //searchTutorialPosts(value);
                              },
                              decoration: InputDecoration(
                                hintText: 'Search for tutorials...',
                                hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                                prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.inversePrimary),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).colorScheme.inversePrimary),
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          
                          // ElevatedButton(
                            
                          //   onPressed: () {
                          //     // Add action for filter button here
                          //   },
                          //   child: Icon(Icons.filter_alt_rounded, color: Theme.of(context).colorScheme.primary,),
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                          //     padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          //   ),
                          // ),
                        ],
                      ),
                    ]
                ),
                
                    )
                    ),
                
                // the tutoria post cards
                Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //   crossAxisCount: 1,
                  //   childAspectRatio: 0.85,
                  //   crossAxisSpacing: 10,
                  //   mainAxisSpacing: 10,
                  // ),
                  itemCount: tutorialPosts.length,
                  itemBuilder: (context, index) {
                    final post = tutorialPosts[index];
                    return TutorialPostCard(tutorialPost: post,);
                  },
                ),
              ),
              ],
            );
          }
        )
        );
  }
}