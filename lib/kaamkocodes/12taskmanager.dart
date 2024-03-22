import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

// void main() {
//   runApp(TaskManager());
// }

class TaskManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TaskListScreen(),
    );
  }
}

class Task {
  final String id;
  String name;
  String priority;
  int timeTaken; // in minutes
  int startTime; // in minutes from departure time

  Task({
    required this.id,
    required this.name,
    required this.priority,
    required this.timeTaken,
    required this.startTime,
  });
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late mongo.Db _db;
  late DateTime _departureTime;
  late List<Task> _tasks = [];

  void refreshTasks() {
    _fetchTasks();
  }

  @override
  void initState() {
    super.initState();
    _departureTime = DateTime(2024, 3, 19, 9, 5); // Example departure time
    _connectToDatabase();
  }

  Future<void> _connectToDatabase() async {
    try {
      String connectionString =
          "mongodb+srv://legolasbhatia123:legolas@cluster0.f1w1qjx.mongodb.net/traffic?retryWrites=true&w=majority";
      _db = await mongo.Db.create(connectionString);
      await _db.open();
      _fetchTasks();
    } catch (e) {
      print('Error connecting to database: $e');
    }
  }

  Future<void> _fetchTasks() async {
    try {
      final collection = _db.collection('work_list');
      final tasks = await collection.find().toList();
      setState(() {
        _tasks = tasks.map((task) {
          return Task(
            id: task['_id'].toString(),
            name: task['name'] as String,
            priority: (task['priority'] ),
            timeTaken: task['timeTaken'] as int,
            startTime: 0, // Initialize to 0, will be scheduled later
          );
        }).toList();
      });
      _scheduleTasks();
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.yellow;
      case 'Low':
      default:
        return Colors.green;
    }
  }

  void _scheduleTasks() {
    // Calculate total time required for all tasks
    int totalTimeRequired = _tasks.fold(0, (sum, task) => sum + task.timeTaken);

    // Calculate start time range
    DateTime startTimeRange = _departureTime.subtract(Duration(minutes: totalTimeRequired));

    // Sort tasks by priority
    _tasks.sort((a, b) => _comparePriority(a.priority , b.priority ));

    // // Schedule tasks based on priority and available time slots within the start time range
    int currentStartTime = startTimeRange.hour * 60 + startTimeRange.minute;
    // Calculate total minutes from midnight for departure time
// int departureMinutes = _departureTime.hour * 60 + _departureTime.minute;

// Schedule tasks based on priority and available time slots within the start time range
// int currentStartTime = departureMinutes;
    for (var task in _tasks) {
      task.startTime = currentStartTime;
      currentStartTime += task.timeTaken;
      final taskStartTime = startTimeForTask(task.startTime);
    print("${task.name} Start Time: $taskStartTime");
    }

    setState(() {});
  }
   
String startTimeForTask(int startTime) {
  final currentStartHours = startTime ~/ 60;
  final currentStartMinutes = startTime % 60;
  final formattedStartTime = DateFormat('hh:mm:ss a').format(
    DateTime(2024, 3, 19, currentStartHours, currentStartMinutes),
  );
  return formattedStartTime;
}


int _comparePriority(String priorityA, String priorityB) {
  // Assign numeric values to priorities
  Map<String, int> priorityValues = {
    'High': 3,
    'Medium': 2,
    'Low': 1,
  };

  // Get numeric values of priorities
  int valueA = priorityValues[priorityA] ?? 0;
  int valueB = priorityValues[priorityB] ?? 0;

  // Compare numeric values
  return valueB - valueA; // Higher value will result in a positive number
}

  Future<void> _deleteTask(String name) async {
    try {
      final collection = _db.collection('work_list');
      await collection.remove(mongo.where.eq('name', (name)));
      _fetchTasks();
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(_tasks[index].id),
            direction: DismissDirection.horizontal,
            background: Container(
              color: Colors.green,
              alignment: Alignment.centerLeft,
              child: Icon(Icons.edit),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: Icon(Icons.delete),
            ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                // Swipe right (delete)
                await _deleteTask(_tasks[index].name);
                return true;
              } else {
                // Swipe left (edit)
                // Navigate to edit screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddTaskScreen(refreshTasks: refreshTasks),
                  ),
                );
                return false;
              }
            },
            child: TaskCard(task: _tasks[index], departureTime: _departureTime),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add task screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(refreshTasks: refreshTasks),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
