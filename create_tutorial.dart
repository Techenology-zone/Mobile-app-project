// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_tutor_mob_app/models/tutorial.dart';
import 'package:my_tutor_mob_app/utils/new_text_form_field.dart';
import 'package:my_tutor_mob_app/utils/drop_down_input_field.dart';
import 'package:my_tutor_mob_app/utils/new_button.dart';
import 'package:my_tutor_mob_app/utils/new_options_field.dart';

class CreateTutorial extends StatefulWidget {

  CreateTutorial({super.key});

  @override
  State<CreateTutorial> createState() => _CreateTutorialState();
}

class _CreateTutorialState extends State<CreateTutorial> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController tutorNameController = TextEditingController();

  final TextEditingController educationLevelController = TextEditingController();

  final TextEditingController subjectsController = TextEditingController();

  final TextEditingController locationController = TextEditingController();

  final TextEditingController paymentIntervalController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  //initialize the model
  void _saveTutorial() async {
    final tutorial = Tutorial(
      user: FirebaseAuth.instance.currentUser?.uid?? '',
      tutorialName: tutorNameController.text,
      educationalLevel: educationLevelController.text,
      subjects: subjectsController.text,
      location: locationController.text,
      paymentInterval: paymentIntervalController.text,
      price: double.parse(priceController.text),
    );

    _saveToDatabase(tutorial);
    

  }

  void _saveToDatabase(Tutorial tutorial) async {

     CollectionReference db_tutorials =
        FirebaseFirestore.instance.collection('tutorials');

    // Add a new document with a generated ID
    await db_tutorials.add(tutorial.toMap())
        .then((value) => showDialog(context: context, builder: (context) => AlertDialog(
        title: Text('Tutorial Added Successfully'),
      )))
        .catchError((error) => showDialog(context: context, builder: (context) => AlertDialog(
        title: Text('Failed to Add tutrial'),
      )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text("Create Tutorials"),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              SizedBox(height: 16.0),
              Center(
                child: Text(
                  'Create Tutorial',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 32.0),
        
              // name of the tutorial
              NewTextFormField(
                controller: tutorNameController, 
                labelText: "Tutorial Name", 
                warningMessage: "Please Enter Tutorial Name",
                ),
              
              SizedBox(height: 16.0),
        
              // educational level
              NewDropDownInput(
                options: ["KG 1 - KG 3", "Grade 1-4", "Grade 5-8", "Grade 1-8", "Grade 9-12", "Grade 1-12", "Grade 5-12"], 
                hintText: "Education Level", 
                controller: educationLevelController),
              SizedBox(height: 16.0),
        
            // subjects 
             NewOptionsField(
              options: ["Mathematics", "English", "Biology", "Chemistry", "Physics", "General Sceince", "Geography", "History"], 
              hintText: "Subjects", 
              controller: subjectsController),
              SizedBox(height: 16.0),
              //loocaton
              NewTextFormField(
                controller: locationController, 
                labelText: 'Location (City)', 
                warningMessage: "Please enter the location (city)"
                ),
          
              SizedBox(height: 16.0),
              NewDropDownInput(
                options: ["per day", "per week", "per month"], 
                hintText: "Payment Interval", 
                controller: paymentIntervalController),
        
              SizedBox(height: 26.0),
              
        
                NewTextFormField(
                controller: priceController, 
                labelText: 'Price in ETB', 
                warningMessage: "Please enter the price in ETB"
                ),
        
              SizedBox(height: 32.0),
        
              NewButton(
                onTap: _saveTutorial,
                text: "Create", 
                icon: Icons.add
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return TextField(
      decoration: InputDecoration(
        
        hintText: hint,
        //filled: true,
        //fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      style: TextStyle(color: Colors.black),
    );
  }
}