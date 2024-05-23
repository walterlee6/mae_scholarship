// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class DetailedGraphPage extends StatelessWidget {
//   const DetailedGraphPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Detailed Graphs'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Text(
//                 'Detailed Monthly Registrations',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 16),
//               Container(
//                 height: 300, // Explicit height for the chart
//                 child: LineChart(
//                   LineChartData(
//                     lineBarsData: [
//                       LineChartBarData(
//                         spots: [
//                           FlSpot(0, 10),
//                           FlSpot(1, 20),
//                           FlSpot(2, 40),
//                           FlSpot(3, 30),
//                           FlSpot(4, 50),
//                           FlSpot(5, 60),
//                         ],
//                         isCurved: true,
//                         color: Colors.blue,
//                         dotData: FlDotData(show: true),
//                         belowBarData: BarAreaData(
//                             show: true, color: Colors.blue.withOpacity(0.3)),
//                       ),
//                     ],
//                     // titlesData: FlTitlesData(
//                     //   leftTitles: AxisTitles(
//                     //     sideTitles: SideTitles(showTitles: true),
//                     //   ),
//                     //   bottomTitles: AxisTitles(
//                     //     sideTitles: SideTitles(showTitles: true),
//                     //   ),
//                     // ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:scholarship_application/services/firestore_service.dart';

class DetailedGraphPage extends StatefulWidget {
  const DetailedGraphPage({super.key});

  @override
  _DetailedGraphPageState createState() => _DetailedGraphPageState();
}

class _DetailedGraphPageState extends State<DetailedGraphPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<FlSpot> _spots = [];
  final List<String> _daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    Map<String, int> data = await _firestoreService.getUserRegistrationData();
    List<FlSpot> spots = [];

    for (int i = 0; i < _daysOfWeek.length; i++) {
      String day = _daysOfWeek[i];
      spots.add(FlSpot(i.toDouble(), data[day]!.toDouble()));
    }

    setState(() {
      _spots = spots;
    });
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detailed Graphs'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTitle('Detailed Weekly Registrations'),
              SizedBox(height: 300),
              SizedBox(
                height: 300,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: _spots,
                          isCurved: true,
                          color: Colors.blue,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.blue.withOpacity(0.3),
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
                                    color: Colors.black,
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
                            interval: 1,
                          ),
                        ),
                      ),
                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: true),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

