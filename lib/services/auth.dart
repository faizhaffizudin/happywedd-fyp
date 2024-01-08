import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:happywedd1/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthClass {
  static const List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: scopes,
  );

  FirebaseAuth auth = FirebaseAuth.instance;
  final storage = const FlutterSecureStorage();

  Future<bool> isUserSignedIn() async {
    User? user = auth.currentUser;
    return user != null;
  }

  Future<void> autoSignIn(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('user_email');
    String? userPassword = prefs.getString('user_password');

    if (userEmail != null && userPassword != null) {
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: userEmail,
          password: userPassword,
        );

        // Store user data in Firestore
        await storeUserDataInFirestore(userCredential);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => const HomePage()),
          (route) => false,
        );
      } catch (e) {
        // Handle errors, e.g., if the saved credentials are no longer valid
        print('Auto sign-in error: $e');
      }
    }
  }

  Future<void> googleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        try {
          UserCredential userCredential =
              await auth.signInWithCredential(credential);

          // Store user data in Firestore
          await storeUserDataInFirestore(userCredential);

          storeTokenAndData(userCredential);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => const HomePage()),
              (route) => false);
        } catch (e) {
          final snackbar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      } else {
        const snackbar =
            SnackBar(content: Text("Unable to sign in. Try again."));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<void> storeUserDataInFirestore(UserCredential userCredential) async {
    User? user = userCredential.user;

    // Check if the user is already in the 'users' collection
    DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
        .instance
        .collection("users")
        .doc(user?.uid)
        .get();

    if (!userDoc.exists) {
      // If the user is not in the collection, add their email
      await FirebaseFirestore.instance.collection("users").doc(user?.uid).set({
        'email': user?.email,
        // Add other user details as needed
      });
    }
  }

  Future<void> storeTokenAndData(UserCredential userCredential) async {
    await storage.write(
        key: "token", value: userCredential.credential?.token.toString());
    await storage.write(
        key: "userCredential", value: userCredential.toString());
  }

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  Future<void> logOut() async {
    try {
      await _googleSignIn.signOut();
      await auth.signOut();
      await storage.delete(key: "token");
    } catch (e) {}
  }

  Future<void> changeEmail(String newEmail) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateEmail(newEmail);
        // You may want to update the email in your Firestore users collection too.
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .update({'email': newEmail});
      }
    } catch (e) {
      // Handle errors here (e.g., display an error message).
      print("Error changing email: $e");
    }
  }

  signIn(String userEmail, String userPassword) {}
}
