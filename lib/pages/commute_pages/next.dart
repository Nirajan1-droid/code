import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/kaamkocodes/barLabel.dart';
import 'package:map/kaamkocodes/inside_bottom_sheet.dart';
import 'package:map/kaamkocodes/main.dart';
import 'package:map/kaamkocodes/resources/app_colors.dart';
import 'package:map/kaamkocodes/widgets/legend_widget.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:getwidget/getwidget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

 
Future<void> checkAndRemoveDuplicate() async {
 late mongo.Db _db;
  String connectionString =
      "mongodb+srv://legolasbhatia123:legolas@cluster0.f1w1qjx.mongodb.net/traffic?retryWrites=true&w=majority";
  _db = await mongo.Db.create(connectionString);
  await _db.open();
  print("Db connected");

    final datasforgraph = _db.collection('represent_data');

  // Fetch all documents from the collection
 var allDocs = await datasforgraph.find(<String, dynamic>{}).toList();

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

Future<List<List<double>>> fetchDataFromMongoDB() async {
  late mongo.Db _db;
  String connectionString =
      "mongodb+srv://legolasbhatia123:legolas@cluster0.f1w1qjx.mongodb.net/traffic?retryWrites=true&w=majority";
  _db = await mongo.Db.create(connectionString);
  await _db.open();
  print("Db connected");

  // var collection = _db.collection('represent_data');
  final collection = _db.collection('represent_data');

  final data = await collection.find().toList();

  final List<List<double>> chartData = [];

  for (var item in data) {
    double normalDistance = item['normalDistance'];
    double slowDistance = item['slowDistance'];
    double jamDistance = item['jamDistance'];

    // Check if distanceMeters matches any duration element
    String distanceMeters =
        (item['distanceMeters'] as double).toStringAsFixed(1);
    print("distance meters i :$distanceMeters");
    List<dynamic> durations = item['duration'];
    List<double> array = [];
    // for(int i = 0; i< durations.length;i++){

    for (var duration in durations) {
      var duration_in_km = (duration[1] / 1000 as double).toStringAsFixed(1);
      print("Duration in ktm haru : $duration_in_km");
      if (duration_in_km == distanceMeters) {
        array = [jamDistance, slowDistance, normalDistance];
        break;
      }
    }

    if (array.isNotEmpty) {
      chartData.add(array);
    }
  }

  await _db.close();

  return chartData;
}

List<List<double>> data_for_graph = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    home: PolylineMap(),
  ));
  // Delay execution of fetchDataFromMongoDB to ensure the app is built
  Future.delayed(Duration.zero, () async {
    data_for_graph = await fetchDataFromMongoDB();
    print("to show in the graph : $data_for_graph");
  });
  // Delay for 5 seconds before running the aggregate function
  Future.delayed(const Duration(seconds: 10), () async {
    // Run the aggregate function to remove redundant data
    await checkAndRemoveDuplicate();
    print("executed aggregation#############");
  });
}

class PolylineMap extends StatefulWidget {
  @override
  _PolylineMapState createState() => _PolylineMapState();
}

class _PolylineMapState extends State<PolylineMap> {
  late mongo.Db _db;
  GoogleMapController? _controller;
  List<LatLng> _polylineCoordinates = [];
  Map<TrafficCondition, Color> _colorMap = {
    TrafficCondition.NORMAL: Colors.green,
    TrafficCondition.SLOW: Colors.yellow,
    TrafficCondition.TRAFFIC_JAM: Colors.red,
  };
  Set<Polyline> _polylines = {};
  void _handleMapTap(LatLng tapPosition) {
    // Check if any polyline contains the tapped position
    for (final polyline in _polylines) {
      final containsPoint = _containsPoint(polyline.points, tapPosition);
      if (containsPoint) {
        // Polyline tapped! Handle the event here
        print("Polyline with ID '${polyline.onTap}' was tapped!");
        _showBottomSheet(polyline);

        // You can show a dialog, navigate to a new screen, etc.
        break; // Exit the loop after finding the first matching polyline
      }
    }
  }

