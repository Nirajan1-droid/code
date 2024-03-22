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

Future<List<Map<String, dynamic>>> fetchJsonDataObjects() async {
  late mongo.Db _db;
  String connectionString =
      "mongodb+srv://legolasbhatia123:legolas@cluster0.f1w1qjx.mongodb.net/traffic?retryWrites=true&w=majority";
  _db =  await mongo.Db.create(connectionString);
  await _db.open();
  print("Db connected");

  final collection = _db.collection('json_collection');
  final jsonData = await collection.find(mongo.where.exists('json_object')).toList();
  final List<Map<String, dynamic>> JsonDataObjectkobau =
      jsonData.map((json) => json['json_object'] as Map<String, dynamic>).toList();

  await _db.close();

  return JsonDataObjectkobau;
}

// import 'dart:convert';

List<String> generateTimeSegments(String departureTime) {
  // Parse the departure time
  List<String> parts = departureTime.split(' ');
  int hour = int.parse(parts[0]);
  String period = parts[1];

  // Convert 'PM' to 24-hour format if needed
  if (period.toUpperCase() == 'PM') {
    hour += 12;
  }

  // Adjust hour and minute for 10 minutes before departure
  if (hour == 12) {
    hour = 11;
    period = 'AM';
  } else if (hour == 1) {
    hour = 12;
  } else {
    hour--;
  }

  // Generate time segments
  List<String> segments = [];
  for (int m = 0; m < 60; m += 10) {
    String hourStr = hour.toString().padLeft(2, '0');
    String minuteStr = m.toString().padLeft(2, '0');
    String segment = " '$hourStr:$minuteStr $period'" ;
    segments.add(segment);
  }

  return segments;
}

Future<List<Map<String, dynamic>>> fetchDataFromMongoDB() async {
  late mongo.Db _db;
  String connectionString =
      "mongodb+srv://legolasbhatia123:legolas@cluster0.f1w1qjx.mongodb.net/traffic?retryWrites=true&w=majority";
  _db = await mongo.Db.create(connectionString);
  await _db.open();
  print("Db connected");

  final collection = _db.collection('represent_data');
 
  // Find all documents in the collection
  final documents = await collection.find().toList();
  print("documents to inspect for chardata: $documents");

  List<Map<String, dynamic>> chartData = [];

  for (var document in documents) {
    final targetDistance = document['distance'] as double;
    final durationList = document['duration'] as List<dynamic>;
    final distancesList = jsonDecode(document['distances'] as String) as List<dynamic>;

    int closestDuration = 0;
    double minDifference = double.infinity;

    for (var item in durationList) {
      final durationValueStr = (item[0] as String).replaceAll('s', ''); // Remove 's' from the string
      final durationValue = int.parse(durationValueStr); // Parse the string to an integer
      final difference = (targetDistance - durationValue).abs();
      if (difference < minDifference) {
        minDifference = difference;
        closestDuration = durationValue;
      }
    }
    print("Inspected closest duration for distance $targetDistance: $closestDuration seconds");

    // Convert distance from meters to kilometers and format to have only one decimal place
    final distanceKm = (targetDistance / 1000).toStringAsFixed(1);

    final distances = distancesList.map((e) => e as double).toList();

    chartData.add({
      'distance': '$distanceKm km',
      'duration': '$closestDuration sec',
      'distances': distances,
    });
  }

  await _db.close();
  print("CHARTDATAS HARU: $chartData");
  return chartData;
}


// Future<List<Map<String, dynamic>>> fetchDataFromMongoDB() async {
//   late mongo.Db _db;
//   String connectionString =
//       "mongodb+srv://legolasbhatia123:legolas@cluster0.f1w1qjx.mongodb.net/traffic?retryWrites=true&w=majority";
//   _db = await mongo.Db.create(connectionString);
//   await _db.open();
//   print("Db connected");

//   final collection = _db.collection('represent_data');
 
