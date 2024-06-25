
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_tutor_mob_app/utils/new_text_form_field.dart';


class UserDetailDialogBox extends StatefulWidget {
  @override
  _UserDetailDialogBoxState createState() => _UserDetailDialogBoxState();
}

class _UserDetailDialogBoxState extends State<UserDetailDialogBox> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _aboutMeController = TextEditingController();
  final _contactDetailsController = TextEditingController();


  // sae user detail information
  Future _saveUserDetail(
    //String userId, 
    String firstName, 
    String lastName, 
    String bio, 
    String aboutMe, 
    String contactDetails,
    ) async {
      try{
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
        String userId = user.uid;
        print('User ID: $userId');

        // save detail 
        DocumentReference docRef = await FirebaseFirestore.instance.collection('users').doc(userId);
        await docRef.set({
        'firstName': firstName,
        'lastName': lastName,
        'bio': bio,
        'aboutMe': aboutMe,
        'contactDetails': contactDetails,
        //'profilePicUrl': profilePicUrl,
        // Add more fields as needed
      });
      
      // Success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Success!')),
      );
      print('User details saved successfully');
      } else {
        print('User is not logged in.');
      }

      } catch (e){
        showDialog(context: context, builder: (context)=>AlertDialog(
      title: Text(e.toString()),
    ));
    }
  }
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    _aboutMeController.dispose();
    _contactDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text('Tell us more about yourself!'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                NewTextFormField(
                  controller: _firstNameController, 
                  labelText: 'First Name', 
                  warningMessage: 'Please enter your first name'
                  ),

                NewTextFormField(
                  controller: _lastNameController, 
                  labelText: 'Last Name', 
                  warningMessage: 'Please enter your last name'
                  ),
                NewTextFormField(
                  controller: _bioController, 
                  labelText: 'Bio', 
                  warningMessage: 'Please enter your Bio'
                  ),
                NewTextFormField(
                  controller: _aboutMeController, 
                  labelText: 'About Me', 
                  warningMessage: 'Please enter your About Me'
                  ),
                NewTextFormField(
                  controller: _contactDetailsController, 
                  labelText: 'Contact Details', 
                  warningMessage: 'Please enter your Contact Details'
                  ),
                SizedBox(height: 10),
                
              ],
            ),
          ),
        ),
        actions: <Widget>[
          
          ElevatedButton(
            
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Save profile details or perform other actions here

                _saveUserDetail(
                  _firstNameController.text.trim(), 
                  _lastNameController.text.trim(), 
                  _bioController.text, 
                  _aboutMeController.text, 
                  _contactDetailsController.text
                 
                  );
                Navigator.of(context).pop(); // Close the dialog
              }
            },
            child: Text('Save'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Skip for now'),
          ),
        ],
      ),
    );
  }
}