  void _showBottomSheet(Polyline polyline) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Text(
              //   'Polyline Details',
              //   style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              // ),
              // SizedBox(height: 10.0),
              // Text('Distance: ${polyline.points}'),
              // SizedBox(height: 5.0),
              // Text('Duration: ${polyline.color}'),
              ChartToggleWidget(),
            ],
          ),
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    _polylines = Set<Polyline>.of(_createPolylines());
    return Scaffold(
      appBar: AppBar(
        title: Text('Polyline Map'),
      ),
      body: GoogleMap(
        mapType: MapType.terrain,
        onTap: _handleMapTap,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target:
              LatLng(27.679807526706504, 85.32730017497411), // Initial position
          zoom: 12,
        ),
        polylines: Set<Polyline>.of(_createPolylines()),
      ),
      bottomSheet: GFBottomSheet(
        controller: GFBottomSheetController(),
        maxContentHeight: 500,
        enableExpandableContent: true,
        stickyHeaderHeight: 100,
        stickyHeader: Container(
          // color: Color.fromARGB(177, 126, 193, 255),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 75, 156, 199),
            boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 0)],
          ),
          child: const GFListTile(
            avatar: GFAvatar(
              backgroundImage: AssetImage('asset image here'),
            ),
            titleText: 'Charles Aly',
          ),
        ),
        contentBody: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Button 1 functionality
                      // setState(() {
                      //   showChart1 =  true;
                      // });
                    },
                    child: Text('Button 1'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Button 2 functionality
                    },
                    child: Text('Button 2'),
                  ),
                ],
              ),
              // Bar chart
              ChartToggleWidget(),
              TimingsChart(),
            ],
          ),
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  List<Polyline> polylines = [];
  var inspectData;
  List<Polyline> _createPolylines() {
    // Parse the JSON data and create polylines
    //run 1 choti -> 10 choti -> 10 ota object euta collection. {expected departure_time : 11:00AM, user before 1 hourn notification chahiyo,
    //api:  departure_time = 10:05AM
    // 1 choti 10:00: [1,4,4.9] for 9.9km its duraiton is 50min., [1,4,3.5] for 8.5km it duration 45min,
    //2nd time : 10:10: [2,3,4.9] for 9.9km its duraiton is 65min., [1,4,3.5] for 8.5km it duration 45min,
    //3rd time : 10:20: [3,3,3.9] for 9.9km its duraiton is 75min., [1,4,3.5] for 8.5km it duration 45min,  }
    Map<String, dynamic> jsonDataobj = {
      "routes": [
        {
          "legs": [
            {
              "travelAdvisory": {
                "speedReadingIntervals": [
                  {
                    "startPolylinePointIndex": 0,
                    "endPolylinePointIndex": 1,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 1,
                    "endPolylinePointIndex": 9,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 9,
                    "endPolylinePointIndex": 10,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 10,
                    "endPolylinePointIndex": 11,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 11,
                    "endPolylinePointIndex": 17,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 17,
                    "endPolylinePointIndex": 19,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 19,
                    "endPolylinePointIndex": 21,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 21,
                    "endPolylinePointIndex": 24,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 24,
                    "endPolylinePointIndex": 30,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 30,
                    "endPolylinePointIndex": 31,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 31,
                    "endPolylinePointIndex": 32,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 32,
                    "endPolylinePointIndex": 34,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 34,
                    "endPolylinePointIndex": 37,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 37,
                    "endPolylinePointIndex": 38,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 38,
                    "endPolylinePointIndex": 46,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 46,
                    "endPolylinePointIndex": 47,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 47,
                    "endPolylinePointIndex": 62,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 62,
                    "endPolylinePointIndex": 64,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 64,
                    "endPolylinePointIndex": 65,
                    "speed": "TRAFFIC_JAM"
                  },
                  {
                    "startPolylinePointIndex": 65,
                    "endPolylinePointIndex": 66,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 66,
                    "endPolylinePointIndex": 68,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 68,
                    "endPolylinePointIndex": 71,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 71,
                    "endPolylinePointIndex": 74,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 74,
                    "endPolylinePointIndex": 111,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 111,
                    "endPolylinePointIndex": 113,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 113,
                    "endPolylinePointIndex": 119,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 119,
                    "endPolylinePointIndex": 125,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 125,
                    "endPolylinePointIndex": 133,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 133,
                    "endPolylinePointIndex": 136,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 136,
                    "endPolylinePointIndex": 142,
                    "speed": "NORMAL"
                  }
                ]
              }
            }
          ],
          "distanceMeters": 9545,
          "duration": "1462s",
          "polyline": {
            "encodedPolyline":
                "ifehDoopgOAb@b@U`@KpAINEHG`@e@d@]h@vAlA~CPf@nAdDVj@p@jALNj@Z\\HdIj@rG^bJf@~PdAv@DdLr@nCPjAJfLl@vCTlHb@rBHjF^TBxBNxCRt@@LGnGEbCEdBEr@AdHCzBGlBQjASp@W~@e@fOiJb@W\\U~@eAT_@Zu@VkAtByWRyAXkAp@iBP[|H_LdAmCRu@NmABi@bAkO@[SCV{DBo@L{AB_@XeFUBO@M?[E{BiAcC_AeFwAm@MyAKeBGqB_@_A[yCo@i@KqBcAaA_AYg@W_As@_B]w@_@yCDmAf@iCFwC\\}FDqAZaCjAiGXcBt@mD`AcGf@qBbAoCx@gBfAqCbAeB`BuDdBeDhAiBVi@n@yBXcA`@kB^iBh@eBd@eCXcCf@oBrB}GtAqEHc@Be@L]jC_G`@i@RWpA}@nEoC|@UNBv@VFBxDbBPH~@`@F@DBx@j@BNVd@HNFU"
          },
          "travelAdvisory": {
            "speedReadingIntervals": [
              {
                "startPolylinePointIndex": 0,
                "endPolylinePointIndex": 1,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 1,
                "endPolylinePointIndex": 9,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 9,
                "endPolylinePointIndex": 10,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 10,
                "endPolylinePointIndex": 11,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 11,
                "endPolylinePointIndex": 17,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 17,
                "endPolylinePointIndex": 19,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 19,
                "endPolylinePointIndex": 21,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 21,
                "endPolylinePointIndex": 24,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 24,
                "endPolylinePointIndex": 30,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 30,
                "endPolylinePointIndex": 31,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 31,
                "endPolylinePointIndex": 32,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 32,
                "endPolylinePointIndex": 34,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 34,
                "endPolylinePointIndex": 37,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 37,
                "endPolylinePointIndex": 38,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 38,
                "endPolylinePointIndex": 46,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 46,
                "endPolylinePointIndex": 47,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 47,
                "endPolylinePointIndex": 62,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 62,
                "endPolylinePointIndex": 64,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 64,
                "endPolylinePointIndex": 65,
                "speed": "TRAFFIC_JAM"
              },
              {
                "startPolylinePointIndex": 65,
                "endPolylinePointIndex": 66,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 66,
                "endPolylinePointIndex": 68,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 68,
                "endPolylinePointIndex": 71,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 71,
                "endPolylinePointIndex": 74,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 74,
                "endPolylinePointIndex": 111,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 111,
                "endPolylinePointIndex": 113,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 113,
                "endPolylinePointIndex": 119,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 119,
                "endPolylinePointIndex": 125,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 125,
                "endPolylinePointIndex": 133,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 133,
                "endPolylinePointIndex": 136,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 136,
                "endPolylinePointIndex": 142,
                "speed": "NORMAL"
              }
            ]
          },
          "routeToken":
              "CtkCCt4BCggvBHxDr1Z7DhI8vd2FEEmv1TKC8NbDfehFtRbvw7r8rEY-BoDSdLJIEJ-fk1JqYI08IOjnSDNpTBZ1ixhccp1qv99dk3itGk-Wgq_fDAWZFOIk6QGcA8EJK9AD5w3GAcmvDe6XFZMBqLsKtpUTuQGSCrkHDY3qAqi0AgiGCPkK2wH5uiv4iC2hAj5ZIPgO-wpCnAXeG-kBIgKlCkISIYABE7sTuxM66gFHoR0P5QEfSgxcLQ0_tsauPkSO7j1SAQR4AaoBF2ktRDFaZDY4SnFHcWpNd1A5c0dCOEFVEAQaXQpbChgKDQoCCAERAAAAAACAZkARJQaBlUMyqkASIAgAEAMQBhATEBIYAkIOCgYQg5vbrwYaAggFKgBKAggBIhsKF2ktRDFaZmloSktHcWpNd1A5c0dCOEFVcAEoASIVACIFWaHKicOpB-d49eVFau9HxkaD"
        },
        {
          "legs": [
            {
              "travelAdvisory": {
                "speedReadingIntervals": [
                  {
                    "startPolylinePointIndex": 0,
                    "endPolylinePointIndex": 1,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 1,
                    "endPolylinePointIndex": 9,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 9,
                    "endPolylinePointIndex": 10,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 10,
                    "endPolylinePointIndex": 11,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 11,
                    "endPolylinePointIndex": 17,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 17,
                    "endPolylinePointIndex": 19,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 19,
                    "endPolylinePointIndex": 21,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 21,
                    "endPolylinePointIndex": 31,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 31,
                    "endPolylinePointIndex": 45,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 45,
                    "endPolylinePointIndex": 46,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 46,
                    "endPolylinePointIndex": 62,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 62,
                    "endPolylinePointIndex": 76,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 76,
                    "endPolylinePointIndex": 85,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 85,
                    "endPolylinePointIndex": 100,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 100,
                    "endPolylinePointIndex": 102,
                    "speed": "TRAFFIC_JAM"
                  },
                  {
                    "startPolylinePointIndex": 102,
                    "endPolylinePointIndex": 107,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 107,
                    "endPolylinePointIndex": 110,
                    "speed": "TRAFFIC_JAM"
                  },
                  {
                    "startPolylinePointIndex": 110,
                    "endPolylinePointIndex": 116,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 116,
                    "endPolylinePointIndex": 120,
                    "speed": "TRAFFIC_JAM"
                  },
                  {
                    "startPolylinePointIndex": 120,
                    "endPolylinePointIndex": 122,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 122,
                    "endPolylinePointIndex": 124,
                    "speed": "TRAFFIC_JAM"
                  },
                  {
                    "startPolylinePointIndex": 124,
                    "endPolylinePointIndex": 131,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 131,
                    "endPolylinePointIndex": 135,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 135,
                    "endPolylinePointIndex": 137,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 137,
                    "endPolylinePointIndex": 142,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 142,
                    "endPolylinePointIndex": 144,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 144,
                    "endPolylinePointIndex": 145,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 145,
                    "endPolylinePointIndex": 151,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 151,
                    "endPolylinePointIndex": 159,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 159,
                    "endPolylinePointIndex": 163,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 163,
                    "endPolylinePointIndex": 168,
                    "speed": "NORMAL"
                  }
                ]
              }
            }
          ],
          "distanceMeters": 8256,
          "duration": "1597s",
          "polyline": {
            "encodedPolyline":
                "ifehDoopgOAb@b@U`@KpAINEHG`@e@d@]h@vAlA~CPf@nAdDVj@p@jALNj@Z\\HdIj@rG^bJf@hPbAlAFdLr@Ls@@gAGaBSoBAw@Be@Jo@DIFYV]n@]^Ed@S\\_@Ta@Py@Fo@?iAIwBFmAT}ANi@V}@nBsHz@sEPu@~@wEXkBxAaGX{ANuAdA_GXoBbAsFr@mCVuACcAEw@@g@RKx@?`CNz@@CmC@q@A{@DUBExB}@\\CT?\\_@BATMPGTET?zE\\j@LZPXZPXR^JFPDFcAd@oDX}AXcAxAeD^_AnA{CzAmH^qB`CeIzA{En@uBb@yAx@eD^yAx@eEOw@IO?E@OFIBADCL?h@S`EyD|A}Ad@c@tCiC`AaAPa@@KDg@@k@?GJ@bAD\\NdHbGb@Ph@wAaAo@DIvAqC~AmCVi@t@gCRu@d@yBZ{Ah@eBd@eCXcCFS^{A`@uAvAsEnAeEHc@Be@L]jC_Gj@u@HKpA}@nEoC|@UNBv@VFBdEhBDB~@`@LDB@t@h@BNVd@HNFU"
          },
          "travelAdvisory": {
            "speedReadingIntervals": [
              {
                "startPolylinePointIndex": 0,
                "endPolylinePointIndex": 1,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 1,
                "endPolylinePointIndex": 9,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 9,
                "endPolylinePointIndex": 10,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 10,
                "endPolylinePointIndex": 11,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 11,
                "endPolylinePointIndex": 17,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 17,
                "endPolylinePointIndex": 19,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 19,
                "endPolylinePointIndex": 21,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 21,
                "endPolylinePointIndex": 31,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 31,
                "endPolylinePointIndex": 45,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 45,
                "endPolylinePointIndex": 46,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 46,
                "endPolylinePointIndex": 62,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 62,
                "endPolylinePointIndex": 76,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 76,
                "endPolylinePointIndex": 85,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 85,
                "endPolylinePointIndex": 100,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 100,
                "endPolylinePointIndex": 102,
                "speed": "TRAFFIC_JAM"
              },
              {
                "startPolylinePointIndex": 102,
                "endPolylinePointIndex": 107,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 107,
                "endPolylinePointIndex": 110,
                "speed": "TRAFFIC_JAM"
              },
              {
                "startPolylinePointIndex": 110,
                "endPolylinePointIndex": 116,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 116,
                "endPolylinePointIndex": 120,
                "speed": "TRAFFIC_JAM"
              },
              {
                "startPolylinePointIndex": 120,
                "endPolylinePointIndex": 122,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 122,
                "endPolylinePointIndex": 124,
                "speed": "TRAFFIC_JAM"
              },
              {
                "startPolylinePointIndex": 124,
                "endPolylinePointIndex": 131,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 131,
                "endPolylinePointIndex": 135,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 135,
                "endPolylinePointIndex": 137,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 137,
                "endPolylinePointIndex": 142,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 142,
                "endPolylinePointIndex": 144,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 144,
                "endPolylinePointIndex": 145,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 145,
                "endPolylinePointIndex": 151,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 151,
                "endPolylinePointIndex": 159,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 159,
                "endPolylinePointIndex": 163,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 163,
                "endPolylinePointIndex": 168,
                "speed": "NORMAL"
              }
            ]
          },
          "routeToken":
              "CoIECocDChAOsM1IdSp5kVe9z43BzbkqEnS93YUQSa_VMoLw1sN96EW1Fu_DuvysRj5uuQsBnDpyxnm_CBIth9FNjGeN8s9pzqPByIZ96g8Rs9OjlTDkMKdWMx9dK4mJgdQKey7jL-FyptZMEoiRNrRlFQDCFtHNSqUJ9YCmaUwWdYsYXHKdar_fXZN4rRqlAZaCr98MBZkU4iTpAZwDwQkr0APnDcYB740H9I0LiQG0DdIVsQGeDMG-AbQBtB_mLMMBjQJdHqkZ5xKWAZoL_YQCqAGNAr4bjwLBqATDngE7_AIhRbEwzQWUAkz8Clf4uv-JqQG2T_yOATfEBf4FN-QKogNHk2vV1gHyAYUCxAIrzg3GNQn6KOsMA72PAuQ9FKiuAYMHrAE-WSD4DvsKQpwF3hvpASIEVVV1BToBD0ImIYABE7cLNK4PW0ZD_AIakwoRJRCGAyIZhAG0ASQvngGjCg_lAR9KCFwtDT9Eju49eAGqARdpLUQxWmQtOEpxR3FqTXdQOXNHQjhBVRAEGl0KWwoYCg0KAggBEQAAAAAAgGZAETDdJAaBC6xAEiAIABADEAYQExASGAJCDgoGEIOb268GGgIIBSoASgIIASIbChdpLUQxWmZpaEpLR3FqTXdQOXNHQjhBVXABKAEiFQAiBVmhMQw1bzx-oZfyIDlOuFSdBg"
        },
        {
          "legs": [
            {
              "travelAdvisory": {
                "speedReadingIntervals": [
                  {
                    "startPolylinePointIndex": 0,
                    "endPolylinePointIndex": 1,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 1,
                    "endPolylinePointIndex": 13,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 13,
                    "endPolylinePointIndex": 14,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 14,
                    "endPolylinePointIndex": 15,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 15,
                    "endPolylinePointIndex": 18,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 18,
                    "endPolylinePointIndex": 28,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 28,
                    "endPolylinePointIndex": 34,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 34,
                    "endPolylinePointIndex": 44,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 44,
                    "endPolylinePointIndex": 45,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 45,
                    "endPolylinePointIndex": 47,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 47,
                    "endPolylinePointIndex": 48,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 48,
                    "endPolylinePointIndex": 86,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 86,
                    "endPolylinePointIndex": 88,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 88,
                    "endPolylinePointIndex": 96,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 96,
                    "endPolylinePointIndex": 98,
                    "speed": "TRAFFIC_JAM"
                  },
                  {
                    "startPolylinePointIndex": 98,
                    "endPolylinePointIndex": 102,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 102,
                    "endPolylinePointIndex": 107,
                    "speed": "TRAFFIC_JAM"
                  },
                  {
                    "startPolylinePointIndex": 107,
                    "endPolylinePointIndex": 121,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 121,
                    "endPolylinePointIndex": 122,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 122,
                    "endPolylinePointIndex": 127,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 127,
                    "endPolylinePointIndex": 147,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 147,
                    "endPolylinePointIndex": 152,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 152,
                    "endPolylinePointIndex": 154,
                    "speed": "TRAFFIC_JAM"
                  },
                  {
                    "startPolylinePointIndex": 154,
                    "endPolylinePointIndex": 159,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 159,
                    "endPolylinePointIndex": 167,
                    "speed": "NORMAL"
                  },
                  {
                    "startPolylinePointIndex": 167,
                    "endPolylinePointIndex": 171,
                    "speed": "SLOW"
                  },
                  {
                    "startPolylinePointIndex": 171,
                    "endPolylinePointIndex": 176,
                    "speed": "NORMAL"
                  }
                ]
              }
            }
          ],
          "distanceMeters": 9931,
          "duration": "1945s",
          "polyline": {
            "encodedPolyline":
                "ifehDoopgOAb@b@U`@KpAINEHG`@e@d@]}@eCk@{AeAmC_AyBi@uAi@uAWs@CEeE_LSe@k@wAIIYc@{@gC{@kBsAuDgAcDyB}FGYiAyHmC}Qa@cB]cAc@cAmB_DQOKK@SHKNBFJ@FlBq@pAm@|BmAdI}E^UxD}BxEqClDuBlBgAjEaCjAGdBY`@SSyAIy@Ao@ByCJuAJq@dAoE`@aCh@wCdAyERSTK`@?fLtA`DZfAaJReCfGj@bBLpD\\vA?NGN@HP?BvAf@bAJpE~@fItA\\HnALzDKpBGt@CfCEpDItN_@b@?XW\\mA`@s@ZeA@OrC_VKIEQFQNEHDB@DRlAT`Q`CL@vAP\\Jr@[XWxGsQbK{X`B{Dd@b@Wp@`@Rp@HhBJt@Jr@RFBxA`@dA\\hATNJBPDVCz@GRm@n@ELKvBAvB?`ADh@tAn@r@VLBCKBaAb@oCNk@NYBKr@sBh@sAPe@l@m@j@aAHSJLPPDFz@lA~@|A^`@~@mB\\a@HKpA}@nEoC|@UNBv@VFBfEjBB@~@`@LDDBr@f@BNVd@HNFU"
          },
          "travelAdvisory": {
            "speedReadingIntervals": [
              {
                "startPolylinePointIndex": 0,
                "endPolylinePointIndex": 1,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 1,
                "endPolylinePointIndex": 13,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 13,
                "endPolylinePointIndex": 14,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 14,
                "endPolylinePointIndex": 15,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 15,
                "endPolylinePointIndex": 18,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 18,
                "endPolylinePointIndex": 28,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 28,
                "endPolylinePointIndex": 34,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 34,
                "endPolylinePointIndex": 44,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 44,
                "endPolylinePointIndex": 45,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 45,
                "endPolylinePointIndex": 47,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 47,
                "endPolylinePointIndex": 48,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 48,
                "endPolylinePointIndex": 86,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 86,
                "endPolylinePointIndex": 88,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 88,
                "endPolylinePointIndex": 96,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 96,
                "endPolylinePointIndex": 98,
                "speed": "TRAFFIC_JAM"
              },
              {
                "startPolylinePointIndex": 98,
                "endPolylinePointIndex": 102,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 102,
                "endPolylinePointIndex": 107,
                "speed": "TRAFFIC_JAM"
              },
              {
                "startPolylinePointIndex": 107,
                "endPolylinePointIndex": 121,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 121,
                "endPolylinePointIndex": 122,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 122,
                "endPolylinePointIndex": 127,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 127,
                "endPolylinePointIndex": 147,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 147,
                "endPolylinePointIndex": 152,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 152,
                "endPolylinePointIndex": 154,
                "speed": "TRAFFIC_JAM"
              },
              {
                "startPolylinePointIndex": 154,
                "endPolylinePointIndex": 159,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 159,
                "endPolylinePointIndex": 167,
                "speed": "NORMAL"
              },
              {
                "startPolylinePointIndex": 167,
                "endPolylinePointIndex": 171,
                "speed": "SLOW"
              },
              {
                "startPolylinePointIndex": 171,
                "endPolylinePointIndex": 176,
                "speed": "NORMAL"
              }
            ]
          },
          "routeToken":
              "CpkFCp4EChClB2zCEBGefAMOwwIT8G4qEqwBvd2FEEmv1TKC8NbDfehFtRbvw7oGYdN3wdmDTdfnpgbMqgex56wsmucmdfGPK0XYG0oMBoDgZ5XYDFFejZqsb54JyqHFihYDk3UL-qEaMCfjisr7fCsl2ZTj_8s_D8VonNG4YE14PyKokJBfHs3I9PF4nh0Pr4U6glI21tQQZIAVWoYDjJ4KAhQB80ZkE_5YBxNS2tJ7EmAKHntGaUwWdYsYXHKdar_fXZN4rRrsAZaCr98MBZkU4iTpAZwDwQkr1BXIBbkB0VzUHRvgF_cSRfU8rQfXAqgCxAyVAazUBdTJBE7GYNqdAQGEAgcZk1ePjQEGU_oDFsIB0hVDsAWtFroBsxHQFXGhXNqgBEPoDoQilQGmMNIRLZgOoQeFAflG9R25AqMSxBeDAc_ImqQE5QegJiFuywIqcMoMb86YBKL4BFPXBtcwEpAZzwa6Ae8wlhLPAXvCCiKuZvk86AHViAGVSHW9PbgnlQGEUu6tAckB603_JlaeCekIAJYWxRYc4AjuYMcBlXvjxAGyAT5ZINgN1wtCkgb4HOkBIgZVVdWqVQE6ARVCOyGAARn5DY0BJBOOEIcBdnbHAVQUG8cILqECxwEsHPcCJhekBx4VKNsBlQGwAUx78wFCjQEzwgIP5AEgSghcLQ0_RI7uPXgBqgEXaS1EMVplQzhKcUdxak13UDlzR0I4QVUQBBpdClsKGAoNCgIIAREAAAAAAIBmQBHwp8ZL9wCvQBIgCAAQAxAGEBMQEhgCQg4KBhCDm9uvBhoCCAUqAEoCCAEiGwoXaS1EMVpmaWhKS0dxak13UDlzR0I4QVVwASgBIhUAIgVZod7Cbqu2rGciFfSgEvEZXvk"
        }
      ]
    };

    double degreesToRadians(double degrees) {
      return degrees * pi / 180;
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

    String jsonData = json.encode(jsonDataobj);
    final jsonDataObj = json.decode(jsonData);
    List<List<dynamic>> unique_duration = [];
    List<dynamic> unique_distance = [];

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
      double totalDistace = slowDistance + jamDistance + normalDistance;
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
      'duration': unique_duration,
      'distanceMeters': totalDistace,
      'normalDistance': normalDistance,
      'slowDistance': slowDistance,
      'jamDistance': jamDistance,
    });
    
  
    
  } else {
    print("Warning: Skipping insertion of represent_data with existing normalDistance.");
  }

      await collection.insert(
          {'_id': mongo.ObjectId(), 'points': points, 'trafficarr': traffic});
      await _db.close();
      print("Db closed");
    }


