import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scholarship_application/barchart/bar_graph.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

void signOut() async {
  await FirebaseAuth.instance.signOut();
}

class _ChartState extends State<Chart> {
  List<double> weeklySummary = [
    100.0,
    200.0,
    180.0,
    160.0,
    170.0,
    200.0,
    150.0,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signOut,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      //   body: Center(
      //     child: Text(
      //       "LOGGED IN AS: " + user.email!,
      //       style: TextStyle(
      //         fontSize: 20,
      //         color: Colors.grey[700],
      //       ),
      //     ),
      //   ),
      // );
      // return Scaffold(
      body: Center(
        child: SizedBox(
          height: 400,
          child: BarGraph(
            weeklySummary: weeklySummary,
          ),
        ),
      ),
    );
  }
}
