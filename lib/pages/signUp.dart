// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:happywedd1/pages/details.dart';
import 'package:happywedd1/pages/signIn.dart';
import 'package:happywedd1/services/auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  bool circular = false;
  AuthClass authClass = AuthClass();

  //  Future<void> sendEnrollmentNotification() async {
  //   try {
  //     firebase_auth.User? user = firebaseAuth.currentUser;
  //     if (user != null) {
  //       await user.sendEmailVerification();
  //       print('Multi-factor enrollment notification sent to ${user.email}');
  //       // You can handle UI updates or further actions upon successful sending of notification
  //     }
  //   } catch (e) {
  //     print('Error sending enrollment notification: $e');
  //     // Handle errors if any
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF7F4EFF),
                Color(0xFF5D37F7),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign Up an Account",
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 15,
              ),
              textItem("Email", _emailController, false), //email
              SizedBox(
                height: 15,
              ),
              textItem("Password", _pwdController, true), // password
              SizedBox(
                height: 15,
              ),
              signBtn(), // sign up btn
              SizedBox(
                height: 20,
              ),
              Text(
                "Or",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(
                height: 15,
              ),
              imageBtn(), //google btn
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Existing User?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (builder) => SignIn()),
                          (route) => false);
                    },
                    child: Text(
                      " Sign in",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget signBtn() {
    return InkWell(
      onTap: () async {
        setState(() {
          circular = true;
        });
        try {
          firebase_auth.UserCredential userCredential =
              await firebaseAuth.createUserWithEmailAndPassword(
                  email: _emailController.text, password: _pwdController.text);

          await FirebaseFirestore.instance
              .collection("users")
              .doc(userCredential.user!.uid)
              .set({
            "email": _emailController.text,
          });

          print(userCredential.user?.email);
          setState(() {
            circular = false;
          });

          // await sendEnrollmentNotification(); // Trigger MFA enrollment notification after successful sign-in
          
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => DetailsPage()),
              (route) => false);
        } catch (e) {
          String errorMessage =
              "An error occurred during sign up. Please try again.";

          if (e is firebase_auth.FirebaseAuthException) {
            // Handle specific Firebase Authentication errors
            switch (e.code) {
              case "email-already-in-use":
                errorMessage =
                    "The email address is already in use by another account. Please try again.";
                break;
              case "invalid-email":
                errorMessage = "The email address is not valid.";
                break;
              case "weak-password":
                errorMessage =
                    "The password provided is too weak. Minimum length of password is 7. Please try again.";
                break;
              // Add more cases as needed for other error codes
              default:
                break;
            }
          }

          final snackbar = SnackBar(content: Text(errorMessage));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);

          setState(() {
            circular = false;
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: const [
              Colors.deepPurple,
              Colors.white,
              Colors.deepPurple,
            ],
          ),
        ),
        child: Center(
          child: circular
              ? CircularProgressIndicator()
              : Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Color.fromARGB(255, 77, 0, 110),
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
        ),
      ),
    );
  }

  Widget imageBtn() {
    return InkWell(
      onTap: () async {
        await authClass.googleSignIn(context);
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 60,
        height: 60,
        child: Card(
          color: Colors.black,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/google.svg",
                height: 25,
                width: 25,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                "Continue with Google",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textItem(
      String labeltext, TextEditingController controller, bool obscureText) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 60,
      height: 55,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(
          fontSize: 17,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          labelText: labeltext,
          labelStyle: const TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 1.5,
              color: Colors.amber,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
