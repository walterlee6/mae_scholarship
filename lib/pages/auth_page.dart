import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scholarship_application/provider/chart.dart';
import 'package:scholarship_application/student/home_page.dart';
import 'package:scholarship_application/pages/login_or_register_page.dart';
import 'package:scholarship_application/admin/admin_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            User? user = FirebaseAuth.instance.currentUser;

            if (user != null) {
              String? userEmail = user.email;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('email', isEqualTo: userEmail)
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  if (querySnapshot.docs.isNotEmpty) {
                    return querySnapshot.docs.first;
                  } else {
                    return Future.value(null);
                  }
                }),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasData) {
                    final role = snapshot.data!['role'];

                    if (role == 'Student') {
                      return HomePage();
                    } else if (role == 'Admin') {
                      return AdminPage();
                    } else if (role == 'Provider') {
                      return Chart();
                    } else {
                      return Container();
                    }
                  } else {
                    return Container();
                  }
                },
              );
            } else {
              return LoginOrRegisterPage();
            }
          } else {
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