// gpt
// void storePolylineSegments(List<List<LatLng>> datastomongo, List<List<String>> condition) async {
//   late mongo.Db _db;
//   String connectionString = "mongodb+srv://legolasbhatia123:legolas@cluster0.f1w1qjx.mongodb.net/traffic?retryWrites=true&w=majority";
//   _db = await mongo.Db.create(connectionString);
//   await _db.open();
//   print("Db connected");

//   var collection = _db.collection('polyline_segments');

//   List<Map<String, dynamic>> trafficAndPointsData = [];
//   List<Map<String, dynamic>> result = [];
  
//   for (int i = 0; i < datastomongo.length; i++) { 
//     List<Map<String, dynamic>> points = []; // Reset points list for each iteration
//     List<String> traffic = []; // Reset traffic list for each iteration

//     for (int j = 0; j < datastomongo[i].length; j++) {
//       try {
//         Map<String, dynamic> point = {
//           'latitude': datastomongo[i][j].latitude,
//           'longitude': datastomongo[i][j].longitude,
//           'traffic': condition[i][j]
//         };
//         points.add(point);
//         traffic.add(condition[i][j]);
//       } catch (e) {
//         print('Error: $e, writing "traffic_jam"');
//         Map<String, dynamic> point = {
//           'latitude': 'traffic_jam',
//           'longitude': 'traffic_jam',
//           'traffic': 'traffic_jam'
//         };
//         points.add(point);
//         traffic.add('traffic_jam');
//       }
//     }
    
