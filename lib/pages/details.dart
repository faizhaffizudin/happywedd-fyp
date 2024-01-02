
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
  const DetailsPage({Key? key}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final TextEditingController _nameBrideController = TextEditingController();
  final TextEditingController _nameGroomController = TextEditingController();
  DateTime? _dateNikah;
  DateTime? _dateSanding;
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.purple,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text(
              "Register an Account",
              style: TextStyle(
                fontSize: 35,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          SizedBox(
            height: 15,
          ),
          textItem("Name of Bride", _nameBrideController, false),
          SizedBox(
            height: 15,
          ),
          textItem("Name of Groom", _nameGroomController, false),
          SizedBox(
            height: 15,
          ),
          dateItem("Date of Nikah", _dateNikah),
          SizedBox(
            height: 15,
          ),
          dateItem("Date of Sanding", _dateSanding),
          SizedBox(
            height: 15,
          ),
          locationItem(), // Location field using Google Maps

          // Remaining code...
        ),
      ),
    );
  }

  Widget dateItem(String labelText, DateTime? date) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 60,
      height: 55,
      child: ListTile(
        title: Text(
          labelText,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: date != null
            ? Text(
                '${date.day}/${date.month}/${date.year}',
                style: TextStyle(color: Colors.white),
              )
            : null,
        onTap: () {
          _selectDate(context, labelText);
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, String labelText) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        if (labelText == "Date of Nikah") {
          _dateNikah = pickedDate;
        } else if (labelText == "Date of Sanding") {
          _dateSanding = pickedDate;
        }
      });
    }
  }

  Widget locationItem() {
    return InkWell(
      onTap: () async {
        LatLng? selectedLocation = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MapSelectionScreen()),
        );

        if (selectedLocation != null) {
          setState(() {
            _selectedLocation = selectedLocation;
          });
        }
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 60,
        height: 55,
        child: ListTile(
          title: Text(
            'Select Location',
            style: TextStyle(color: Colors.white),
          ),
          subtitle: _selectedLocation != null
              ? Text(
                  'Latitude: ${_selectedLocation!.latitude}, Longitude: ${_selectedLocation!.longitude}',
                  style: TextStyle(color: Colors.white),
                )
              : null,
        ),
      ),
    );
  }

  // Remaining code...
}



