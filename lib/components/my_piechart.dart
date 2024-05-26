import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, double> dataMap;

  PieChartWidget(this.dataMap);

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: dataMap,
      chartType: ChartType.ring,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      colorList: [
        Colors.blue,
        Colors.green,
        Colors.orange,
      ],
      chartLegendSpacing: 32,
      chartValuesOptions: ChartValuesOptions(
        showChartValuesInPercentage: true,
      ),
    );
  }
}
