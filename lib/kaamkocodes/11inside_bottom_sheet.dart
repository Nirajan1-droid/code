import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarDetailsScreen extends StatelessWidget {
  String barData;
   BarDetailsScreen({Key? key,  required this.barData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: GestureDetector(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "barData",
            style: TextStyle(
                color: Color.fromARGB(255, 66, 48, 48),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text('Pilates: ${barData.barRods[0]}'),
      //       Text('Quick Workout: ${barData.barRods[1]}'),
      //       Text('Cycling: ${barData.barRods[2]}'),
      //     ],
      //   ),
      // ),
    );
  }
}
