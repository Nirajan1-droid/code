import 'package:flutter/material.dart';
import 'package:taskes/main.dart';
import 'package:taskes/pages/commute_pages/commute_page1.dart';
import 'package:taskes/pages/login_page.dart';
import 'package:taskes/pages/signup_page.dart';
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
                      onTap: () => handleSettings(context, index), // Print message with adjusted index (1-based)
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

void handleSettings(BuildContext context, int index)
{
  // Handle Setting Tap according to the index number
  print('Option ${index + 1} tapped');
  if(index == 0)
  {
    
  }
  if(index == 1)
  {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CommutePage1()),
    );
  }
  if(index == 2)
  {

  }
  if(index == 3)
  {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
  }
  if(index == 4)
  {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignUpPage()),
      );
  }
  if(index == 5)
  {
    isLoggedIn = false;
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
  }
}