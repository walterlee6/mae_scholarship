import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scholarship_application/admins/navigation_bar.dart';
import 'package:scholarship_application/services/data_services.dart';

class DetailedGraphPage extends ConsumerStatefulWidget {
  const DetailedGraphPage({super.key});

  @override
  _DetailedGraphPageState createState() => _DetailedGraphPageState();
}

class _DetailedGraphPageState extends ConsumerState<DetailedGraphPage>
    with SingleTickerProviderStateMixin {
  final FirestoreService _firestoreService = FirestoreService();
  List<FlSpot> _spots = [];
  List<BarChartGroupData> _barChartData = [];
  final List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _fetchData() async {
    Map<String, int> registrationData =
        await _firestoreService.getUserRegistrationData();
    List<FlSpot> spots = [];

    for (int i = 0; i < _daysOfWeek.length; i++) {
      String day = _daysOfWeek[i];
      double value = registrationData[day]?.toDouble() ?? 0;
      spots.add(FlSpot(i.toDouble(), value));
    }

    setState(() {
      _spots = spots;
    });
  }

  // Widget _buildTitle(String title) {
  //   return Text(
  //     title,
  //     style: TextStyle(
  //       fontSize: 18,
  //       fontWeight: FontWeight.bold,
  //       color: Colors.white,
  //     ),
  //   );
  // }

  Widget _buildLineChart() {
    return Container(
      color: Colors.blueGrey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // _buildTitle('Detailed Weekly Registrations'),
            SizedBox(height: 16),
            Expanded(
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: _spots,
                      // isCurved: true,
                      color: Colors.cyanAccent,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.cyanAccent.withOpacity(0.3),
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < _daysOfWeek.length) {
                            return Text(
                              _daysOfWeek[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            );
                          }),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.white.withOpacity(0.1),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.white.withOpacity(0.1),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  minY: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return Container(
      color: Colors.blueGrey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // _buildTitle('Number of Users'),
            SizedBox(height: 16),
            Expanded(
              child: BarChart(
                BarChartData(
                  barGroups: _barChartData,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < _barChartData.length) {
                            return Text(
                              _barChartData[index].barRods[0].toY.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.white.withOpacity(0.1),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.white.withOpacity(0.1),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  minY: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white38,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    text: 'Weekly Registrations',
                    icon: Icon(Icons.app_registration),
                  ),
                  Tab(
                    text: 'Number of Users',
                    icon: Icon(Icons.people),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLineChart(),
                  _buildBarChart(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NaviBar(),
    );
  }
}
