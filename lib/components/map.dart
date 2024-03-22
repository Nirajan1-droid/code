import 'package:flutter/material.dart';

import '../kaamkocodes/19main.dart';

class MapComponent extends StatelessWidget {
  const MapComponent({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PolylineMap(),
      // ****************** Put the Map Here ******************
    );
  }
}