Color _getTileColor(String priority) {
  switch (priority) {
    case 'High':
      return Colors.red;
    case 'Medium':
      return Colors.yellow;
    case 'Low':
      return Colors.green;
    default:
      return  Color.fromARGB(255, 241, 241, 241); // Default color if priority is not recognized
  }
}

class TaskCard extends StatelessWidget {
  String formatTime(int hours, int minutes) {
  return '${hours % 12}:${minutes.toString().padLeft(2, '0')} ${hours >= 12 ? 'PM' : 'AM'}';
}

  final Task task;
  final DateTime departureTime;

  TaskCard({required this.task, required this.departureTime});

  @override
  Widget build(BuildContext context) {
    
    String startTime = DateFormat('hh:mm:ss a').format(
      DateTime(2024, 3, 19, task.startTime ~/ 60, task.startTime % 60),
    );
    String endTime = DateFormat('hh:mm:ss a').format(
      DateTime(2024, 3, 19, (task.startTime + task.timeTaken) ~/ 60, (task.startTime + task.timeTaken) % 60),
    );

    // Calculate scheduled remainder
    int scheduledRemainder = task.startTime - departureTime.hour * 60 - departureTime.minute;

    return Card(
      child: ListTile(
        title: Text(task.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Start Time: $startTime, End Time: $endTime'),
            Text('Scheduled Remainder: $scheduledRemainder minutes'),
          ],
        ),
        tileColor: _getTileColor(task.priority as String)

      ),
    );
    
  }
}


class AddTaskScreen extends StatefulWidget {
  //class calling another class method
  final Function() refreshTasks;
AddTaskScreen({required this.refreshTasks});

//refreshTask now can be called in calss
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late String _taskName;
  late String _priority; // Change type to String
  late int _timeTaken;
  String _selectedAlarm = 'None';
  List<String> _alarms = [];

  @override
  void initState() {
    super.initState();
    _taskName = '';
    _priority = 'Low'; // Default priority
    _timeTaken = 0;
    _loadAlarmFiles();
  }

  Future<void> _loadAlarmFiles() async {
    Directory alarmDir = Directory('alarm/');
    List<FileSystemEntity> files = alarmDir.listSync(recursive: true);
    setState(() {
      _alarms = files.map((file) => file.path.split('/').last).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _taskName = value;
                });
              },
              decoration: InputDecoration(labelText: 'Task Name'),
            ),
            SizedBox(height: 20),
            const Text('Select Priority:'),
            DropdownButton<String>(
              value: _priority, // Default priority
              onChanged: (String? value) {
                setState(() {
                  _priority = value!;
                });
              },
              items: <String>[
                'Low',
                'Medium',
                'High',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('Select Time Taken (minutes):'),
            TextField(
              onChanged: (value) {
                setState(() {
                  _timeTaken = int.parse(value);
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Time Taken'),
            ),
            SizedBox(height: 20),
            const Text('Select Alarm:'),
            DropdownButton<String>(
              value: _selectedAlarm,
              onChanged: (String? value) {
                setState(() {
                  _selectedAlarm = value!;
                });
              },
              items: _alarms.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                late mongo.Db _db;
                String connectionString =
                    "mongodb+srv://legolasbhatia123:legolas@cluster0.f1w1qjx.mongodb.net/traffic?retryWrites=true&w=majority";
                _db = await mongo.Db.create(connectionString);
                await _db.open();

                // Save task to database
                try {
                  
                  final collection = _db.collection('work_list');
                  await collection.insertOne({
                    'name': _taskName,
                    'priority': _priority,
                    'timeTaken': _timeTaken,
                    'alarm': _selectedAlarm,
                  });
                  // Refresh task list
                   // Show toast message for 2 seconds
                  Fluttertoast.showToast(
                    msg: 'Task added successfully!',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 2,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  

                  // Refresh task list
                  // _fetchTasks();
widget.refreshTasks();
                  // Navigate back to previous screen
                  // Navigator.pop(context);
                  Navigator.pop(context);
                } catch (e) {
                  print('Error adding task: $e');
                }
              },
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
