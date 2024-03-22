import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
 
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:getwidget/getwidget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:taskes/kaamkocodes/12taskmanager.dart';
import 'package:taskes/kaamkocodes/19main.dart';
import 'package:taskes/kaamkocodes/3file.dart';
import 'package:taskes/kaamkocodes/resources/app_colors.dart';
import 'package:taskes/kaamkocodes/widgets/legend_widget.dart';


late List<BarChartGroupData> chartData;

bool barchart_stauts_load = bar_Chart_load_status;
bool frommainfile_reload_status = bar_Chart_load_status;

class BarChartSample6Second extends StatelessWidget {
  List<BarChartGroupData> generateChartData(List<List<double>> data) {
    List<BarChartGroupData> chartData = [];
    for (int i = 0; i < data.length; i++) {
      chartData.add(generateGroupData(i, data[i][0], data[i][1], data[i][2]));
    }
    return chartData;
  }

  final List<List<double>> data = distancesForEachDistance[1]; //first ko lagi
  
  BarChartSample6Second({Key? key}) : super(key: key) {
    // Initialize chartData here
    chartData = generateChartData(data);
  }
  final Trafficjamcolor = Color.fromARGB(255, 168, 0, 0);
  final NormalColor = Color.fromARGB(255, 0, 255, 85);
  final SlowColor = Color.fromARGB(255, 238, 255, 0);
  final betweenSpace = 0.2;

  BarChartGroupData generateGroupData(
    int x,
    double pilates,
    double quickWorkout,
    double cycling,
  ) {
    barchart_stauts_load = true;
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barRods: [
        BarChartRodData(
          fromY: 0,
          toY: pilates,
          color: Trafficjamcolor,
          width: 5,
        ),
        BarChartRodData(
          fromY: pilates + betweenSpace,
          toY: pilates + betweenSpace + quickWorkout,
          color: SlowColor,
          width: 5,
        ),
        BarChartRodData(
          fromY: pilates + betweenSpace + quickWorkout + betweenSpace,
          toY: pilates + betweenSpace + quickWorkout + betweenSpace + cycling,
          color: NormalColor,
          width: 5,
        ),
      ],
    );
  }
 Widget leftTitles(double value, TitleMeta meta) {
  List<String> intervalDurations = [];
  List<String> intervals = durationsForEachDistance[0]; 
  
  int maxDuration = 0;
  for (var interval in intervals) {
    int duration = int.parse(interval.replaceAll('sec', ''));
    if (duration < maxDuration) {
      maxDuration = duration;
    }
  }

  // Divide the max duration into 10 intervals
  for (int i = 1; i <= 10; i++) {
    int intervalDuration = (maxDuration * i) ~/ 10;
    intervalDurations.add(intervalDuration.toString());
  }
  
  int intValue = value.toInt();
  if (intValue < intervalDurations.length) {
    return Text(
      intervalDurations[intValue],
      style: TextStyle(fontSize: 10),
    );
  } else {
    return SizedBox();
  }
 
}
  String getFormattedTime(int hour, int minute) {
    String hourStr = hour.toString().padLeft(2, '0');
    String minuteStr = minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }
Widget bottomTitles(double value, TitleMeta meta) {
  if (value.toInt() < segmentedTimeArray.length) {
    return Text(
      segmentedTimeArray[value.toInt()],
      style: TextStyle(fontSize: 10),
    );
  } else {
    return SizedBox();
  }
}
  void handleTouchCallback(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          barchart_stauts_load = true;
          return Container(
            height: 200, // Adjust the height as needed
            child: TimingsChart(), // Replace TimingsChart with your widget
          );
        });
     
  }
  @override
  Widget build(BuildContext context) {
     
    return Padding(
      padding: const EdgeInsets.all(24),
      child: GestureDetector(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'For Route 2',
              style: TextStyle(
                color: AppColors.contentColorBlue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            LegendsListWidget(
              legends: [
                Legend('Traffic_jam', Trafficjamcolor),
                Legend('Slow', SlowColor),
                Legend('Normal', NormalColor),
              ],
            ),
            const SizedBox(height: 14),
            AspectRatio(
              aspectRatio: 2,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceBetween,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                    rightTitles: const AxisTitles(),
                    topTitles: const AxisTitles(),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitles,
                        reservedSize: 20,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  barGroups: chartData,
                  maxY: 11 + (betweenSpace * 3),
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      HorizontalLine(
                        y: 3.3,
                        color: Trafficjamcolor,
                        strokeWidth: 1,
                        dashArray: [20, 4],
                      ),
                      HorizontalLine(
                        y: 8,
                        color: SlowColor,
                        strokeWidth: 1,
                        dashArray: [20, 4],
                      ),
                      HorizontalLine(
                        y: 11,
                        color: NormalColor,
                        strokeWidth: 1,
                        dashArray: [20, 4],
                      ),
                    ],
                  ),

                  barTouchData: BarTouchData(
                    enabled: true,
                    touchCallback: (FlTouchEvent event,
                        BarTouchResponse? barTouchResponse) {
                      // Navigate to BarDetailsScreen with relevant data (error handling included)
                      try {
                        // (group, groupIndex, rod, rodIndex) {
                        // final barData = chartData[group.x.toInt()];
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              
                              TaskManager(),
                          
                        ));
                        // };

                      } catch (error) {
                        print('Error navigating to barLabelScreen: $error');
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
   
    );
  }
}

