// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_tutor_mob_app/pages/user_detail_dialog_box.dart';

import 'package:my_tutor_mob_app/utils/new_button.dart';

class SelfProfilePage extends StatefulWidget {

  @override
  State<SelfProfilePage> createState() => _SelfProfilePageState();
}

class _SelfProfilePageState extends State<SelfProfilePage> {

 
  Widget showDialogeBox(){
    return UserDetailDialogBox();
  }
  Future<void> pickAndUploadImage() async {
    // Pick an image
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          // Upload the image to Firebase Storage
          final storageRef = FirebaseStorage.instance.ref().child('profile_pictures/${user.uid}');
          UploadTask uploadTask = storageRef.putData(file.bytes!);
          TaskSnapshot snapshot = await uploadTask;
          final downloadUrl = await snapshot.ref.getDownloadURL();

          // Update the user's profile in Firestore
          
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'profile_picture': downloadUrl,
          }, SetOptions(merge: true));

          setState(() {
            print('Profile picture uploaded successfully: $downloadUrl');
          });

          
        } catch (e) {
          print('Error uploading profile picture: $e');
        }
      } else {
        print('No user is signed in.');
      }
    } else {
      print('User canceled the picker.');
    }
  }

  Widget getProfilePicture() {
  return FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      }

      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }

      if (snapshot.hasData && snapshot.data!.exists) {
        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
        String? profilePictureUrl = data['profile_picture'];

        if (profilePictureUrl != null && profilePictureUrl.isNotEmpty) {
          return CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profilePictureUrl)
                  
            );
          //Image.network(profilePictureUrl, height: 200);
        } else {
          return CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('images/default_avatar.png'),
                  
            );
        }
      }

      return Text('No data available');
    },
  );
}

  ///get user details
  Future<Map<String, dynamic>> getUserDetails() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (snapshot.exists) {
        // Map of user details
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        return userData;
      } else {
        print('Document does not exist');
        return {};
      }
    } catch (e) {
      print('Error fetching user details: $e');
      return {};
    }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            // Extract user details
            Map<String, dynamic> userData = snapshot.data!;
            String firstName = userData['firstName'] ?? '';
            String lastName = userData['lastName'] ?? '';
            String email = userData['email'] ?? '';
            String bio = userData['bio'] ?? '';
            String aboutMe = userData['aboutMe'] ?? '';
            String contactDetails = userData['contactDetails'] ?? '';
            //String profilePictureUrl = userData['profilePicture'] ?? '';
          
            return SingleChildScrollView(
              child: Container(
                color: Theme.of(context).colorScheme.background,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    
                      // the profile picture 
                      getProfilePicture(),

                      // the update button
                      ElevatedButton.icon(
                        onPressed: pickAndUploadImage,
                        icon: Icon(Icons.image),
                        label: Text('Change Profile'),
                      ),
                        SizedBox(height: 10),
              
                    /// name of the user
                    Text(
                      '$firstName  $lastName',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    
                    SizedBox(height: 10),

                    Container(
                      
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                bio,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                  fontSize: 20,
                                ),
                              ),
                          IconButton(
                              icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.inversePrimary),
                                  onPressed: () {},
                            ),
                        ],
                      ),
                      
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            aboutMe,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.inversePrimary,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.inversePrimary),
                                  onPressed: () {},
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Contact Detail:',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.inversePrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Align(
                        alignment: Alignment.centerLeft,
                        
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(contactDetails, style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 16,
                          ), ),
                          //   Text("Email: tutoremail@gmail.com", style: TextStyle(
                          //   color: Theme.of(context).colorScheme.inversePrimary,
                          //   fontSize: 16,
                          // ),),
                          //   Text("@instagramusername", style: TextStyle(
                          //   color: Theme.of(context).colorScheme.inversePrimary,
                          //   fontSize: 16,
                          // ),),
                          //   Text("@tgusername", style: TextStyle(
                          //   color: Theme.of(context).colorScheme.inversePrimary,
                          //   fontSize: 16,
                          // ),),        
                          ]  
                        ),
                      ),
                          IconButton(
                              icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.inversePrimary),
                                  onPressed: () {},
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
        }
        else {
          return Center(
          child: Container(
                color: Theme.of(context).colorScheme.background,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    
                      // the profile picture 
                      getProfilePicture(),

                      // the update button
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: pickAndUploadImage,
                        icon: Icon(Icons.image),
                        label: Text('Change Profile'),
                      ),
                        SizedBox(height: 10),

                        NewButton(
                          onTap: showDialogeBox, 
                          text: "Add Personal Info", 
                          icon: Icons.details)
                        
                        ]
              ))
        );
          
        }
        }

      )
    );
  }
}