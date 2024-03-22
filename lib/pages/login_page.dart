import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taskes/main.dart';
import 'package:taskes/pages/home.dart';
import 'package:taskes/pages/signup_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  void onTransportationSelected(List<bool> isSelected) {
    // Handle selection changes here (optional)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Allow scrolling if content overflows
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center horizontally
            children: [
              // Logo
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Image(
                  image: AssetImage(
                      'assets/icons/traffic-logo.png'), // Replace with your logo image
                  fit: BoxFit.cover,
                  height: 150,
                  width: 150,
                ),
              ),

              // Username input
              TextField(
                decoration: InputDecoration(
                  hintText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),

              const SizedBox(height: 10.0), // Gap between input fields

              // Password input
              TextField(
                obscureText: true, // Hide password characters
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),

              const SizedBox(height: 10.0), // Gap between button

              // Login button
              ElevatedButton(
                onPressed: () {
                  if(isLoggedIn)
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  }
                },
                child: const Text('Login'),
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.95, 50.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 10.0), // Gap between input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text("Don't have an account? "),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
