import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/footer.dart';
import '../components/traffic_chart.dart';
import '../components/traffic_buttons.dart'; // Import your floating component

class TrafficPage extends StatelessWidget {
  const TrafficPage({Key? key}) : super(key: key);

  void _onSubComponentTap(String text) {
    // Handle 'For Departure' or 'For Return' button click
    print("Tapped on: $text");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Header(), // Position Header on top
          Positioned(
            top: 10.0, // Adjust top based on Header height
            left: 0,
            right: 0,
            bottom: 0,
            child: Stack( // Wrap content in another Stack
              children: [
                TrafficChart(), // Body content below Header
                Positioned( // Position floating component at bottom
                  bottom: 10.0, // Adjust bottom position
                  left: 0,
                  right: 0,
                  child: TrafficButtons(
                    onTap: (text) => _onSubComponentTap(text), // Call function on left tap
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Footer(), // Use Footer component for the bottom bar
    );
  }
}
