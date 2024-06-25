// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_tutor_mob_app/models/tutorial_post.dart';
import 'package:my_tutor_mob_app/utils/new_text_form_field.dart';
import 'package:my_tutor_mob_app/utils/new_button.dart';

class PostTutorial extends StatefulWidget {
  final String tutorialId;
  final String tutorialName;

  PostTutorial({Key? key, required this.tutorialId, required this.tutorialName}) : super(key: key);

  @override
  _PostTutorialState createState() => _PostTutorialState();
}

class _PostTutorialState extends State<PostTutorial> {
  final TextEditingController postTitleController = TextEditingController();
  final TextEditingController postDescriptionController = TextEditingController();
  final TextEditingController coverImageController = TextEditingController();
  FilePickerResult? _selectedCoverImage;

  Future<void> _saveTutorialPost() async {
    if (_selectedCoverImage != null) {
      // Upload the cover image
      String? coverImageUrl = await _uploadCoverImage(_selectedCoverImage);
      if (coverImageUrl != null) {
        // Create a tutorial post object
        final tutorialPost = TutorialPost(
          tutorialId: widget.tutorialId,
          postTitle: postTitleController.text,
          postDescription: postDescriptionController.text,
          coverImage: coverImageUrl,
          ratingsCount: 0,
          avgRating: 0,
        );

        // Save to the database
        _saveToDatabase(tutorialPost);
      }
    } else {
      print('Cover image is not selected');
    }
  }

  void _saveToDatabase(TutorialPost tutorialPost) async {
    CollectionReference dbTutorials = FirebaseFirestore.instance.collection('tutorial_post');

    await dbTutorials.add(tutorialPost.toMap())
        .then((value) =>  showDialog(context: context, builder: (context) => AlertDialog(
        title: Text("Post Added"),)))
        .catchError((error) =>       showDialog(context: context, builder: (context) => AlertDialog(
        title: Text("Failed to Add Post"),
      )));
  }

  Future<FilePickerResult?> pickCoverImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    setState(() {
      _selectedCoverImage = result;
    });

    return result;
  }

  Future<String?> _uploadCoverImage(FilePickerResult? uploadedCover) async {
    if (uploadedCover != null) {
      PlatformFile file = uploadedCover.files.first;

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          final storageRef = FirebaseStorage.instance.ref().child('post_cover_pics/${widget.tutorialId}');
          UploadTask uploadTask = storageRef.putData(file.bytes!);
          TaskSnapshot snapshot = await uploadTask;
          String downloadUrl = await snapshot.ref.getDownloadURL();

          return downloadUrl;
        } catch (e) {
          print('Error uploading cover picture: $e');
        }
      } else {
        print('No user is signed in.');
      }
    } else {
      print('User canceled the picker.');
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 16.0),
            Center(
              child: Text(
                'Post ${widget.tutorialName}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 32.0),
            NewTextFormField(
              controller: postTitleController,
              labelText: "Title for the Post (Tutorial)",
              warningMessage: "Please enter the Title of the post",
            ),
            SizedBox(height: 16.0),
            NewTextFormField(
              controller: postDescriptionController,
              labelText: "Description",
              warningMessage: "Please enter the Description",
            ),
            SizedBox(height: 16.0),
            NewButton(
              onTap: pickCoverImage,
              text: 'Upload Cover Photo',
              icon: Icons.upload,
            ),
            if (_selectedCoverImage != null) ...[
              SizedBox(height: 16.0),
              Text('Selected Image: ${_selectedCoverImage!.files.first.name}', style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
            ],
            SizedBox(height: 32.0),
            NewButton(
              onTap: _saveTutorialPost,
              text: "Post",
              icon: Icons.post_add,
            ),
          ],
        ),
      ),
    );
  }
}
