import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:happywedd1/pages/signIn.dart';

class ForgotPwd extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple, // Match the color with your SignUp page
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Enter Email",
                labelStyle: TextStyle(
                  fontSize: 17,
                  color: Colors.black, // Match the color with your SignUp page
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    width: 1.5,
                    color:
                        Colors.amber, // Match the color with your SignUp page
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.grey, // Match the color with your SignUp page
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text.trim();
                if (email.isNotEmpty) {
                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: email);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Password Reset Email Sent"),
                          content: Text(
                            "Please check your email for instructions on how to reset your password.",
                            style: TextStyle(color: Colors.black),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("OK"),
                            ),
                          ],
                          backgroundColor: Colors
                              .purple, // Match the color with your SignUp page
                        );
                      },
                    );
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Error"),
                          content: Text(
                            "An error occurred. Please try again.",
                            style: TextStyle(color: Colors.black),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("OK"),
                            ),
                          ],
                          backgroundColor: Colors
                              .purple, // Match the color with your SignUp page
                        );
                      },
                    );
                  }
                }
              },
              child:
                  Text("Reset Password", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                primary:
                    Colors.deepPurple, // Match the color with your SignUp page
              ),
            ),
            ElevatedButton(
              // Use ElevatedButton for "Back to Sign In"
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn()),
                );
              },
              child: Text("Back to Sign In",
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                primary:
                    Colors.deepPurple, // Match the color with your SignUp page
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
