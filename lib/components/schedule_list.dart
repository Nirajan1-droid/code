// import 'package:flutter/material.dart';

// class Schedule extends StatefulWidget {
//   @override
//   _ScheduleState createState() => _ScheduleState();
// }

// class Task {
//   int number;
//   String name;
//   String startTime;
//   String endTime;

//   Task({required this.number, required this.name, required this.startTime, required this.endTime});
// }

// class _ScheduleState extends State<Schedule> {
//   int _nextListNumber = 1; // Keeps track of the next list item number
//   List<Task> tasks = []; // List to store task information

//   void addItem() {
//     // Get user input for task details (assuming a separate form is displayed)
//     String name = 'Enter Task Name'; // Replace with actual user input
//     String startTime = 'Enter Start Time'; // Replace with actual user input
//     String endTime = 'Enter End Time'; // Replace with actual user input

//     setState(() {
//       tasks.add(Task(number: _nextListNumber, name: name, startTime: startTime, endTime: endTime));
//       _nextListNumber++; // Increment for next item
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Title
//         Text(
//           'Today\'s Optimal Time',
//           style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 16.0), // Add spacing

//         // Scrollable list of tasks
//         Container(
//           height: 200.0, // Adjust height as needed
//           child: ListView.builder(
//             itemCount: tasks.length,
//             itemBuilder: (context, index) {
//               final task = tasks[index];
//               return Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                 decoration: BoxDecoration(
//                   border: Border(bottom: BorderSide(color: Colors.grey)),
//                 ),
//                 child: Row(
//                   children: [
//                     // List number circle
//                     CircleAvatar(
//                       backgroundColor: Colors.grey.shade200,
//                       child: Text(
//                         task.number.toString(),
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     SizedBox(width: 16.0),
//                     // Task details
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(task.name, style: TextStyle(fontSize: 16.0)),
//                           Text('Start: ${task.startTime}'),
//                           Text('End: ${task.endTime}'),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//         SizedBox(height: 16.0), // Add spacing

//         // Add task button
//         ElevatedButton.icon(
//           onPressed: addItem,
//           icon: Icon(Icons.add),
//           label: Text('Add Task'),
//           // style: ElevatedButton.styleFrom(
//           //   primary: Colors.blue,
//           //   onPrimary: Colors.white,
//           // ),
//         ),
//         SizedBox(height: 16.0), // Add spacing

//         // Information container with icon
//         Container(
//           padding: EdgeInsets.all(16.0),
//           decoration: BoxDecoration(
//             color: Colors.grey.shade200,
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           child: Row(
//             children: [
//               Icon(Icons.info),
//               SizedBox(width: 8.0),
//               Text('Tap a task to view details'),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class Task {
  int number;
  String name;
  String startTime;
  String endTime;

  Task(
      {required this.number,
      required this.name,
      required this.startTime,
      required this.endTime});
}

class _ScheduleState extends State<Schedule> {
  int _nextListNumber = 1;
  List<Task> tasks = [];
  final _formKey = GlobalKey<FormState>(); // Key for form validation

  void addItem() async {
    final formState = _formKey.currentState!;
    if (formState.validate()) {
      formState.save(); // Save form state after validation
      setState(() {
        tasks.add(Task(
            number: _nextListNumber,
            name: _name,
            startTime: _startTime,
            endTime: _endTime));
        _nextListNumber++;
      });
      Navigator.pop(
          context); // Close the form dialog (assuming it's displayed as a dialog)
    }
  }

  // Variables to store user input for form fields
  String _name = '';
  String _startTime = '';
  String _endTime = '';

  void _showTaskForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Task'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min, // Avoid excessive form height
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Task Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a task name' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Start Time'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter start time' : null,
                onSaved: (value) => _startTime = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'End Time'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter end time' : null,
                onSaved: (value) => _endTime = value!,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: addItem,
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 110.0), // Add 16.0 padding on all sides
        child: Column(
          children: [
            // Title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '    Today\'s Optimal Time',
                style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
              ),
            ),
            // SizedBox(height: 16.0), // Add spacing
            // Scrollable list of tasks
            Container(
              height: 200.0, // Adjust height as needed
              color: Colors.white,
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    child: Row(
                      children: [
                        // List number circle
                        CircleAvatar(
                          radius: 13.0,
                          backgroundColor: Colors.green.shade100,
                          child: Text(
                            task.number.toString(),
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        // Task details
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100.0, // Set fixed width for task name
                                child: Text(task.name,
                                    style: TextStyle(fontSize: 16.0)),
                              ),
                              Spacer(),
                              SizedBox(
                                width: 60.0, // Set fixed width for start time
                                child: Text('Start: ${task.startTime}',
                                    style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 12.0)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0), // Add spacing

            // Information container with icon
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Image(
                    image: AssetImage(
                        'assets/icons/rainfall-colored.png'), // Replace with your image path
                    height: 24.0,  
                    width: 24.0, 
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Rainfall near Home while travelling from Home to Destination',
                      maxLines: 2, // Set maxLines for wrapping
                      overflow: TextOverflow
                          .ellipsis, // Handle overflow with ellipsis
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0), // Add spacing
            // Add task button
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.95, // Set relative button width
              height: 50.0,
              child: ElevatedButton.icon(
                onPressed: _showTaskForm,
                icon: Icon(Icons.add),
                label: Text('Add Task'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(5.0), // Set desired border radius
                  ),
                  // primary: Colors.blue, // Set button color (optional)
                  // onPrimary: Colors.white, // Set text color (optional)
                ),
              ),
            ),
          ],
        ));
  }
}