//     await collection.insert({
//       '_id': mongo.ObjectId(),
//       'points': points,
//       'trafficarr': traffic
//     });

//     result.addAll(computeDistanceAndTraffic(points)); // Add results for each segment to the overall result

//     print("results here: $result");
//   }

//   double normalDistance = 0;
//   double slowDistance = 0;
//   double jamDistance = 0;

//   for (var data in result) {
//     double distance = data['distance'];
//     String traffic = data['traffic'];

//     if (traffic == 'NORMAL') {
//       normalDistance += distance;
//     } else if (traffic == 'SLOW') {
//       slowDistance += distance;
//     } else if (traffic == 'TRAFFIC_JAM') {
//       jamDistance += distance;
//     }
//   }

//   final datasforgraph = _db.collection('represent_data');
//   double totalDistace  = slowDistance + jamDistance + normalDistance;
//   await datasforgraph.insert({
//     'duration': unique_duration, // Ensure you have unique_duration defined somewhere in your code
//     'distanceMeters': totalDistace,
//     'normalDistance': normalDistance,
//     'slowDistance': slowDistance,
//     'jamDistance': jamDistance,
//   });

//   await _db.close();
//   print("Db closed");
// }

































// void storePolylineSegments(List<List<LatLng>> datastomongo, List<List<String>> condition) async {
//   late mongo.Db _db;
//   String connectionString =
//       "mongodb+srv://legolasbhatia123:legolas@cluster0.f1w1qjx.mongodb.net/traffic?retryWrites=true&w=majority";
//   _db = await mongo.Db.create(connectionString);
//   await _db.open();
//   print("Db connected");

