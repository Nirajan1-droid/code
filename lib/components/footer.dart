import 'package:flutter/material.dart';

class Footer extends StatefulWidget {
  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  final int sectionsNum = 4;

  int _selectedIndex = 1; // No selection by default

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print('Selected item: $index'); // Replace with your desired action
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Adjust shadow color (transparency)
            blurRadius: 10.0, // Adjust blur radius (spread of the shadow)
            spreadRadius: 2.0, // Adjust spread radius (distance of the shadow from the box)
            offset: Offset(0.0, 4.0), // Adjust shadow offset (X: horizontal, Y: vertical)
          ),
      ],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: List.generate(
          sectionsNum,
          (index) => _buildFooterItem(index),
        ),
      ),
    );
  }

  Widget _buildFooterItem(int index) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => _onItemSelected(index),
        child: Container(
          padding: EdgeInsets.all(8.0),
          height: 80.0,
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.grey.shade200
                : Colors.transparent, // Highlight on selection
            border: Border(
              left: BorderSide(
                width: index == 0 ? 1.0 : 0.0,
                color: Colors.grey.shade300, // Vertical divider
              ),
              right: BorderSide(
                width: 1.0,
                color: Colors.grey.shade300, // Vertical divider
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                index == 0
                    ? 'assets/icons/schedule-colored.png'
                    : index == 1
                        ? 'assets/icons/traffic-colored.png'
                        : index == 2
                            ? 'assets/icons/map-colored.png'
                            : index == 3
                                ? 'assets/icons/settings-colored.png'
                                : "", // Path to your asset
                width: 35, // Adjust width as needed
                height: 35, // Adjust height as needed
              ),
              SizedBox(height: 4.0),
              Text(
                index == 0
                    ? 'Schedule'
                    : index == 1
                        ? 'Traffic'
                        : index == 2
                            ? 'Map'
                            : index == 3
                                ? 'Settings'
                                : "",
                style: TextStyle(fontSize: 12.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
