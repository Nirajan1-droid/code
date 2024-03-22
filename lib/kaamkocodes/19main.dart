import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
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
import 'package:taskes/components/map.dart';
import 'package:taskes/kaamkocodes/12taskmanager.dart';
import 'package:taskes/kaamkocodes/19main.dart';
import 'package:taskes/kaamkocodes/3file.dart';
import 'package:taskes/kaamkocodes/4file.dart';
import 'package:taskes/kaamkocodes/5dartkocopy.dart';
import 'package:taskes/kaamkocodes/5dartkothirdgraph.dart';
import 'package:taskes/kaamkocodes/5file.dart';
import 'package:taskes/kaamkocodes/6utils.dart';
import 'package:taskes/kaamkocodes/9storeindb.dart';
import 'package:taskes/kaamkocodes/resources/app_colors.dart';
import 'package:taskes/kaamkocodes/widgets/legend_widget.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:getwidget/getwidget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:taskes/main.dart';
import 'package:taskes/pages/commute_pages/commute_page1.dart';
import 'package:taskes/pages/commute_pages/commute_page2.dart';
List<double> source1 = dynamic_source_ko_coordinate1;
List<double> destination1 = dynamic_destination_ko_coordinate1;
String dynamic_departure_time = departuretime_dynamic;
 bool analyzedstatus = false;
String convertToIso8601(String timeString) {
  // Parse the input time string
  final DateFormat inputFormat = DateFormat('h:mm a');
  final DateTime parsedTime = inputFormat.parse(timeString);

  // Create a DateTime object for today with the parsed time
  final DateTime now = DateTime.now();
  final DateTime departureDateTime =
      DateTime(now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);

  // Format the DateTime object to ISO 8601 format
  final DateFormat iso8601Format = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  final String iso8601String = iso8601Format.format(departureDateTime);

  return iso8601String;
}
 List<double> source = [27.72100872488963, 85.28649337497556];
  List<double> destination = [27.679807526706504, 85.32730017497411];

//tespaxi dynamc vayepaxi:

//   List<double> destination1 = dynamic_destination_ko_coordinate;
      LatLng sourcekolocation = LatLng(source.first, source.last);
   LatLng destinationkolocation = LatLng(destination.first, destination.last);

void sendDirectionsRequest(List<double> source, List<double> destination, String segment) async {
   String iso8601Time = convertToIso8601(segment);
String apiKey = 'AIzaSyCP3qu-d2OgoVc7rv8Lq9PVbL-aFICr-Qc'; // Replace with your API key
  String apiUrl = 'https://routes.googleapis.com/directions/v2:computeRoutes';

  // JSON payload for the POST request
  String payload = '''
    {
      "origin": {
        "location": {
          "latLng": {
            "latitude": ${source[0]},
            "longitude": ${source[1]}
          }
        }
      },
      "destination": {
        "location": {
          "latLng": {
            "latitude": ${destination[0]},
            "longitude": ${destination[1]}
          }
        }
      },
      
       "routingPreference": "TRAFFIC_AWARE_OPTIMAL",    
  "computeAlternativeRoutes": true,
   "departureTime": "$iso8601Time",
      "travelMode": "DRIVE",
       "extraComputations": ["TRAFFIC_ON_POLYLINE"],
  "routingPreference": "TRAFFIC_AWARE_OPTIMAL"
    }
  ''';

  // Headers for the POST request
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'X-Goog-Api-Key': apiKey,
    'X-Goog-FieldMask':
        'routes.route_token,routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline,routes.travelAdvisory.fuelConsumptionMicroliters,routes.travelAdvisory,routes.legs.travelAdvisory',
  };

  // Send the POST request
  http.Response response = await http.post(
    Uri.parse(apiUrl),
    headers: headers,
    body: payload,
  );
  // Parse the JSON response
  Map<String, dynamic> jsonDataobj = json.decode(response.body); // Parse JSON string into Map
  print(jsonDataobj);
  storejson_multiple(segment, jsonDataobj);
}   
 
      LatLng sourcekolocationfrommain = LatLng(source.first, source.last);
   LatLng destinationkolocationfrommain = LatLng(destination.first, destination.last);

