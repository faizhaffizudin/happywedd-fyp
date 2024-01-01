
// import 'package:flutter/material.dart';

// class DetailsPage extends StatefulWidget {
//   const DetailsPage({super.key});

//   @override
//   State<DetailsPage> createState() => _DetailsPageState();
// }

// class _DetailsPageState extends State<DetailsPage> {
  
//   //controllers
//   TextEditingController bridenameController = TextEditingController();
//   TextEditingController groomnameController = TextEditingController();
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Details Page'),
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(20),
//         child: ListView(
//           children: [
//             const Text('Bride Name'),
//           const SizedBox(
//               height: 5,
//             ),
//             TextField(
//               controller: bridenameController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//               ),
//             ),

//             //space between two names
//             const SizedBox(
//               height: 10,
//             ),

//             const Text('Groom Name'),
//           const SizedBox(
//               height: 5,
//             ),
//             TextField(
//               controller: bridenameController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _date = '';
  String _location = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
                onSaved: (value) {
                  _date = value!;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
                onSaved: (value) {
                  _location = value!;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Process form data
                    // Use _name, _date, _location variables
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