//   var collection = _db.collection('polyline_segments');
//   var representDataCollection = _db.collection('represent_data');

//   List<Map<String, dynamic>> points = [];
//   List<String> traffic = [];
//   List<Map<String, dynamic>> result = [];

//   for (int i = 0; i < datastomongo.length; i++) {
//     if (datastomongo[i].length == 0) {
//       print("Error: Empty route at index $i. Skipping.");
//       continue; // Skip empty routes
//     }

//     for (int j = 0; j < datastomongo[i].length; j++) {
//       try {
//         // Validate data types (optional)
//         if (datastomongo[i][j].latitude is! double || datastomongo[i][j].longitude is! double) {
//           print("Error: Invalid data type for latitude or longitude at index [$i][$j]. Skipping point.");
//           continue;
//         }

//         Map<String, dynamic> point = {
//           'latitude': datastomongo[i][j].latitude,
//           'longitude': datastomongo[i][j].longitude,
//           'traffic': condition[i][j]
//         };
//         points.add(point);
//         traffic.add(condition[i][j]);
//       } catch (e) {
//         print('Error: $e, writing "traffic_jam"');
//         points.add({
//           'latitude': 'traffic_jam',
//           'longitude': 'traffic_jam',
//           'traffic': 'traffic_jam'
//         });
//         traffic.add('traffic_jam');
//       }
//     }

