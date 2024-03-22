

 
import 'dart:math';
 
import 'package:google_maps_flutter/google_maps_flutter.dart';
 
 
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:taskes/kaamkocodes/4file.dart';
 






  List<List<dynamic>> unique_duration = [];


void storejson_multiple(String segment,  Map<String,dynamic> eachjson)async{
late mongo.Db _db;
      String connectionString =
          "mongodb+srv://legolasbhatia123:legolas@cluster0.f1w1qjx.mongodb.net/traffic?retryWrites=true&w=majority";
      _db = await mongo.Db.create(connectionString);
      await _db.open();

            await _db.open();
 final datasforgraph = _db.collection('json_collection');
 

  await datasforgraph.insert({
      'segment_time': segment,
      'json_object': eachjson, 
    });
    
 
  
      print("Db closed json haliyo hai");
            await _db.close();


}


void storePolylineSegments(List<List<LatLng>> datastomongo, List<List<String>> condition) async {
      int count = 0;
      // i++;
      int ct = 0;
      late mongo.Db _db;
      String connectionString =
          "mongodb+srv://legolasbhatia123:legolas@cluster0.f1w1qjx.mongodb.net/traffic?retryWrites=true&w=majority";
      _db = await mongo.Db.create(connectionString);
      await _db.open();
      print("Db connected");

      var collection = _db.collection('polyline_segments');

      List<Map<String, dynamic>> trafficAndPointsData = [];
      List<Map<String, dynamic>> points = [];
      List<String> traffic = [];
      List<Map<String, dynamic>> result = [];
      print("datastomongo ko length ${datastomongo.length}");
      for (int i = 0; i < datastomongo.length; i++) {
        List<TrafficPoint> points_param = [];

        for (int j = 0; j < datastomongo[i].length; j++) {
          print("inner loop ko length ${datastomongo[i].length}");

          try {
            Map<String, dynamic> point = {
              'latitude': datastomongo[i][j].latitude,
              'longitude': datastomongo[i][j].longitude,
              'traffic': condition[i][j]
            };
            points.add(point);
            traffic.add(condition[i][j]);
          } catch (e) {
            print('Error: $e, writing "traffic_jam"');
            Map<String, dynamic> point = {
              'latitude': 'traffic_jam',
              'longitude': 'traffic_jam',
              'traffic': 'traffic_jam'
            };
            points.add(point);
            traffic.add('traffic_jam');
          }
        }

        print("running $ct");
        ct++;

        // points_param.add(points);
        result = computeDistanceAndTraffic(points);

        print("resiults ahri:$result");
        // Compute total distance for each traffic type
      }

      double normalDistance = 0;
      double slowDistance = 0;
      double jamDistance = 0;

      for (var data in result) {
        double distance = data['distance'];
        String traffic = data['traffic'];

        if (traffic == 'NORMAL') {
          normalDistance += distance;
        } else if (traffic == 'SLOW') {
          slowDistance += distance;
        } else if (traffic == 'TRAFFIC_JAM') {
          jamDistance += distance;
        }
      }
      final datasforgraph = _db.collection('represent_data');
      // Multiply each distance by 1000 and add them together
double totalDistanced = (slowDistance * 1000) + (jamDistance * 1000) + (normalDistance * 1000);

// Ensure totalDistance contains only four digits
double totalDistance = double.parse(totalDistanced.toStringAsFixed(4));;
       bool shouldInsert = true;

Future<void> checkAndRemoveDuplicate(normalDistance, slowDistance, jamDistance) async {
  // Find documents where all three distances match
  var duplicateDocs = await datasforgraph.find({
    'normalDistance': normalDistance,
    'slowDistance': slowDistance,
    'jamDistance': jamDistance
  }).toList();
  
  // Keep track of encountered documents to ensure only one copy of each unique document
  var uniqueDocIds = <String>{};

  // Remove redundant data while keeping one copy of each unique document
  for (var doc in duplicateDocs) {
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


  // Assuming necessary initialization steps before this

  await checkAndRemoveDuplicate(normalDistance, slowDistance, jamDistance);

  if (shouldInsert) {
    await datasforgraph.insertOne({
      'distance': totalDistance,
      'duration': unique_duration,
      'distances': '[ $jamDistance , $slowDistance , $normalDistance ]',
    });
    
  
    
  } else {
    print("Warning: Skipping insertion of represent_data with existing normalDistance.");
  }


      
      


      await collection.insertOne(
          {'_id': mongo.ObjectId(), 'points': points, 'trafficarr': traffic, 'uniqueval':Random().nextInt(1000000)});
      await _db.close();
      print("Db closed");
    }

    
    List<Map<String, dynamic>> computeDistanceAndTraffic(
        List<Map<String, dynamic>> points) {
      List<Map<String, dynamic>> result = [];

      for (int i = 0; i < points.length - 1; i++) {
        double lat1 = points[i]["latitude"];
        double lon1 = points[i]["longitude"];
        String traffic = points[i]["traffic"];

        double lat2 = points[i + 1]["latitude"];
        double lon2 = points[i + 1]["longitude"];

        TrafficPoint point1 = TrafficPoint(lat1, lon1, traffic);
        TrafficPoint point2 =
            TrafficPoint(lat2, lon2, points[i + 1]["traffic"]);

        double distance = calculateDistance(point1, point2);

        Map<String, dynamic> pointData = {
          'distance': distance,
          'traffic': traffic,
        };

        result.add(pointData);
      }

      return result;
    }

    
    double calculateDistance(TrafficPoint point1, TrafficPoint point2) {
      const double earthRadius = 6371; // in kilometers

      double lat1Rad = degreesToRadians(point1.latitude);
      double lat2Rad = degreesToRadians(point2.latitude);
      double lon1Rad = degreesToRadians(point1.longitude);
      double lon2Rad = degreesToRadians(point2.longitude);

      double deltaLat = lat2Rad - lat1Rad;
      double deltaLon = lon2Rad - lon1Rad;

      double a = pow(sin(deltaLat / 2), 2) +
          cos(lat1Rad) * cos(lat2Rad) * pow(sin(deltaLon / 2), 2);
      double c = 2 * atan2(sqrt(a), sqrt(1 - a));

      return earthRadius * c; // in kilometers
    }  