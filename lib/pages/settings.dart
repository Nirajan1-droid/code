import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/map.dart';
import '../components/footer.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Header(), // Position Header on top
          Positioned(
            top: 10, // Adjust top based on Header height
            left: 0,
            right: 0,
            bottom: 0,
            // child: _buildBody(context), // Body content below Header
            child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 6,
        separatorBuilder: (context, index) => const Divider(color: Colors.grey),
        itemBuilder: (context, index) {
          return 
          Material( // Wrap with Material
            child: ListTile(
                      onTap: () => handleSettings(index), // Print message with adjusted index (1-based)
                      leading: Image.asset(
                        index == 0 ? 'assets/icons/settings-colored.png' : 
                        index == 1 ? 'assets/icons/settings-colored.png' :
                        index == 2 ? 'assets/icons/settings-colored.png' :
                        index == 3 ? 'assets/icons/settings-colored.png' :
                        index == 4 ? 'assets/icons/settings-colored.png' :
                        index == 5 ? 'assets/icons/settings-colored.png' : "",
                        width: 24.0,
                        height: 24.0,
                      ),
                      title: Text(
                        index == 0 ? 'Edit Task' : 
                        index == 1 ? 'Add Commute' : 
                        index == 2 ? 'Edit Commute' : 
                        index == 3 ? 'Log In' : 
                        index == 4 ? 'Sign Up' :
                        index == 5 ? 'Log Out' : ""
                      ),
                    )
            );
          
        },
      ), // Body content below Header
          ),
        ],
      ), // Use Body component for main content
      bottomNavigationBar: Footer(sectionIndex: 3), // Use Footer component for the bottom bar
    );
  }
}

void handleSettings(int index)
{
  // Handle Setting Tap according to the index number
  print('Option ${index + 1} tapped');
}