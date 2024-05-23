import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> getTotalUsers() async {
    final QuerySnapshot snapshot = await _firestore.collection("users").get();
    return snapshot.docs.length;
  }

  Future<int> getProviders() async {
    final QuerySnapshot snapshot = await _firestore
        .collection("users")
        .where("role", isEqualTo: "Provider")
        .get();
    return snapshot.docs.length;
  }

  Future<int> getStudents() async {
    final QuerySnapshot snapshot = await _firestore
        .collection("users")
        .where("role", isEqualTo: "Student")
        .get();
    return snapshot.docs.length;
  }

  Future<int> getFeedbacks() async {
    final QuerySnapshot snapshot =
        await _firestore.collection("Feedback").get();
    return snapshot.docs.length;
  }

  Future<Map<String, int>> getUserRegistrationData() async {
    QuerySnapshot snapshot = await _firestore.collection("users").get();

    Map<String, int> dayCounts = {
      'Monday': 0,
      'Tuesday': 0,
      'Wednesday': 0,
      'Thursday': 0,
      'Friday': 0,
      'Saturday': 0,
      'Sunday': 0,
    };

    for (var doc in snapshot.docs) {
      if (doc['registration_date'] != null) {
        DateTime date = (doc['registration_date'] as Timestamp).toDate();
        String day = DateFormat('EEEE').format(date);
        if (dayCounts.containsKey(day)) {
          dayCounts[day] = dayCounts[day]! + 1;
        }
      }
    }

    return dayCounts;
  }
}
