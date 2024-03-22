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
import 'package:taskes/kaamkocodes/barchartkocode2.dart';
import 'package:taskes/kaamkocodes/resources/app_colors.dart';
import 'package:taskes/kaamkocodes/widgets/legend_widget.dart';
//for graph representation widget
class ChartToggleWidget_second extends StatefulWidget {
  @override
  _ChartToggleWidget_secondState createState() => _ChartToggleWidget_secondState();
}
class _ChartToggleWidget_secondState extends State<ChartToggleWidget_second> {
  // Variable to control the visibility of BarChartSample6
  bool showChart1 = false;
   
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    // Set a timer to stop showing the loading indicator after 5 seconds
    Timer(Duration(seconds: 5), () {
      setState(() {
        isLoading = false;
      });
    });
  } 
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Bar chart or loading indicator based on isLoading flag
            if (isLoading)
              BarChartSample6Second(), // Show the chart
             
              // Container(), // Placeholder container
            // if (!isLoading)
            //   const CircularProgressIndicator(), // Show the loading indicator
           // Placeholder container
          ],
        ),
      ],
    );
  }
}