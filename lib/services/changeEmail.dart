import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangeEmailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    Future<void> changeEmail(String newEmail) async {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        // Execute email update in Firebase Authentication
        await FirebaseAuth.instance.currentUser!.updateEmail(newEmail);
        // Email updated successfully
        print('Email updated successfully.');
        // Provide user feedback (e.g., show a success message)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email updated successfully')),
        );
      } catch (e) {
        // Handle errors
        print('Error updating email: $e');
        // Provide user feedback about the error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating email: $e')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Change Email'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'New Email',
                hintText: 'Enter your new email',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Call the function to change email when the button is pressed
                changeEmail(emailController.text.trim());
              },
              child: Text('Change Email'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Change Email Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeEmailPage(),
    );
  }
}
