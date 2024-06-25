
import 'package:flutter/material.dart';

import 'package:my_tutor_mob_app/services/auth/auth_service.dart';
import 'package:my_tutor_mob_app/utils/new_button.dart';
import 'package:my_tutor_mob_app/utils/new_text_field.dart';

class SigninPage extends StatefulWidget {
  

  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  Future signIn() async{
    
    final _authService = AuthService();

    try {
      await _authService.signInWithEmailAndPassword(
        emailController.text.trim(), passwordController.text);
        print("user_signed in");
        
        Navigator.pushReplacementNamed(context,'/home');
      
    }
    catch (e) {
      showDialog(context: context, builder: (context) => AlertDialog(
        title: Text(e.toString()),
      ));
    }
  }

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
              Icons.lock_open_rounded,
              size: 72,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            //message
            Text(
              "HELLO!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            SizedBox(height: 20),

            //email textfield
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
      
              // button
              NewButton(    
                text: "Sign In", 
                icon: Icons.login,
                onTap: signIn,
                // {
                //   Navigator.pushNamed(context, "/home");
                // },
                ),
                // text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New here?", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, '/sign_up');
                      },
                      child: Text("Register Now", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontWeight: FontWeight.bold))),
        
                  ],
                )
          ],
        ),
      )
    );
  }
}