//     result = computeDistanceAndTraffic(points); // Assuming computeDistanceAndTraffic handles points

//     // Clear points and traffic lists for the next route
//     points.clear();
//     traffic.clear();
//   }

//   double normalDistance = 0;
//   double slowDistance = 0;
//   double jamDistance = 0;

//   for (var data in result) {
//     double distance = data['distance'];
//     String trafficType = data['traffic'];

//     if (trafficType == 'NORMAL') {
//       normalDistance += distance;
//     } else if (trafficType == 'SLOW') {
//       slowDistance += distance;
//     } else if (trafficType == 'TRAFFIC_JAM') {
//       jamDistance += distance;
//     } else {
//       print("Warning: Unknown traffic type: $trafficType. Skipping distance calculation.");
//       // Handle unexpected traffic type (optional: log or throw exception)
//     }
//   }

//   // Represent data (summary) for each route
//   double totalDistance = slowDistance + jamDistance + normalDistance;

//   // Validate all required fields before insertion
//   if (unique_duration == null || totalDistance == null || normalDistance == null || slowDistance == null || jamDistance == null) {
//     print("Error: Missing required data for represent_data insertion. Skipping.");
//     return; // Exit if required data is missing
//   }
// bool shouldInsert = true;
// Future<void> checkAndRemoveDuplicate(normalDistance, slowDistance, jamDistance) async {
//   // Find documents where all three distances match
//   var duplicateDocs = await representDataCollection.find({
//     'normalDistance': normalDistance,
//     'slowDistance': slowDistance,
//     'jamDistance': jamDistance
//   }).toList();

