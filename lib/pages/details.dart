
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
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  DateTime? _selectedDate;
  LatLng? _selectedLocation;

  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _selectedLocation = LatLng(37.42796133580664, -122.085749655962);
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

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
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapSelectionScreen(),
                    ),
                  ).then((selectedLocation) {
                    if (selectedLocation != null) {
                      setState(() {
                        _selectedLocation = selectedLocation;
                        // Perform any operations with the selected location
                      });
                    }
                  });
                },
                child: Text('Select Location'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Process form data
                    // Use _name, _selectedDate, _selectedLocation variables
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

class MapSelectionScreen extends StatefulWidget {
  @override
  _MapSelectionScreenState createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  GoogleMapController? _mapController;
  CameraPosition? _currentCameraPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              // Pass back the selected location to the previous screen
              Navigator.pop(context, _currentCameraPosition!.target);
            },
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            _mapController = controller;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962),
          zoom: 15.0,
        ),
        onTap: (LatLng latLng) {
          _mapController?.animateCamera(
            CameraUpdate.newLatLng(latLng),
          );
        },
      ),
    );
  }
}


