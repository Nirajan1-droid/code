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
  String _selectedDuration = '1 Hour';

// form Validation Logic *******
  void _validateAndNavigate() {
    if (_formKey.currentState!.validate() &&
        (_monSelected ||
            _tueSelected ||
            _wedSelected ||
            _thuSelected ||
            _friSelected ||
            _satSelected ||
            _sunSelected) &&
            _field1 != "" &&
            _field2 != "" &&
            _field3 != "" &&
            _field4 != "") {
      _formKey.currentState!.save();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CommutePage3()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Please fill all fields and select at least one day')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Commute'),
      ),
      body: Center(
        child: SingleChildScrollView(
          // Allow content to scroll if overflowing
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('What\'s your timing?', style: TextStyle(fontSize: 15.0)),
                SizedBox(height: 10),
                // Home and Destination Icons ***
                Container(
                  // Wrap the Row with a container
                  width: MediaQuery.of(context).size.width *
                      0.8, // Set width to 90% of screen
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/icons/home-colored-p.png',
                          width: 50), // Replace with your home icon path
                      Center(
                        child: Image.asset(
                          'assets/icons/loop-rect.png',
                          width: 150,
                          height: 50,
                          fit: BoxFit.contain,
                          color: Colors.green.shade500,
                        ),
                      ),
                      Image.asset('assets/icons/office-colored.png',
                          width: 50), // Replace with your destination icon path
                    ],
                  ),
                ),

                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: 40,
                      child: 
                      TimeInputField(
                        hintText: 'Departure Time',
                        onTimeSelected: (String selectedTime) {
                          // Handle the selected time here
                          _field1 = selectedTime;
                          print('Selected Time: $selectedTime');
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Image.asset('assets/icons/right-dot-arrow.png',
                        width: MediaQuery.of(context).size.width * 0.2),
                    SizedBox(width: 10),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: 40,
                      child: 
                      TimeInputField(
                        hintText: 'Arrival Time',
                        onTimeSelected: (String selectedTime) {
                          // Handle the selected time here
                          _field2 = selectedTime;
                          print('Selected Time: $selectedTime');
                        },
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
                      height: 40,
                      child: 
                      TimeInputField(
                        hintText: 'Return Time',
                        onTimeSelected: (String selectedTime) {
                          // Handle the selected time here
                          _field3 = selectedTime;
                          print('Selected Time: $selectedTime');
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Image.asset('assets/icons/left-dot-arrow.png',
                        width: MediaQuery.of(context).size.width * 0.2), // Replace 'icon.png' with your icon path
                    SizedBox(width: 10),
                    // Time Input Form
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: 40,
                      child: 
                      TimeInputField(
                        hintText: 'Leave Time',
                        onTimeSelected: (String selectedTime) {
                          // Handle the selected time here
                          _field4 = selectedTime;
                          print('Selected Time: $selectedTime');
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.only(left: 10.0, bottom: 5.0),
                  alignment: Alignment.topLeft, // Align content to top-left
                  child: Text(
                    'Active Days',
                    style: TextStyle(
                      fontSize: 15.0, // Set desired font size
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700, // Set text color (optional)
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCheckbox(
                        'Sun',
                        _sunSelected,
                        (value) => setState(() => {
                              _sunSelected = value,
                              _onCheckboxChange('Sun', value)
                            })),
                    SizedBox(width: 10),
                    _buildCheckbox(
                        'Mon',
                        _monSelected,
                        (value) => setState(() => {
                              _monSelected = value,
                              _onCheckboxChange('Mon', value)
                            })),
                    SizedBox(width: 10),
                    _buildCheckbox(
                        'Tue',
                        _tueSelected,
                        (value) => setState(() => {
                              _tueSelected = value,
                              _onCheckboxChange('Tue', value)
                            })),
                    SizedBox(width: 10),
                    _buildCheckbox(
                        'Wed',
                        _wedSelected,
                        (value) => setState(() => {
                              _wedSelected = value,
                              _onCheckboxChange('Wed', value)
                            })),
                    SizedBox(width: 10),
                    _buildCheckbox(
                        'Thu',
                        _thuSelected,
                        (value) => setState(() => {
                              _thuSelected = value,
                              _onCheckboxChange('Thu', value)
                            })),
                    SizedBox(width: 10),
                    _buildCheckbox(
                        'Fri',
                        _friSelected,
                        (value) => setState(() => {
                              _friSelected = value,
                              _onCheckboxChange('Fri', value)
                            })),
                    SizedBox(width: 10),
                    _buildCheckbox(
                        'Sat',
                        _satSelected,
                        (value) => setState(() => {
                              _satSelected = value,
                              _onCheckboxChange('Sat', value)
                            })),
                  ],
                ),
                SizedBox(height: 10),
                // "Notification Before" Dropdown Menu
                Container(
                  margin: EdgeInsets.only(left: 10.0, bottom: 5.0),
                  alignment: Alignment.topLeft, // Align content to top-left
                  child: Column(
                    // Use Column for vertical layout
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Align text and dropdown left
                    children: [
                      Text(
                        'Notification Before',
                        style: TextStyle(
                          fontSize: 15.0, // Set desired font size
                          fontWeight: FontWeight.bold,
                          color:
                              Colors.grey.shade700, // Set text color (optional)
                        ),
                      ),
                      SizedBox(
                          height:
                              5.0), // Add a small vertical space between text and dropdown
                      Container(
                        width: 80,
                        padding: EdgeInsets.only(left: 10.0),
                        decoration: BoxDecoration( // Add decoration for border to container
                          borderRadius: BorderRadius.circular(10.0), // Rounded corners
                          border: Border.all( // Add border
                            color: Colors.grey, // Border color (adjust as needed)
                            width: 1.0, // Border width (adjust as needed)
                          ),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedDuration, // Selected value (replace with your state variable)
                          icon: Icon(Icons.arrow_drop_down), // Dropdown icon
                          iconSize: 18.0, // Icon size
                          elevation: 16, // Shadow effect
                          style: TextStyle(
                            color: Colors.black, // Dropdown text color
                            fontSize: 14.0, // Dropdown text size
                          ),
                          underline: Container(
                            height: 0,
                            color: Colors.transparent, // Remove default underline
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedDuration = newValue!; // Update selected value (replace with your state update)
                              handleDropDown(newValue);
                            });
                          },
                          items: <String>['1 Hour', '2 Hour', '3 Hour']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),

                    ],
                  ),
                ),

                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.only(left: 10.0, bottom: 5.0),
                  alignment: Alignment.topCenter, // Align content to top-left
                  child: Text(
                    'The above timing should be set with respect to normal average traffic.',
                    style: TextStyle(
                      fontSize: 13.0, // Set desired font size
                      fontWeight: FontWeight.normal,
                      color: Colors.grey.shade600, // Set text color (optional)
                    ),
                  ),
                ),
                SizedBox(height: 10),
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

// This function creates a reusable circular checkbox with text
Set<String> _selectedDays = {};

Widget _buildCheckbox(String text, bool value, Function(bool) onChanged) {
  return InkWell(
    borderRadius: BorderRadius.circular(50),
    onTap: () => onChanged(!value),
    child: Container(
      padding: EdgeInsets.all(8),
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: value ? Colors.green.shade100 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          // Add border property
          color: value
              ? Colors.green.shade300
              : Colors.grey.shade200, // Set border color to blue
          width: 1.0, // Set border width (optional)
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 9.0),
        ),
      ),
    ),
  );
}

// Time Input Form
class TimeInputField extends StatefulWidget {
  final String hintText; // Optional hint text for the field
  final Function(String) onTimeSelected; // Callback function to handle selected time

  const TimeInputField({
    Key? key,
    required this.hintText,
    required this.onTimeSelected,
  }) : super(key: key);

  @override
  _TimeInputFieldState createState() => _TimeInputFieldState();
}

class _TimeInputFieldState extends State<TimeInputField> {
  String _selectedTime = ''; // Stores the selected time

  @override
  Widget build(BuildContext context) {
    return InkWell( // Use InkWell for tap functionality
      onTap: () async {
        final TimeOfDay? selectedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (selectedTime != null) {
          setState(() {
            _selectedTime = selectedTime.format(context); // Format time (HH:MM:SS AM/PM)
          });
          widget.onTimeSelected(_selectedTime); // Call callback with selected time
        }
      },
      child: Container( // Container for the input field
        padding: EdgeInsets.symmetric(horizontal: 10.0), // Add padding
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey), // Add border
          borderRadius: BorderRadius.circular(5.0), // Rounded corners
        ),
        child: Row( // Use Row for horizontal layout
          children: [
            Text(_selectedTime.isEmpty ? widget.hintText : _selectedTime), // Display hint text or selected time
          ],
        ),
      ),
    );
  }
}

// *************** Selected Days Data update ***************
void _onCheckboxChange(String day, bool value) {
  if (value) {
    _selectedDays.add(day); // Add day to Set when selected
    print(_selectedDays);
  } else {
    _selectedDays.remove(day); // Remove day from Set when deselected
    print(_selectedDays);
  }
}
// ********** Handle Notification Before Hour Value ************
void handleDropDown(String selectedHour)
{
  print(selectedHour);
}
void handleLeave(String timeValue)
{
  print(timeValue);
}