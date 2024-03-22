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

// bottom slider end::::::::::::::::::::
class TrafficPoint extends Point {
  String traffic;

  TrafficPoint(double latitude, double longitude, this.traffic)
      : super(latitude, longitude);
}

double degreesToRadians(double degrees) {
  return degrees * pi / 180;
}

class Point {
  double latitude;
  double longitude;

  Point(this.latitude, this.longitude);
}


enum TrafficCondition { SLOW, NORMAL, TRAFFIC_JAM }

class TrafficLatLng {
  final LatLng coordinates;
  final TrafficCondition trafficCondition;

  TrafficLatLng(this.coordinates, this.trafficCondition);
}
