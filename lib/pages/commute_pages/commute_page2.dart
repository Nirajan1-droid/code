import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'commute_page3.dart';

class CommutePage2 extends StatefulWidget {
  @override
  _CommutePage2State createState() => _CommutePage2State();
}

class _CommutePage2State extends State<CommutePage2> {
  final _formKey = GlobalKey<FormState>(); // For form validation
  bool _monSelected = false;
  bool _tueSelected = false;
  bool _wedSelected = false;
  bool _thuSelected = false;
  bool _friSelected = false;
  bool _satSelected = false;
  bool _sunSelected = false;
  String _field1 = "";
  String _field2 = "";
  String _field3 = "";
  String _field4 = "";

  void _validateAndNavigate() {
    if (_formKey.currentState!.validate() && (_monSelected || _tueSelected || _wedSelected || _thuSelected || _friSelected || _satSelected || _sunSelected)) {
      _formKey.currentState!.save();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CommutePage3()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select at least one day')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Commute'),
      ),
      body: Center(
        child: SingleChildScrollView( // Allow content to scroll if overflowing
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('What\'s your timing?', style: TextStyle(fontSize: 15.0)),
                SizedBox(height: 10),
                // Home and Destination Icons
                Container(
                  // margin: EdgeInsets.only(top: 25.0), // Add top margin
                  padding: EdgeInsets.only(top: 25.0), // Adjust horizontal padding as needed
                  color: Colors.white,
                  child: Scaffold(
                    appBar: PreferredSize(
                      preferredSize: Size.fromHeight(kToolbarHeight),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0), // Adjust horizontal padding as needed
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white, // Set app bar background color
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: Offset(0, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/home-colored.svg', // Path to your SVG asset
                                      width: 40, // Adjust width as needed
                                      height: 40, // Adjust height as needed
                                    ),
                                    const SizedBox(
                                        height: 4), // Add space between icon and text
                                    const Text(
                                      'Home', // Your text here
                                      style: TextStyle(
                                        fontSize: 12, // Adjust font size as needed
                                        color: Colors.black, // Set text color
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  // Add your left icon onPressed action
                                },
                              ),
                              // The horizontal line between Home and Destination
                              SizedBox(
                                height: 10, // Set the height of the horizontal line
                                width: 200, // Set the width of the horizontal line
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.green, // Set the color of the line
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            
                              IconButton(
                                icon: Column(
                                  children: [
                                    Image.asset(
                                      'assets/icons/office-colored.png', // Path to your icon1.png asset
                                      width: 40, // Adjust width as needed
                                      height: 40, // Adjust height as needed
                                    ),
                                    const SizedBox(
                                        height: 4), // Add space between icon and text
                                    const Text(
                                      'Destination', // Your text here
                                      style: TextStyle(
                                        fontSize: 12, // Adjust font size as needed
                                        color: Colors.black, // Set text color
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  // Add your right icon onPressed action
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    body: Container(), // Your body content goes here
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: 50,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Field 1',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) => (value!.isEmpty) ? 'Please enter a value' : null,
                        onSaved: (value) => _field1 = value!,
                      ),
                    ),
                    SizedBox(width: 10),
                    Image.asset('assets/icons/right-dot-arrow.png', width:  MediaQuery.of(context).size.width * 0.2),
                    SizedBox(width: 10),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: 50,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Field 2',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) => (value!.isEmpty) ? 'Please enter a value' : null,
                        onSaved: (value) => _field2 = value!,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: 50,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Field 3',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) => (value!.isEmpty) ? 'Please enter a value' : null,
                        onSaved: (value) => _field3 = value!,
                      ),
                    ),
                    SizedBox(width: 10),
                    Image.asset('assets/icons/left-dot-arrow.png', width:  MediaQuery.of(context).size.width * 0.2), // Replace 'icon.png' with your icon path
                    SizedBox(width: 10),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: 50,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Field 4',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) => (value!.isEmpty) ? 'Please enter a value' : null,
                        onSaved: (value) => _field4 = value!,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: _monSelected,
                      onChanged: (value) => setState(() => _monSelected = value!),
                    ),
                    Text('Mon'),
                    SizedBox(width: 10),
                    Checkbox(
                      value: _tueSelected,
                      onChanged: (value) => setState(() => _tueSelected = value!),
                    ),
                    Text('Tue'),
                    SizedBox(width: 10),
                    Checkbox(
                      value: _wedSelected,
                      onChanged: (value) => setState(() => _wedSelected = value!),
                    ),
                    Text('Wed'),
                    SizedBox(width: 10),
                    Checkbox(
                      value: _thuSelected,
                      onChanged: (value) => setState(() => _thuSelected = value!),
                    ),
                    Text('Thu'),
                    SizedBox(width: 10),
                    Checkbox(
                      value: _friSelected,
                      onChanged: (value) => setState(() => _friSelected = value!),
                    ),
                    Text('Fri'),
                    SizedBox(width: 10),
                    Checkbox(
                      value: _satSelected,
                      onChanged: (value) => setState(() => _satSelected = value!),
                    ),
                    Text('Sat'),
                    SizedBox(width: 10),
                    Checkbox(
                      value: _sunSelected,
                      onChanged: (value) => setState(() => _sunSelected = value!),
                    ),
                    Text('Sun'),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _validateAndNavigate,
                  child: Text('Next'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.95, 50),
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
