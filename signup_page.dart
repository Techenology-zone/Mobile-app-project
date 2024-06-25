// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_tutor_mob_app/pages/user_detail_dialog_box.dart';
import 'package:my_tutor_mob_app/services/auth/auth_service.dart';
import 'package:my_tutor_mob_app/utils/new_button.dart';
import 'package:my_tutor_mob_app/utils/new_text_field.dart';

class SignupPage extends StatefulWidget {

  SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void signUp() async {
    final _authService = AuthService();
 
    // fi password match -> sign up
    if (passwordController.text == confirmPasswordController.text){
      try{
      await _authService.signUpWithEmailAndPassword(
        emailController.text.trim(), 
        passwordController.text);

        print("user created successfully!");
        final user = FirebaseAuth.instance.currentUser;
        print(user?.email);


        Navigator.pushReplacementNamed(context, '/home');
        showDialog(context: context, builder: (context) => UserDetailDialogBox());
    }
   catch (e){
    showDialog(context: context, builder: (context)=>AlertDialog(
      title: Text(e.toString()),
    ));
  } 
  } else {
    showDialog(context: context, builder: (context)=>AlertDialog(
      title: Text("Password Doesn't Match"),
    ));
  }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.background,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(
              Icons.person_add_alt_1,
              size: 72,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            //message
            Text(
              "WELCOME!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
              //email text field
            NewTextField(
              controller: emailController, 
              hintText: "Email Address", 
              obscureText: false
              ),
            //passwrd
              NewTextField(
              controller: passwordController, 
              hintText: "Password", 
              obscureText: true
              ),
              NewTextField(
              controller: confirmPasswordController, 
              hintText: "Confirm Password", 
              obscureText: true
              ),

              // button
              NewButton(    
                text: "  Sign Up", 
                icon: Icons.person_add_rounded,
                onTap: signUp,
                // {
                //   Navigator.pushNamed(context, "/home");
                // }
                ),
                // text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Have an account?", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, '/sign_in');
                      },
                      child: Text("Sign in here", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontWeight: FontWeight.bold))),
        
                  ],
                )
          ],
        ),
      )
    );
  }
}