import 'package:flutter/material.dart';

class CommutePage3 extends StatefulWidget {
  @override
  _CommutePage3State createState() => _CommutePage3State();
}

class _CommutePage3State extends State<CommutePage3> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key for validation
  List<TaskForm> _tasks = []; // List to store task data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Commute'), // Optional app bar title
      ),
      body: SingleChildScrollView( // Make content scrollable
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Title text
              Text(
                'Commute Tasks',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),

              // Home and arrow icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/home.png', height: 50.0), // Replace with your home icon image asset path
                  SizedBox(width: 20.0),
                  Icon(Icons.arrow_forward_ios, size: 30.0),
                ],
              ),
              SizedBox(height: 20.0),

              // Text paragraph
              Text(
                'Add tasks that you do at home before heading to destination',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),

              // List of task forms
              ListView.builder(
                shrinkWrap: true, // Prevent excessive scrolling
                physics: NeverScrollableScrollPhysics(), // Disable list scrolling
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return TaskForm(key: ValueKey(index), onDelete: () => removeTask(index));
                },
              ),

              // Add and Delete buttons (flex row)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.add),
                    onPressed: () => addTask(),
                    label: Text('New'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 40.0),
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.delete),
                    onPressed: () => removeTask(_tasks.length - 1), // Remove last task
                    label: Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 40.0),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),

              // Skip and Next buttons (flex row)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context), // Navigate back (Skip)
                    child: Text('Skip'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 40.0),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => submitTasks(), // Validate and navigate
                    child: Text('Next'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 40.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addTask() {
    setState(() {
      _tasks.add(TaskForm()); // Add a new task form to the list
    });
  }

  void removeTask(int index) {
    if (_tasks.isNotEmpty && index >= 0 && index < _tasks.length) {
      setState(() {
        _tasks.removeAt(index); // Remove the task at the specified index
      });
    }
  }

  void submitTasks() {
    if (_formKey.currentState!.validate()) { // Check for validation errors
      // All forms are valid, proceed with data storage and navigation
      List<String> taskNames = [];
      for (var taskForm in _tasks) {
        taskNames.add(taskForm.taskNameController.text);
      }

      // Implement your logic to store the task names in a data structure (e.g., list, database)
      // You can replace this with your preferred storage method
      print('Task Names: $taskNames'); // Example output

      Navigator.pop(context); // Navigate back (Next) after successful validation and storage
    } else {
      // Show a snackbar or other visual cue to indicate validation errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all task fields')),
      );
    }
  }
}

// TaskForm class to represent each task entry
class TaskForm extends StatefulWidget {
  final Function() onDelete; // Callback for deleting the task

  const TaskForm({Key? key, required this.onDelete}) : super(key: key);

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final TextEditingController taskNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form( // Wrap each task form with a Form widget
      key: GlobalKey<FormState>(), // Form key for validation within each task
      child: Row(
        children: [
          Expanded( // Rounded text input field for task name
            child: TextFormField(
              controller: taskNameController,
              validator: (value) => value!.isEmpty ? 'Please enter a task name' : null,
              decoration: InputDecoration(
                hintText: 'Task Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          IconButton( // Delete button for each task
            icon: Icon(Icons.delete),
            onPressed: widget.onDelete,
          ),
        ],
      ),
    );
  }
}