bool bar_Chart_load_status = false;
List<Map<String,dynamic>> JsonDataObjectkobau = [];
List<Map<String, dynamic>> chartData = [];
List<List<double>> data_for_graph = [];
List<String> mapped_duration_for_each_element = [];
List<String> mapped_distance_for_each_element = [];
List<Map<String, dynamic>> recieved = [];
List<List<int>> intervalLists = [];
List<String> uniqueDistanceKm = [];
// Step 2: Create lists of durations and distances for each unique distance [3]
  List<List<String>> durationsForEachDistance = [];
  List<List<List<double>>> distancesForEachDistance = [];
  //segment haru provide garne function lai 
  List<String> segmentedTimeArray_dynamic = generateTimeSegments(dynamic_departure_time);
  // List<String> segmentedTimeArray = giverkosegmentedarray
List<String> segmentedTimeArray = ['09:10 AM','09:20 AM','09:30 AM','09:40 AM'];
Map<String,dynamic> something = {};

// Function to show loader
void showLoader() {
  print('Showing loader...');
  // Your implementation to show loader
}

// Function to hide loader
void hideLoader() {
  print('Hiding loader...');
  // Your implementation to hide loader
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: MyAppmainpage(),
    
  )); 
  //first ma existed json delete garne [1]
// await deleteAllDocuments();

  // Send the POST request
  // http.Response response = await http.delete(
  //   Uri.parse('http://127.0.0.1:5000/delete_json_all'),
    
  // );
  
  //   // Check if the request was successful
  //   if (response.statusCode == 200) {
  //     print('All documents deleted successfully');
  //   } else {
  //     print('Failed to delete documents: ${response.reasonPhrase}');
  //   }
//   showLoader();
//     await Future.delayed(const Duration(seconds: 5), ()async {
//       hideLoader();
//         for (int i = 0;i<segmentedTimeArray.length;i++) {
//     sendDirectionsRequest(source, destination, segmentedTimeArray[i]);
  
// } // Show loader
  // JsonDataObjectkobau =  await  fetchJsonDataObjects();
    // });
  // tespaxi json create garna chahien data vayo [4] we execute the function to make list of json.
//   for (int i = 0;i<segmentedTimeArray.length;i++) {
//     sendDirectionsRequest(source, destination, segmentedTimeArray[i]);
  
// } // Show loader
  showLoader();
  await Future.delayed(const Duration(seconds: 15), ()async {
      hideLoader();
  JsonDataObjectkobau =  await  fetchJsonDataObjects();
    print("json object ko vau  : $JsonDataObjectkobau");
    if(JsonDataObjectkobau.length > 0){

     analyzedstatus = true;
   runApp(MaterialApp(
      home: MyAppmainpage(),
  ));
     
     
    }
    });
  //  Future.delayed(const Duration(seconds: 10), () async {
   
  
  // });

  
  print("json object ko vau : $JsonDataObjectkobau");
   
  // Delay execution of fetchDataFromMongoDB to ensure the app is built
  await Future.delayed(const Duration(seconds: 20) ,() async {
    chartData = await fetchDataFromMongoDB();
    // if(chartData != null){
      //  bar_Chart_load_status= true;
    });
    uniqueDistanceKm = chartData.map((data) => data['distance'] as String).toSet().toList();

  for (var distance in uniqueDistanceKm) {
    List<String> durations = [];
    List<List<double>> distances = [];
    for (var data in chartData) {
      if (data['distance'] == distance) {
        durations.add(data['duration'] as String);
        distances.add(data['distances'] as List<double>);
      }
    }

    durationsForEachDistance.add(durations);
    distancesForEachDistance.add(distances);
  }
  print("chartdata ko values:$chartData");
  print("durationsForEachDistance ko values:$durationsForEachDistance");
  print("distancesForEachDistance ko values:$distancesForEachDistance");
  print("distancesForEachDistance ko values:$distancesForEachDistance");

    print("to show in the graph : ${distancesForEachDistance[0]}");
  // });
  // Delay for 5 seconds before running the aggregate function
  Future.delayed(const Duration(seconds: 5), () async {
    // Run the aggregate function to remove redundant data
    await checkAndRemoveDuplicate();
  });
}

 class CarouselDemo extends StatefulWidget {
  final Function(int)? onPageChanged;

  const CarouselDemo({Key? key, this.onPageChanged}) : super(key: key);

  @override
  _CarouselDemoState createState() => _CarouselDemoState();
}
class _CarouselDemoState extends State<CarouselDemo> {
  int _currentIndex = 2; // Initialize current index to match initialPage
  bool _isOpen = true; // Flag to track bottom sheet visibility
 int _previousIndex = 2; // Store the previous index

