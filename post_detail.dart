// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_tutor_mob_app/models/tutorial.dart';
import 'package:my_tutor_mob_app/models/tutorial_post.dart';

class PostDetail extends StatefulWidget {
  
  final TutorialPost tutorialPost;
  PostDetail({Key? key, required this.tutorialPost}) : super(key: key);

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  bool isFavorited = false;

  Tutorial? tutorial;

  // late String userFirstName = '';
  @override
  void initState() {
    super.initState();
    _fetchTutorialDetails();
  }

  Future<void> _fetchTutorialDetails() async {
    Tutorial? fetchedTutorial = await TutorialPost.fetchAssociatedTutorial(widget.tutorialPost.tutorialId);
    
    //await fetchUserDetails(tutorial!.user);
    // print("Reached this");
    setState(() {
      tutorial = fetchedTutorial;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (tutorial == null) {
      return Center(
        child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Change the color of the progress indicator
              strokeWidth: 5, // Adjust the thickness of the circle
              backgroundColor: Colors.grey, // Set the background color behind the indicator
),
      );
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.inversePrimary),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: Image.network(
                  widget.tutorialPost.coverImage,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,     
                ),
              ),
            ),
            SizedBox(height: 32),
        
            Text(
              widget.tutorialPost.postTitle,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_pin, color: Theme.of(context).colorScheme.inversePrimary),
                SizedBox(width: 8),
                Text(tutorial!.location, style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.inversePrimary)),
              ],
            ),
            SizedBox(height: 8),
            Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          Icons.star,
                          color: index < widget.tutorialPost.avgRating ? Colors.yellow : Colors.grey,
                          size: 28.0,
                        );
                      }),
                    ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.attach_money,  size: 30, color: Theme.of(context).colorScheme.inversePrimary),
                SizedBox(width: 8),
                Text(
                  '${tutorial!.price.toString()} ETB ${tutorial!.paymentInterval}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color:  Theme.of(context).colorScheme.inversePrimary),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Educational Level: ${tutorial!.educationalLevel}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
           SizedBox(height: 16),
          Text(
              'Subjects: ${tutorial!.subjects}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
            widget.tutorialPost.postDescription,
              style: TextStyle(fontSize: 17, color: Theme.of(context).colorScheme.inversePrimary),
            ),
            SizedBox(height: 16),
            Text(
              'Contact Address: +251999999999',
              style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ],
        ),
      ),
    );
  }
}
