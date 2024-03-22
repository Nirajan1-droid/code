import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/schedule_list.dart';
import '../components/footer.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Header(), // Position Header on top
          Positioned(
            top: 10, // Adjust top based on Header height
            left: 0,
            right: 0,
            bottom: 0,
            // child: _buildBody(context), // Body content below Header
            child: Schedule(), // Body content below Header
          ),
        ],
      ), // Use Body component for main content
      bottomNavigationBar: Footer(sectionIndex:0), // Use Footer component for the bottom bar
    );
  }
}