  void _toggleBottomSheet() {
    setState(() {
      _isOpen = !_isOpen; // Toggle open/closed state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Your main content here

        _isOpen
            ? GFBottomSheet(
                controller: GFBottomSheetController(),
                maxContentHeight: 800,
                enableExpandableContent: true,
                stickyHeaderHeight: 100,
                stickyHeader: Container(
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

                   Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                      // Bar chart
                      child:CarouselSlider(
                        items: [
                          ChartToggleWidget(),
                          ChartToggleWidget_second(),
                          ChartToggleWidget_third(),
                          Container(color: Colors.green),
                        ],
                        carouselController: CarouselController(),
                        options: CarouselOptions(
                          autoPlay: false,
                          enlargeCenterPage: true,
                          viewportFraction: 0.9,
                          aspectRatio: 2.0,
                          initialPage: 2,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                            if (widget.onPageChanged !=null) {
                              widget.onPageChanged!(index);
                            }
                          },
                        ),
                      ),
 ),
                      ElevatedButton(
                        onPressed: () => CarouselController().nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.linear,
                        ),
                        child: Text('→'),
                      ),

                      _currentIndex == 0 ? ChartToggleWidget() : TimingsChart(),
                    ],
                  ),
                ),
              )
            : Container(), // Empty container when closed
      ],
    );
  }
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
         markers: {
                Marker(
                  markerId: MarkerId("source"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                  position: LatLng(27.72100872488963, 85.28649337497556)!,
                ),
                
                Marker(
                    markerId: MarkerId("_destionationLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: LatLng(27.679807526706504, 85.32730017497411),)
              },
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
            titleText: 'Weather Analaysis',
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

    double degreesToRadians(double degrees) {
      return degrees * pi / 180;
    }

//  List<String> segmentedTimeArray = ['12:40 PM', '12:50 PM', '01:00 PM', '01:10 PM', '01:20 PM', '01:30 PM'];


    List<dynamic> unique_distance = [];
List<List<LatLng>> segmentCoordinatesharukolist = [];
List<TrafficCondition> conditionharukolist = [];
void havetorunformap(List<Map<String,dynamic>>  JsonDataObjectkobau)
async {

for(var  jsonDataobj in  JsonDataObjectkobau){

print("json ko child: $jsonDataobj");


    String jsonData = json.encode(jsonDataobj);
// jsonDataObjdecoded

    final jsonDataObjdecoded = json.decode(jsonData);
  
    String concatenatedData = '';

    List<dynamic> some_final_to_another = [];

    List<dynamic> routes = jsonDataObjdecoded['routes']; //3
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
            segmentCoordinatesharukolist.add(segmentCoordinates);
        TrafficCondition condition = TrafficCondition.values.firstWhere(
            (e) => e.toString().split('.').last == interval['speed'],
            orElse: () => TrafficCondition.NORMAL);
            conditionharukolist.add(condition);

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
    }
    }
}
havetorunformap(JsonDataObjectkobau);
    print("duration ko values haru:$unique_duration");
    print("distance ko values haru:$unique_distance");
// Call storePolylineSegments after the loop to ensure it's called only once with the complete data

    // print("speed ko values : $speed");
    // print("finalto database list list dynamic: $some_final_to_another");
    inspectData = polylines;
    print("polylines haru yesto dekhiyeko xa list of polylines:$polylines");
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
