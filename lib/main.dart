import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scholarship_application/pages/auth_page.dart';
import 'package:scholarship_application/pages/login_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scholarship Application',
      theme: ThemeData(fontFamily: 'Lato'),
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
