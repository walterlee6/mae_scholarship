import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:scholarship_application/admin/detailed_graph_page.dart';
import 'package:scholarship_application/admin/verification_page.dart';
import 'package:scholarship_application/components/my_piechart.dart';
import 'package:scholarship_application/components/my_wavepainter.dart';
import 'package:scholarship_application/services/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  String? _currentAdminId;
  Future<List<Map<String, dynamic>>> _unverifiedProviders = Future.value([]);

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void initState() {
    super.initState();
    _loadCurrentAdmin();
  }

  Future<void> _loadCurrentAdmin() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentAdminId = user.uid;
      });
    }
    await _loadPreviousValues();
    await _fetchData();
  }

  Future<void> _loadPreviousValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _prevTotalUsers = prefs.getInt('$_currentAdminId-prevTotalUsers');
      _prevProviders = prefs.getInt('$_currentAdminId-prevProviders');
      _prevStudents = prefs.getInt('$_currentAdminId-prevStudents');
      _prevFeedbacks = prefs.getInt('$_currentAdminId-prevFeedbacks');
      print(
          'Loaded previous values for $_currentAdminId: TotalUsers=$_prevTotalUsers, Providers=$_prevProviders, Students=$_prevStudents, Feedbacks=$_prevFeedbacks');
    });
  }

  Future<void> _saveCurrentValues(
      int totalUsers, int providers, int students, int feedbacks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_currentAdminId-prevTotalUsers', totalUsers);
    await prefs.setInt('$_currentAdminId-prevProviders', providers);
    await prefs.setInt('$_currentAdminId-prevStudents', students);
    await prefs.setInt('$_currentAdminId-prevFeedbacks', feedbacks);
    print(
        'Saved current values for $_currentAdminId: TotalUsers=$totalUsers, Providers=$providers, Students=$students, Feedbacks=$feedbacks');
  }

  Future<void> _fetchData() async {
    int totalUsers = await _firestoreService.getTotalUsers();
    int providers = await _firestoreService.getProviders();
    int students = await _firestoreService.getStudents();
    int feedbacks = await _firestoreService.getFeedbacks();
    List<Map<String, dynamic>> unverifiedProviders =
        await _firestoreService.getUnverifiedProviders(limit: 2);

    setState(() {
      _totalUsers = Future.value(totalUsers);
      _providers = Future.value(providers);
      _students = Future.value(students);
      _feedbacks = Future.value(feedbacks);
      _unverifiedProviders = Future.value(unverifiedProviders);
    });
    await _saveCurrentValues(totalUsers, providers, students, feedbacks);
  }

  Future<Map<String, int>> _fetchUserData() async {
    int adminCount = await _firestoreService.getAdminCount();
    int providerCount = await _firestoreService.getProviderCount();
    int studentCount = await _firestoreService.getStudentCount();

    return {
      'admin': adminCount,
      'provider': providerCount,
      'student': studentCount,
    };
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
                  SizedBox(width: 5),
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

  Icon? _getChangeIcon(int? previousValue, int? currentValue) {
    if (previousValue == null || currentValue == null) return null;
    print(
        'Comparing values: previousValue=$previousValue, currentValue=$currentValue');
    if (currentValue > previousValue) {
      return Icon(Icons.arrow_drop_up_rounded, color: Colors.green);
    } else if (currentValue < previousValue) {
      return Icon(Icons.arrow_drop_down_rounded, color: Colors.red);
    } else {
      return Icon(Icons.remove, color: Colors.grey);
    }
  }

  Widget _buildProvidersBox(List<Map<String, dynamic>> providers) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Unverified Providers",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Column(
            children: providers.map((provider) {
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(provider['email'] ?? 'No Email'),
                  subtitle: Text(provider['role'] ?? 'No Role'),
                ),
              );
            }).toList(),
          ),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProviderVerificationPage(),
                  ),
                );
              },
              child: Text("View More"),
            ),
          ),
        ],
      ),
    );
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
                Positioned.fill(
                  child: CustomPaint(
                    painter: WavePainter(),
                  ),
                ),
                Container(
                  height: 200,
                  width: double.infinity,
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
            Padding(
              padding: EdgeInsets.all(8),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  FutureBuilder<int>(
                    future: _totalUsers,
                    builder: (context, snapshot) {
                      return _buildStatTile(
                        'Total Users',
                        snapshot.data.toString() ?? '0',
                        Icons.person_add,
                        _getChangeIcon(_prevTotalUsers, snapshot.data),
                      );
                    },
                  ),
                  FutureBuilder<int>(
                    future: _providers,
                    builder: (context, snapshot) {
                      return _buildStatTile(
                          'Providers',
                          snapshot.data.toString() ?? '0',
                          Icons.verified_user,
                          _getChangeIcon(_prevProviders, snapshot.data));
                    },
                  ),
                  FutureBuilder<int>(
                    future: _students,
                    builder: (context, snapshot) {
                      return _buildStatTile(
                          'Students',
                          snapshot.data.toString() ?? '0',
                          Icons.school,
                          _getChangeIcon(_prevStudents, snapshot.data));
                    },
                  ),
                  FutureBuilder<int>(
                    future: _feedbacks,
                    builder: (context, snapshot) {
                      return _buildStatTile(
                          'Feedbacks',
                          snapshot.data.toString() ?? '0',
                          Icons.feedback,
                          _getChangeIcon(_prevFeedbacks, snapshot.data));
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _unverifiedProviders,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return _buildProvidersBox(snapshot.data!);
                  } else {
                    return Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No unverified providers at the moment.'),
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: FutureBuilder<Map<String, int>>(
                future: _fetchUserData(), // Fetch user data from Firestore
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, int> userData = snapshot.data!;
                    Map<String, double> dataMap = {
                      'Admin': userData['admin']!.toDouble(),
                      'Provider': userData['provider']!.toDouble(),
                      'Student': userData['student']!.toDouble(),
                    };
                    return Container(
                      height: 250,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Data",
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
                                child: Text("View Detail"),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          PieChartWidget(dataMap),
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('No data available'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