//   // Track encountered documents to keep one copy of each unique document
//   var encounteredDocs = <String>{};

//   // Remove redundant data while keeping one copy of each unique document
//   for (var doc in duplicateDocs) {
//     var docId = doc['_id'].toString();
//     if (encounteredDocs.contains(docId)) {
//       // Remove redundant document
//       await representDataCollection.remove({'_id': doc['_id']});
//     } else {
//       // Mark this document as encountered
//       encounteredDocs.add(docId);
//     }
//   }
// }
//   // Assuming necessary initialization steps before this

//   await checkAndRemoveDuplicate(normalDistance, slowDistance, jamDistance);

//   if (shouldInsert) {
//     await representDataCollection.insertOne({
//       'duration': unique_duration,
//       'distanceMeters': totalDistance,
//       'normalDistance': normalDistance,
//       'slowDistance': slowDistance,
//       'jamDistance': jamDistance,
//     });


//     await checkAndRemoveDuplicate(normalDistance, slowDistance, jamDistance);
//   } else {
//     print("Warning: Skipping insertion of represent_data with existing normalDistance.");
//   }

// await collection.insertOne({
//       '_id': mongo.ObjectId(),
//       'points': points,
//       'trafficarr': traffic
//     });

//   await _db.close();
//   print("Db closed");
// }




// List<TrafficCondition> speed = [];
    String concatenatedData = '';

    List<dynamic> some_final_to_another = [];

    List<dynamic> routes = jsonDataobj['routes']; //3
    print("routes ko total length:${routes.length}");
    bool ekchotimatra = true;
    int count = 0;
// List<dynamic> route = jsonDataObj['routes']['legs'];
// print("legs haru ko  ko total length:${route.length}");
    for (var route in routes) {
      print("legs haru kati choti chaleko xa?: ${route.length}"); //6
      List<dynamic> each_duration = [
        route['duration'],
        route['distanceMeters']
      ];
      dynamic each_distanceMeters = route['distanceMeters'];
      unique_distance.add(each_distanceMeters);
      unique_duration.add(each_duration);
      List<List<String>> speedsList = [];
      List<List<LatLng>> datastomongo = [];
      List<dynamic> legs = route['legs'];
      List<String> speeds = [];
      List<LatLng> decodedPolyline =
          _decodePolyline(route['polyline']['encodedPolyline']);
      datastomongo.add(decodedPolyline);

      for (var leg in legs) {
        List<dynamic> intervals =
            leg['travelAdvisory']['speedReadingIntervals'];
        for (var interval in intervals) {
          int start = interval['startPolylinePointIndex'];
          int end = interval['endPolylinePointIndex'];
          String speed = interval['speed'];

          // Add speed information to the list
          for (int i = start; i <= end; i++) {
            speeds.add(speed);
          }
        }
      }
      speedsList.add(speeds);

      // Parse traffic intervals and color polylines accordingly
      for (var interval in route['legs'][0]['travelAdvisory']
          ['speedReadingIntervals']) {
        int startIdx = interval['startPolylinePointIndex'];
        int endIdx = interval['endPolylinePointIndex'];
        List<LatLng> segmentCoordinates =
            decodedPolyline.sublist(startIdx, endIdx + 1);
        TrafficCondition condition = TrafficCondition.values.firstWhere(
            (e) => e.toString().split('.').last == interval['speed'],
            orElse: () => TrafficCondition.NORMAL);

        Color color = _colorMap[condition] ??
            Colors.grey; // Default to grey if no match found
        polylines.add(
          Polyline(
            polylineId: PolylineId('segment_${startIdx}_$endIdx'),
            color: color,
            points: segmentCoordinates,
            width: 5, // Adjust width as needed
          ),
        );
      }
// if(count == 0){
      storePolylineSegments(datastomongo, speedsList);

// }
// count ++;

// print("storepolylinesegment run");
    }
    print("duration ko values haru:$unique_duration");
    print("distance ko values haru:$unique_distance");

