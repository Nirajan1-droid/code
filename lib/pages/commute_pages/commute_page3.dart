// import 'package:flutter/material.dart';

// class CommutePage3 extends StatefulWidget {
//   @override
//   _CommutePage3State createState() => _CommutePage3State();
// }

// class _CommutePage3State extends State<CommutePage3> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key for validation
//   List<TaskForm> _tasks = []; // List to store task data

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Commute'), // Optional app bar title
//       ),
//       body: SingleChildScrollView( // Make content scrollable
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               // Title text
//               Text(
//                 'Commute Tasks',
//                 style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 20.0),

//               // Home and arrow icons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset('assets/home.png', height: 50.0), // Replace with your home icon image asset path
//                   SizedBox(width: 20.0),
//                   Icon(Icons.arrow_forward_ios, size: 30.0),
//                 ],
//               ),
//               SizedBox(height: 20.0),

//               // Text paragraph
//               Text(
//                 'Add tasks that you do at home before heading to destination',
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 20.0),

//               // List of task forms
//               ListView.builder(
//                 shrinkWrap: true, // Prevent excessive scrolling
//                 physics: NeverScrollableScrollPhysics(), // Disable list scrolling
//                 itemCount: _tasks.length,
//                 itemBuilder: (context, index) {
//                   return TaskForm(key: ValueKey(index), onDelete: () => removeTask(index));
//                 },
//               ),

//               // Add and Delete buttons (flex row)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   ElevatedButton.icon(
//                     icon: Icon(Icons.add),
//                     onPressed: () => addTask(),
//                     label: Text('New'),
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 40.0),
//                     ),
//                   ),
//                   ElevatedButton.icon(
//                     icon: Icon(Icons.delete),
//                     onPressed: () => removeTask(_tasks.length - 1), // Remove last task
//                     label: Text('Delete'),
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 40.0),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20.0),

//               // Skip and Next buttons (flex row)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   OutlinedButton(
//                     onPressed: () => Navigator.pop(context), // Navigate back (Skip)
//                     child: Text('Skip'),
//                     style: OutlinedButton.styleFrom(
//                       minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 40.0),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () => submitTasks(), // Validate and navigate
//                     child: Text('Next'),
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 40.0),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void addTask() {
//     setState(() {
//       _tasks.add(TaskForm(onDelete: () => {},)); // Add a new task form to the list
//     });
//   }

//   void removeTask(int index) {
//     if (_tasks.isNotEmpty && index >= 0 && index < _tasks.length) {
//       setState(() {
//         _tasks.removeAt(index); // Remove the task at the specified index
//       });
//     }
//   }

//   void submitTasks() {
//     if (_formKey.currentState!.validate()) { // Check for validation errors
//       // All forms are valid, proceed with data storage and navigation
//       List<String> taskNames = [];
//       for (var taskForm in _tasks) {
//         taskNames.add("Lol");
//       }

//       // Implement your logic to store the task names in a data structure (e.g., list, database)
//       // You can replace this with your preferred storage method
//       print('Task Names: $taskNames'); // Example output

//       Navigator.pop(context); // Navigate back (Next) after successful validation and storage
//     } else {
//       // Show a snackbar or other visual cue to indicate validation errors
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please fill out all task fields')),
//       );
//     }
//   }
// }

// // TaskForm class to represent each task entry
// class TaskForm extends StatefulWidget {
//   final Function() onDelete; // Callback for deleting the task

//   const TaskForm({Key? key, required this.onDelete}) : super(key: key);

//   @override
//   _TaskFormState createState() => _TaskFormState();
// }

// class _TaskFormState extends State<TaskForm> {
//   final TextEditingController taskNameController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Form( // Wrap each task form with a Form widget
//       key: GlobalKey<FormState>(), // Form key for validation within each task
//       child: Row(
//         children: [
//           Expanded( // Rounded text input field for task name
//             child: TextFormField(
//               controller: taskNameController,
//               validator: (value) => value!.isEmpty ? 'Please enter a task name' : null,
//               decoration: InputDecoration(
//                 hintText: 'Task Name',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 10.0),
//           IconButton( // Delete button for each task
//             icon: Icon(Icons.delete),
//             onPressed: widget.onDelete,
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class CommutePage3 extends StatefulWidget {
  @override
  _CommutePage3State createState() => _CommutePage3State();
}

class _CommutePage3State extends State<CommutePage3> {
  List<CommuteForm> forms = [CommuteForm()]; // Initial form list

  void addNewForm() {
    setState(() {
      forms.add(CommuteForm());
    });
  }

  void deleteForm() {
    if (forms.length > 1) {
      setState(() {
        forms.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Commute'),
      ),
      body: Column(
        children: [
          Text('Have some pre-tasks?',
            style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.0),

          // Home and arrow icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icons/home-colored-p.png', height: 50.0), // Replace with your home icon image asset path
              Image.asset('assets/icons/right-dot-arrow.png', height: 50.0), // Replace with your home icon image asset path
            ],
          ),
          SizedBox(height: 20.0),

          // Text paragraph
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0), // Adjust margin values as needed
            child: Text(
              'Add tasks that you do at home before heading to destination',
              textAlign: TextAlign.left,
            ),
          ),

        SizedBox(height: 20.0),
        Container(
          height: MediaQuery.of(context).size.height * 0.35, 
          child:
            SingleChildScrollView(
              child: Column(
                children: [
                  for (var form in forms) buildCommuteForm(form),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 10.0),
              ElevatedButton(
                onPressed: addNewForm,
                child: Text('New'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // 10px border radius
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              ElevatedButton(
                onPressed: deleteForm,
                child: Text('Delete'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // 10px border radius
                  ),
                ),
              ),
            ],
          ),
        SizedBox(height: 10.0),
          Column(
      children: [
        Padding(padding: EdgeInsets.symmetric(horizontal: 10.0), 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // SizedBox(width: 10.0),
            ElevatedButton(
              onPressed: () => handleSkip(),
              child: Text('Skip'),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width * 0.46, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
               backgroundColor: Colors.grey.shade200,
              ),
            ),
            ElevatedButton(
              onPressed: () => handleNext(),
              child: Text('Next'),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width * 0.46, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
               backgroundColor: Colors.green.shade100,
              ),
            ),
            // SizedBox(width: 10.0),
          ],
        ),
        )
      ],
    ),
        ],
      ),
    );
  }

  Widget buildCommuteForm(CommuteForm form) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0), // Adjust margin values as needed
          child:
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Task Name',
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners
                      ),
                    ),
                    controller: form.textFieldController1,
                  ),
                ),
              ],
            ),
        ),
        SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0), // Adjust margin values as needed
          child:
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Start Time',
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners
                    ),
                    ),
                    controller: form.textFieldController2,
                  ),
                  flex: 4,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'End Time',
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners
                    ),
                    ),
                    controller: form.textFieldController3,
                  ),
                  flex: 4,
                ),
              ],
            ),
        ),
      ],
    );
  }
}

class CommuteForm {
  final TextEditingController textFieldController1 = TextEditingController();
  final TextEditingController textFieldController2 = TextEditingController();
  final TextEditingController textFieldController3 = TextEditingController();
}

void handleSkip()
{
  print("Skipped");
}

void handleNext()
{
  print("Next");
}