//   // Find all documents in the collection
//   final documents = await collection.find().toList();
//   print("documents to inspect for chardata: $documents");

//   for (var document in documents) {
//     final targetDistance = document['distance'] as double;
//     final durationList = document['duration'] as List<dynamic>;
//     final distancesList = jsonDecode(document['distances'] as String) as List<dynamic>;

//     int closestDuration = 0;
//     double minDifference = double.infinity;

//     for (var item in durationList) {
//       final durationValueStr = (item[0] as String).replaceAll('s', ''); // Remove 's' from the string
//       final durationValue = int.parse(durationValueStr); // Parse the string to an integer
//       final difference = (targetDistance - durationValue).abs();
//       if (difference < minDifference) {
//         minDifference = difference;
//         closestDuration = durationValue;
//       }
//     }

//     final distances = distancesList.map((e) => e as double).toList();
// Map<String,dynamic> array = {};
// List<Map<String,dynamic>> chartData = [];
//     // Convert distance from meters to kilometers
//     final distanceKm = targetDistance / 1000;

//     chartData.add({
//       'distance': '$distanceKm km',
//       'duration': '$closestDuration sec',
//       'distances': distances,
//     });
//   }

//   await _db.close();
//   print("CHARTDATAS HARU: $chartData");
//   return chartData;
// }


// Future<List<Map<String, dynamic>>> fetchDataFromMongoDB() async {
//   late mongo.Db _db;
//   String connectionString =
//       "mongodb+srv://legolasbhatia123:legolas@cluster0.f1w1qjx.mongodb.net/traffic?retryWrites=true&w=majority";
//   _db = await mongo.Db.create(connectionString);
//   await _db.open();
//   print("Db connected");

//   final collection = _db.collection('represent_data');
   

//   await _db.close();

//   return chartData;
// }


// final List<Map<String, dynamic>> chartData = [
//   {
//     'distance': '9.9 km',
//     'duration': '500 sec',
//     'distances': [1.0534898309257859, 2.129312103845465, 1.7387169093773742]
//   },
//   {
//     'distance': '8.0 km',
//     'duration': '1500 sec',
//     'distances': [4.0534898309257859, 3.129312103845465, 1.7387169093773742]
//   },
//   {
//     'distance': '9.9 km',
//     'duration': '2000 sec',
//     'distances': [1.0534898309257859, 5.129312103845465, 6.7387169093773742]
//   },
//   {
//     'distance': '8.0 km',
//     'duration': '3000 sec',
//     'distances': [2.0534898309257859, 7.129312103845465, 3.7387169093773742]
//   }
// ];






// Future<List<List<double>>> fetchDataFromMongoDB() async {
//   late mongo.Db _db;
//   String connectionString =
//       "mongodb+srv://legolasbhatia123:legolas@cluster0.f1w1qjx.mongodb.net/traffic?retryWrites=true&w=majority";
//   _db = await mongo.Db.create(connectionString);
//   await _db.open();
//   print("Db connected");

//   // var collection = _db.collection('represent_data');
//   final collection = _db.collection('represent_data');

//   final data = await collection.find().toList();

//   final List<List<double>> chartData = [];

//   for (var item in data) {
//     double normalDistance = item['normalDistance'];
//     double slowDistance = item['slowDistance'];
//     double jamDistance = item['jamDistance'];

//     // Check if distanceMeters matches any duration element
//     String distanceMeters =
//         (item['distanceMeters'] as double).toStringAsFixed(1);
//     print("distance meters i :$distanceMeters");
//     List<dynamic> durations = item['duration'];
//     List<double> array = [];
//     // for(int i = 0; i< durations.length;i++){

//     for (var duration in durations) {
//       var duration_in_km = (duration[1] / 1000 as double).toStringAsFixed(1);
//       print("Duration in ktm haru : $duration_in_km");
//       if (duration_in_km == distanceMeters) {
//         array = [jamDistance, slowDistance, normalDistance];
//         break;
//       }
//     }

