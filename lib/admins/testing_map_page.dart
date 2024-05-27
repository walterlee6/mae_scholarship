// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class ExampleMapPage extends StatefulWidget {
//   const ExampleMapPage({super.key});

//   @override
//   State<ExampleMapPage> createState() => _ExampleMapPageState();
// }

// class _ExampleMapPageState extends State<ExampleMapPage> {
//   static const LatLng _pGooglePlex =
//       LatLng(37.42796133580664, -122.085749655962);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: _pGooglePlex,
//           zoom: 13,
//         ),
//         markers: {
//           Marker(
//             markerId: MarkerId("_currentLocation"),
//             icon: BitmapDescriptor.defaultMarker,
//             position: _pGooglePlex,
//           ),
//         },
//       ),
//     );
//   }
// }
