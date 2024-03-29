// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:happywedd1/pages/GreetScreen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:happywedd1/pages/signUp.dart';
import 'package:happywedd1/services/auth.dart';
import 'package:happywedd1/services/forgotPwd.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  bool circular = false;
  AuthClass authClass = AuthClass();

  @override
  void initState() {
    super.initState();
    tryAutoSignIn();
  }

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
                "Sign In",
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
              InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => ForgotPwd()),
                    (route) => false,
                  );
                },
                child: Text(
                  "Forgot password?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ), // password
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
                    "New User?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (builder) => SignUp()),
                        (route) => false,
                      );
                    },
                    child: Text(
                      " Sign up",
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
              await firebaseAuth.signInWithEmailAndPassword(
            email: _emailController.text,
            password: _pwdController.text,
          );
          print(userCredential.user?.email);
          setState(() {
            circular = false;
          });

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => GreetScreen()),
            (route) => false,
          );
        } catch (e) {
          String errorMessage =
              "An error occurred during sign in. Please try again.";

          if (e is firebase_auth.FirebaseAuthException) {
            // Handle specific Firebase Authentication errors
            switch (e.code) {
              case "user-not-found":
                errorMessage =
                    "No user found with this email address. Please try again.";
                break;
              case "wrong-password":
                errorMessage = "Incorrect password. Please try again.";
                break;
              case "invalid-email":
                errorMessage =
                    "The email address is not valid. Please try again.";
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
                  "Sign In",
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

  void tryAutoSignIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('user_email');
    String? userPassword = prefs.getString('user_password');

    if (userEmail != null && userPassword != null) {
      setState(() {
        circular = true;
      });

      try {
        // Use your AuthClass for signing in
        await authClass.signIn(userEmail, userPassword);

        setState(() {
          circular = false;
        });

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => GreetScreen()),
          (route) => false,
        );
      } catch (e) {
        String errorMessage =
            "An error occurred during auto sign-in. Please try again.";

        // Handle errors, e.g., if the saved credentials are no longer valid
        print('Auto sign-in error: $e');
        final snackbar = SnackBar(content: Text(errorMessage));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);

        setState(() {
          circular = false;
        });
      }
    }
  }
}
