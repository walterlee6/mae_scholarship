import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:scholarship_application/admin/detailed_graph_page.dart';
import 'package:scholarship_application/components/my_wave.dart';
import 'package:scholarship_application/services/firestore_service.dart';

class WelcomingBoard extends StatefulWidget {
  const WelcomingBoard({super.key});

  @override
  State<WelcomingBoard> createState() => _WelcomingBoardState();
}

class _WelcomingBoardState extends State<WelcomingBoard> {
  final FirestoreService _firestoreService = FirestoreService();

  Future<int> _totalUsers = Future.value(0);
  Future<int> _providers = Future.value(0);
  Future<int> _students = Future.value(0);
  Future<int> _feedbacks = Future.value(0);

  int? _prevTotalUsers;
  int? _prevProviders;
  int? _prevStudents;
  int? _prevFeedbacks;

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void initState() {
    super.initState();
    // _totalUsers = _firestoreService.getTotalUsers();
    // _providers = _firestoreService.getProviders();
    // _students = _firestoreService.getStudents();
    // _feedbacks = _firestoreService.getFeedbacks();
    _fetchData();
  }

  void _fetchData() async {
    int totalUsers = await _firestoreService.getTotalUsers();
    int providers = await _firestoreService.getProviders();
    int students = await _firestoreService.getStudents();
    int feedbacks = await _firestoreService.getFeedbacks();

    setState(() {
      _prevTotalUsers = totalUsers;
      _prevProviders = providers;
      _prevStudents = students;
      _prevFeedbacks = feedbacks;

      _totalUsers = Future.value(totalUsers);
      _providers = Future.value(providers);
      _students = Future.value(students);
      _feedbacks = Future.value(feedbacks);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 200,
                  width: 200,
                  child: Lottie.asset(
                    'assets/Lottie/admin_welcoming_board.json',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  color:
                      const Color.fromARGB(255, 205, 10, 10).withOpacity(0.5),
                  alignment: Alignment.center,
                  child: Text(
                    'Welcome Admin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: IconButton(
                    icon: Icon(Icons.logout, color: Colors.white, size: 30),
                    onPressed: signOut,
                  ),
                ),
              ],
            ),
            // ClipPath(
            //   clipper: WaveClipper(),
            //   child: Container(
            //     height: 30,
            //     color: Color.fromARGB(255, 205, 10, 10),
            //   ),
            // ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  // _buildStatTile('Total Users', '1000', Icons.person_add),
                  // _buildStatTile('Providers', '15', Icons.school),
                  // _buildStatTile('All Users', '350', Icons.people),
                  // _buildStatTile('Feedbacks', '75', Icons.feedback),
                  FutureBuilder<int>(
                    future: _totalUsers,
                    builder: (context, snapshot) {
                      return _buildStatTile(
                        'Total Users',
                        snapshot.data.toString() ?? '0',
                        Icons.person_add,
                        _getChangeIcon(snapshot.data, _prevTotalUsers),
                      );
                    },
                  ),
                  FutureBuilder<int>(
                    future: _providers,
                    builder: (context, snapshot) {
                      return _buildStatTile(
                          'Providers',
                          snapshot.data.toString() ?? '0',
                          Icons.school,
                          _getChangeIcon(snapshot.data, _prevProviders));
                    },
                  ),
                  FutureBuilder<int>(
                    future: _students,
                    builder: (context, snapshot) {
                      return _buildStatTile(
                          'Students',
                          snapshot.data.toString() ?? '0',
                          Icons.people,
                          _getChangeIcon(snapshot.data, _prevStudents));
                    },
                  ),
                  FutureBuilder<int>(
                    future: _feedbacks,
                    builder: (context, snapshot) {
                      return _buildStatTile(
                          'Feedbacks',
                          snapshot.data.toString() ?? '0',
                          Icons.feedback,
                          _getChangeIcon(snapshot.data, _prevFeedbacks));
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Monthly Registrations",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailedGraphPage(),
                        ),
                      );
                    },
                    child: Text("View All"),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 300,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, 10),
                          FlSpot(1, 20),
                          FlSpot(2, 30),
                          FlSpot(3, 40),
                          FlSpot(4, 50),
                          FlSpot(5, 60),
                        ],
                        isCurved: true,
                        color: Colors.blue,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.blue.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile(
      String title, String count, IconData icon, Icon? changeIcon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.blue,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (changeIcon != null) ...[
                  SizedBox(height: 5),
                  changeIcon,
                ],
              ],
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Icon? _getChangeIcon(int? currentValue, int? previousValue) {
    if (previousValue == null || currentValue == null) return null;
    if (currentValue > previousValue) {
      return Icon(Icons.arrow_upward, color: Colors.green);
    } else if (currentValue < previousValue) {
      return Icon(Icons.arrow_downward, color: Colors.red);
    } else {
      return Icon(Icons.arrow_forward, color: Colors.grey);
    }
  }
}
