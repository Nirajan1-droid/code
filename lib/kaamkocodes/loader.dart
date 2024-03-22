import 'package:flutter/material.dart';

Future<List<Map<String, dynamic>>> fetchJsonDataObjects() async {
  // Your implementation to fetch JSON data objects
  // For demonstration, I'm returning an empty list
  return [];
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loader Demo',
      home: LoaderScreen(),
    );
  }
}

class LoaderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loader Demo'),
      ),
      body: LoaderContent(),
    );
  }
}

class LoaderContent extends StatefulWidget {
  @override
  _LoaderContentState createState() => _LoaderContentState();
}

class _LoaderContentState extends State<LoaderContent> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Start loading
    _startLoading();
  }

  void _startLoading() {
    // Show loader
    setState(() {
      isLoading = true;
    });

    // Delay for 10 seconds
    Future.delayed(const Duration(seconds: 10), () async {
      // Hide loader after 5 seconds
      await Future.delayed(const Duration(seconds: 5), () {
        // Hide loader
        setState(() {
          isLoading = false;
        });
      });

      // Fetch JSON data objects
      final jsonDataObjects = await fetchJsonDataObjects();
      print('JSON data objects: $jsonDataObjects');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? CircularProgressIndicator() // Show loader
          : Text('Loading complete'), // Show message when loading complete
    );
  }
}