//     if (array.isNotEmpty) {
//       chartData.add(array);
//     }
//   }

//   await _db.close();

//   return chartData;
// }

Future<void> deleteAllDocuments() async {
  // MongoDB connection string
  String connectionString =
      "mongodb+srv://legolasbhatia123:legolas@cluster0.f1w1qjx.mongodb.net/traffic?retryWrites=true&w=majority";
  
  // Create MongoDB client
  final dbClient = await mongo.Db.create(connectionString);
  await dbClient.open();

  try {
    // Replace 'json_collection' with your actual collection name
    const collectionName = 'json_collection';
    const collectionName_polyline = 'polyline_segments';
    const collectionName_represent_data =  'represent_data';

    // Get the MongoDB collection
    final collection = dbClient.collection(collectionName);
    final collection1 = dbClient.collection(collectionName_polyline);
    final collection2 = dbClient.collection(collectionName_represent_data);
    // Delete all documents in the collection
    final result = await collection.deleteMany({});
  final result1 = await collection1.deleteMany({});
  final result2 = await collection2.deleteMany({});
    print('Deleted ${result.document} documents from $collectionName');
    print('Deleted ${result1.document} documents from $collectionName_polyline');
    print('Deleted ${result2.document} documents from $collectionName_represent_data');
  } catch (error) {
    print('Error deleting documents: $error');
    // Handle error
  } finally {
    // Close the MongoDB connection
    await dbClient.close();
  }
}



Future<void> checkAndRemoveDuplicate() async {
  late mongo.Db _db;
  String connectionString =
      "mongodb+srv://legolasbhatia123:legolas@cluster0.f1w1qjx.mongodb.net/traffic?retryWrites=true&w=majority";
  _db = await mongo.Db.create(connectionString);
  await _db.open();
  print("Db connected");
  final datasforgraph = _db.collection('represent_data');
  // Fetch all documents from the collection
  var allDocs = await datasforgraph.find({}).toList();
  print("6utlis bata represent_data collection ko data haru");
  // Keep track of encountered documents to ensure only one copy of each unique document
  var uniqueDocIds = <String>{};

  // Remove redundant data while keeping one copy of each unique document
  for (var doc in allDocs) {
    var docId = doc['_id'].toString();
    if (uniqueDocIds.contains(docId)) {
      // Remove redundant document
      await datasforgraph.remove({'_id': doc['_id']});
    } else {
      // Add this document's ID to the set of encountered IDs
      uniqueDocIds.add(docId);
    }
  }
}


  
  bool _containsPoint(List<LatLng> polygonPoints, LatLng tapPosition) {
    int crossings = 0;

    for (int i = 0; i < polygonPoints.length; i++) {
      final vertex1 = polygonPoints[i];
      final vertex2 = polygonPoints[(i + 1) % polygonPoints.length];

      if (vertex1.longitude == vertex2.longitude &&
          vertex1.longitude == tapPosition.longitude) {
        // Point is on the same longitude as a vertex; it's either on a vertex or on an edge.
        if (tapPosition.latitude >= vertex1.latitude &&
                tapPosition.latitude <= vertex2.latitude ||
            tapPosition.latitude >= vertex2.latitude &&
                tapPosition.latitude <= vertex1.latitude) {
          return true; // Point is on the edge
        }
      }

      if (tapPosition.longitude > vertex1.longitude &&
              tapPosition.longitude <= vertex2.longitude ||
          tapPosition.longitude > vertex2.longitude &&
              tapPosition.longitude <= vertex1.longitude) {
        final double edgeSlope = (vertex2.latitude - vertex1.latitude) /
            (vertex2.longitude - vertex1.longitude);
        final double pointSlope = (tapPosition.latitude - vertex1.latitude) /
            (tapPosition.longitude - vertex1.longitude);

        if (pointSlope <= edgeSlope) {
          crossings++;
        }
      }
    }

    return crossings % 2 == 1;
  }

  