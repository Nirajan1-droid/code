import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg package

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: 25.0), // Add top margin
      padding:
          EdgeInsets.only(top: 25.0), // Adjust horizontal padding as needed
      color: Colors.white,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 5.0), // Adjust horizontal padding as needed
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white, // Set app bar background color
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/home-colored.svg', // Path to your SVG asset
                          width: 40, // Adjust width as needed
                          height: 40, // Adjust height as needed
                        ),
                        const SizedBox(
                            height: 4), // Add space between icon and text
                        const Text(
                          'Home', // Your text here
                          style: TextStyle(
                            fontSize: 12, // Adjust font size as needed
                            color: Colors.black, // Set text color
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      // Add your left icon onPressed action
                    },
                  ),
                  // The horizontal line between Home and Destination
                  SizedBox(
                    height: 10, // Set the height of the horizontal line
                    width: 200, // Set the width of the horizontal line
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.green, // Set the color of the line
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                
                  IconButton(
                    icon: Column(
                      children: [
                        Image.asset(
                          'assets/icons/office-colored.png', // Path to your icon1.png asset
                          width: 40, // Adjust width as needed
                          height: 40, // Adjust height as needed
                        ),
                        const SizedBox(
                            height: 4), // Add space between icon and text
                        const Text(
                          'Destination', // Your text here
                          style: TextStyle(
                            fontSize: 12, // Adjust font size as needed
                            color: Colors.black, // Set text color
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      // Add your right icon onPressed action
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(), // Your body content goes here
      ),
    );
  }
}
