import 'package:flutter/material.dart';

class TrafficButtons extends StatefulWidget {
  final Function(String text) onTap;

  const TrafficButtons({Key? key, required this.onTap}) : super(key: key);

  @override
  State<TrafficButtons> createState() => _TrafficButtonsState();
}

class _TrafficButtonsState extends State<TrafficButtons> {
  bool _isLeftBoxTapped = false;
  bool _isRightBoxTapped = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8.0,
            spreadRadius: 0.1,
          ),
        ],
      ),
      child: Padding(
        // Add padding here
        padding: const EdgeInsets.symmetric(
            horizontal: 5.0), // Adjust padding as needed
        child: Row(
          children: [
            _buildSubComponent(context, text: "For Departure", side: "Left"),
            SizedBox(width: 5.0),
            _buildSubComponent(context, text: "For Return", side: "Right"),
          ],
        ),
      ),
    );
  }

  Widget _buildSubComponent(BuildContext context,
      {required String text, required String side}) {
    Color baseColor = Colors.blue.shade50; // Adjust base color as needed
    Color tapColor = Colors.blue.shade100; // Adjust tap color as needed
    Color borderColor = Colors.blue.shade200; // Adjust tap color as needed
    Color boxColor = (side == "Left" && _isLeftBoxTapped) ||
            (side == "Right" && _isRightBoxTapped)
        ? tapColor
        : baseColor;

    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => setState(() {
          if (side == "Left") {
            _isLeftBoxTapped = true;
          } else {
            _isRightBoxTapped = true;
          }
        }),
        onTapCancel: () => setState(() {
          _isLeftBoxTapped = false;
          _isRightBoxTapped = false;
        }),
        onTapUp: (_) => setState(() {
          _isLeftBoxTapped = false;
          _isRightBoxTapped = false;
          widget.onTap(text); // Call original onTap after tap release
        }),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.1,
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: borderColor, // Set your desired border color
                  width: 1.0, // Set border width (optional)
                ),
                borderRadius: BorderRadius.circular(15.0),
                color: boxColor, // Use the calculated box color
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset('assets/icons/home-colored-p.png',
                      width: 35.0, height: 35.0),
                  side == "Left"
                      ? Image.asset('assets/icons/right-dot-arrow.png',
                          fit: BoxFit.cover, width: 80)
                      : Image.asset('assets/icons/left-dot-arrow.png',
                          fit: BoxFit.cover, width: 80),
                  Image.asset('assets/icons/office-colored.png',
                      width: 35.0, height: 35.0), // Adjust based on side
                ],
              ),
            ),
            Text(
              text,
              style: TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }
}