// Call storePolylineSegments after the loop to ensure it's called only once with the complete data

    // print("speed ko values : $speed");
    // print("finalto database list list dynamic: $some_final_to_another");
    inspectData = polylines;

    return polylines;
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble()));
    }
    return points;
  }
}

enum TrafficCondition { SLOW, NORMAL, TRAFFIC_JAM }

class TrafficLatLng {
  final LatLng coordinates;
  final TrafficCondition trafficCondition;

  TrafficLatLng(this.coordinates, this.trafficCondition);
}

//start:bottomslider:#####################################################################

//for graph representation widget
class ChartToggleWidget extends StatefulWidget {
  @override
  _ChartToggleWidgetState createState() => _ChartToggleWidgetState();
}

class _ChartToggleWidgetState extends State<ChartToggleWidget> {
  // Variable to control the visibility of BarChartSample6
  bool showChart1 = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // Toggle visibility of BarChartSample6
            setState(() {
              showChart1 = !showChart1;
            });
          },
          child: Text(' Chart'),
        ),
        // Conditionally show BarChartSample6 based on showChart1 value
        if (showChart1) BarChartSample6(),
      ],
    );
  }
}

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

late List<BarChartGroupData> chartData;

class BarChartSample6 extends StatelessWidget {
  List<BarChartGroupData> generateChartData(List<List<double>> data) {
    List<BarChartGroupData> chartData = [];

    for (int i = 0; i < data.length; i++) {
      chartData.add(generateGroupData(i, data[i][0], data[i][1], data[i][2]));
    }

    return chartData;
  }

  final List<List<double>> data = data_for_graph;
  // =fetchDataFromMongoDB();
  //  [
  //   [2, 4, 6],
  //   [2, 5, 1.7],
  //   [1.3, 3.1, 2.8],
  //   [3.1, 4, 3.1],
  //   [0.8, 3.3, 3.4],
  //   [2, 5.6, 1.8],
  //   [1.3, 3.2, 2],
  // ];

  //final List<List<double>> data = List<List<dynamic>> allTrafficData
  BarChartSample6({Key? key}) : super(key: key) {
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
    const style = TextStyle(fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0:
        text = '5';
        break;
      case 1:
        text = '10';
        break;
      case 2:
        text = '15';
        break;
      case 3:
        text = '20';
        break;
      case 4:
        text = '25';
        break;
      case 5:
        text = '30';
        break;
      case 6:
        text = '35';
        break;
      case 7:
        text = '40';
        break;
      case 8:
        text = '45';
        break;
      case 9:
        text = '50';
        break;
      case 10:
        text = '55';
        break;
      case 11:
        text = '60';
        break;
      default:
        text = '';
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  String getFormattedTime(int hour, int minute) {
    String hourStr = hour.toString().padLeft(2, '0');
    String minuteStr = minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const int expectedTime = 10; // 10 minutes interval
    int hour = 10; // Initial hour
    int minute = 0; // Initial minute
    switch (value.toInt()) {
      case 0:
        return Text(
          getFormattedTime(hour, minute),
          style: TextStyle(fontSize: 10),
        );
      case 1:
        minute += expectedTime;
        if (minute >= 60) {
          minute -= 60;
          hour += 1;
        }
        return Text(
          getFormattedTime(hour, minute),
          style: TextStyle(fontSize: 10),
        );
      case 2:
        minute += 2 * expectedTime;
        if (minute >= 60) {
          minute -= 60;
          hour += 1;
        }
        return Text(
          getFormattedTime(hour, minute),
          style: TextStyle(fontSize: 10),
        );
      case 3:
        minute += 3 * expectedTime;
        if (minute >= 60) {
          minute -= 60;
          hour += 1;
        }
        return Text(
          getFormattedTime(hour, minute),
          style: TextStyle(fontSize: 10),
        );
      case 4:
        minute += 4 * expectedTime;
        if (minute >= 60) {
          minute -= 60;
          hour += 1;
        }
        return Text(
          getFormattedTime(hour, minute),
          style: TextStyle(fontSize: 10),
        );
      case 5:
        minute += 5 * expectedTime;
        if (minute >= 60) {
          minute -= 60;
          hour += 1;
        }
        return Text(
          getFormattedTime(hour, minute),
          style: TextStyle(fontSize: 10),
        );
      case 6:
        minute += 6 * expectedTime;
        if (minute >= 60) {
          minute -= 60;
          hour += 1;
        }
        return Text(
          getFormattedTime(hour, minute),
          style: TextStyle(fontSize: 10),
        );
      default:
        return SizedBox();
    }
  }

  void handleTouchCallback(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 200, // Adjust the height as needed
            child: TimingsChart(), // Replace TimingsChart with your widget
          );
        });
    // Navigator.of(context).push(MaterialPageRoute(
    //   builder: (context) => TimingsChart(),
    // ));
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
              'Activity',
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

//                   barTouchData: BarTouchData(
//       enabled: true,
// touchCallback: (FlTouchEvent event,BarTouchResponse? barTouchResponse) {
//       if (event == PointerDownEvent) {
//         handleTouchCallback(context);
//         Navigator.of(context).push(MaterialPageRoute(
//     builder: (context) => BarDetailsScreen(),
//   ));
//       }
//     },
//     ),
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
                              //  BarDetailsScreen(barData: barData),

                              TaskManager(),
                          // BarLabelScreen(
                          //    chartData: chartData,//chart ko data vanda  pani each bar ko bottom time pathaune ho
                          // ),
                        ));
                        // };
                      } catch (error) {
                        print('Error navigating to barLabelScreen: $error');
                        // Handle navigation error gracefully (e.g., show a snackbar)
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
