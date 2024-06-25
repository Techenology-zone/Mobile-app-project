// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_tutor_mob_app/utils/tutorial_card.dart';

class MyTutorials extends StatelessWidget {


  Stream<QuerySnapshot> _fetchMyTutorials() {
    return FirebaseFirestore.instance
        .collection('tutorials')
        .where('user', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(),

      body: StreamBuilder<Object>(
        stream: _fetchMyTutorials(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No tutorials found.'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Created Tutorials',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 0.6,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> tutorialData = document.data() as Map<String, dynamic>;
                    return TutorialCard(tutorialData: tutorialData);
                  },
                ),
              ),
              ],
            ),
          );
        }
      ),
    );
  }
}