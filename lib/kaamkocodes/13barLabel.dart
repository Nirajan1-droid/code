import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarLabelScreen extends StatelessWidget {
  final List<BarChartGroupData> chartData;
  // final int barIndex;

  const BarLabelScreen({Key? key, required this.chartData, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final String barLabel = 'Bar ${chartData[barIndex].x}';
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Bar Details'),
      ),
      body: Center(
        child: Text('You clicked on bar: $chartData'),
      ),
    );
  }
}
