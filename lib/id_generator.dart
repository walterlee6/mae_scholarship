// import 'package:cloud_firestore/cloud_firestore.dart';

// class IdGenerator {
//   final CollectionReference _idGenerator = FirebaseFirestore.instance.collection('id_generator');

//   Future<String> generateId(String userType) async {
//     try {
//       DocumentSnapshot idDocSnapshot = await _idGenerator.doc('IDs').get();

//       if (!idDocSnapshot.exists) {
//         throw IDGeneratorException("ID document does not exist");
//       }

//       Map<String, dynamic> data = idDocSnapshot.data() as Map<String, dynamic>;

//       if (data == null || !data.containsKey(userType) || data[userType] is! int) {
//         throw IDGeneratorException("Invalid or missing data for user type: $userType");
//       }

//       int currentID = data[userType] as int;
//       int nextID = currentID + 1;

//       await _idGenerator.doc('IDs').update({userType: nextID});

//       return '${_getIdPrefix(userType)}${nextID.toString().padLeft(3, '0')}';
//     } catch (e) {
//       print('Error generating ID: $e');
//       throw IDGeneratorException("Error generating ID");
//     }
//   }

//   String _getIdPrefix(String userType) {
//     const Map<String, String> idPrefixes = {
//       'Admin': 'A',
//       'Student': 'S',
//       'Provider': 'P',
//     };

//     return idPrefixes[userType] ?? '';
//   }
// }

// class IDGeneratorException implements Exception {
//   final String message;
//   IDGeneratorException(this.message);
// }