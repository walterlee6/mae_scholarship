import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:scholarship_application/components/my_button.dart';
import 'package:scholarship_application/components/my_textfield.dart';
import '../utils/colors.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> handleLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      print('Error code: ${e.code}'); // password still cannot validate
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = "The email address is badly formatted.";
          break;
        case 'invalid-credential':
          errorMessage = "Invalid email or password.";
          break;
        case 'wrong-password':
          errorMessage = "Wrong password provided for that user.";
          break;
        case 'channel-error':
          errorMessage = "Empty field detected.";
          break;
        default:
          errorMessage = "An error occurred. Please try again later.";
      }
      print('Error message: $errorMessage');
      showErrorMessage(errorMessage);
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) { // forgot password hasnt done yet
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 147, 68),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: Row(
                  //     children: [
                  //       Icon(Icons.arrow_back_ios),
                  //       Text(
                  //         "Back",
                  //         style: TextStyle(
                  //           fontSize: 20,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 20),
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 35,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Login to continue.",
                    style: TextStyle(
                      fontSize: 24,
                      // color: Color.fromRGBO(130, 128, 128, 1),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: LottieBuilder.asset(
                      "assets/Lottie/chicken.json",
                      width: 700,
                      height: 250,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(72, 72, 72, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  MyTextField(
                    controller: emailController,
                    hintText: "Your Email",
                    obscureText: false,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Text(
                          "Password",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(72, 72, 72, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  MyTextField(
                    controller: passwordController,
                    hintText: "Your Password",
                    obscureText: true,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Color.fromRGBO(95, 95, 95, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  MyButton(
                    onTap: handleLogin,
                    text: "Login",
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Center(
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                          color: Color.fromRGBO(95, 95, 95, 1),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
