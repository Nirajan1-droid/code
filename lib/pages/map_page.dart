import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taskes/kaamkocodes/19main.dart';
 
class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(Duration(seconds: 5)), // Emit a new value every 5 seconds
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return PolylineMap(); // Return the PolylineMap widget
      },
    );
  }
}
