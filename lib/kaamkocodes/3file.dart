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
import 'package:taskes/kaamkocodes/11inside_bottom_sheet.dart';
import 'package:taskes/kaamkocodes/12taskmanager.dart';
import 'package:taskes/kaamkocodes/19main.dart';
import 'package:taskes/kaamkocodes/3file.dart';
import 'package:taskes/kaamkocodes/resources/app_colors.dart';
import 'package:taskes/kaamkocodes/widgets/legend_widget.dart';

//
class TimingsChart extends StatefulWidget {
  @override
  _TimingsChartState createState() => _TimingsChartState();
}

class _TimingsChartState extends State<TimingsChart> {
  // Variable to control the visibility of BarChartSample6
  bool showChart = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // Toggle visibility of BarChartSample6
            setState(() {
              showChart = !showChart;
            });
          },
          child: Text(
            'other',
            strutStyle: StrutStyle.disabled,
          ),
        ),

        // Conditionally show BarChartSample6 based on showChart value
        if (showChart) BarDetailsScreen(barData: "data"),
      ],
    );
  }
}
