import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:taskes/pages/commute_pages/commute_page2.dart';
List<double> dynamic_source_ko_coordinate1 = [];
List<double> dynamic_destination_ko_coordinate1 = [];
void main() {
  runApp(MaterialApp(
    home: CommutePage1(),
  ));
}

class CommutePage1 extends StatefulWidget {
  @override
  _CommutePage1State createState() => _CommutePage1State();
}

class _CommutePage1State extends State<CommutePage1> {
  final _formKey = GlobalKey<FormState>(); // For form validation
  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();
  final String PLACES_API_KEY = "API_KEY_ROUTE_API_ENABLE_FROM_GOOGLE";
  List<String> _fromPlaceList = [];
  List<String> _toPlaceList = [];

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }
   
  void _validateAndNavigate() {
    if (_fromController.text.isNotEmpty && _toController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CommutePage2()
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill both fields')),
      );
    }
  }

  void getSuggestions(String input, {required bool isFrom}) async {
    try {
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request = '$baseURL?input=$input&key=$PLACES_API_KEY';
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<dynamic> predictions = data['predictions'];
        List<String> placeNames = [];
        for (var prediction in predictions) {
          String placeName = prediction['description'];
          placeNames.add(placeName);
        }
        setState(() {
          if (isFrom) {
            _fromPlaceList = placeNames;
          } else {
            _toPlaceList = placeNames;
          }
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text('Commute'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          // Allow content to scroll if overflowing
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.zero,
                  child: Image.asset('assets/icons/traffic-logo.png',
                      width: 150, height: 100, fit: BoxFit.cover),
                ), // SizedBox(height: 10),
                TextFormField(
                  controller: _fromController,
                  decoration: InputDecoration(
                    hintText: 'Home',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _fromController.clear();
                        setState(() {
                          _fromPlaceList.clear();
                        });
                      },
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.95,
                    ),
                  ),
                  validator: (value) =>
                      (value!.isEmpty) ? 'Please enter a value' : null,
                  onChanged: (value) {
                    getSuggestions(value, isFrom: true);
                  },
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _fromPlaceList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_fromPlaceList[index]),
                      onTap: () {
                        setState(() {
                          _fromController.text = _fromPlaceList[index];
                          _fromPlaceList.clear();
                        });
                      },
                    );
                  },
                ),
                SizedBox(height: 80),
                Image.asset('assets/icons/loop.png',
                    color: Colors.green.shade300, width: 40),
                SizedBox(height: 80),
                TextFormField(
                  controller: _toController,
                  decoration: InputDecoration(
                    hintText: 'Destination',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _toController.clear();
                        setState(() {
                          _toPlaceList.clear();
                        });
                      },
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.95,
                    ),
                  ),
                  validator: (value) =>
                      (value!.isEmpty) ? 'Please enter a value' : null,
                  onChanged: (value) {
                    getSuggestions(value, isFrom: false);
                  },
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _toPlaceList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_toPlaceList[index]),
                      onTap: () {
                        setState(() {
                          _toController.text = _toPlaceList[index];
                          _toPlaceList.clear();
                        });
                      },
                    );
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _validateAndNavigate,
                  child: Text('Next'),
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.95, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class CommutePage2 extends StatelessWidget {
//   final String from;
//   final String to;

//   const CommutePage2({Key? key, required this.from, required this.to})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Commute Details'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'From: $from',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'To: $to',
//               style: TextStyle(fontSize: 20),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }