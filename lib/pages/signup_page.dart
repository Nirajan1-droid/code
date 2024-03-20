import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

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
            crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
            children: [
              // Logo
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Image(
                  image: AssetImage('assets/icons/traffic-logo.png'), // Replace with your logo image
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

              const SizedBox(height: 10.0), // Gap between input fields
              // Checkbox options for transportation
              TransportationCheckboxes(),
              const SizedBox(height: 10.0), // Gap between button

              // Register button
              ElevatedButton(
                onPressed: () {
                  // Handle registration logic
                },
                child: const Text('Register'),
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.95, 50.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                
              ),
              const SizedBox(height: 10.0), // Gap between input fields
              Text("Already have an account? Login"),

            ],
          ),
        ),
      ),
    );
  }
}

// Checker
class TransportationCheckboxes extends StatefulWidget {
  const TransportationCheckboxes({super.key});

  @override
  State<TransportationCheckboxes> createState() =>
      _TransportationCheckboxesState();
}

class _TransportationCheckboxesState extends State<TransportationCheckboxes> {
  Map<String, bool> transportOptions = {
    '2 Wheeler': false,
    '4 Wheeler': false,
    'Public Vehicle': false,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(" Your means of transportation:",
            style: TextStyle(
              fontSize: 16.0, // Set your desired font size
              color: Colors.black, // Change color if needed (optional)
            ),
          ),
        ),
        SizedBox(height: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CheckboxSelector(
              iconPath: 'assets/icons/bike.png',
              label: '2 Wheeler',
              value: transportOptions['2 Wheeler'] ?? false,
              onChanged: (value) =>
                  setState(() => transportOptions['2 Wheeler'] = value ?? false),
            ),
            CheckboxSelector(
              iconPath: 'assets/icons/car.png',
              label: '4 Wheeler',
              value: transportOptions['4 Wheeler'] ?? false,
              onChanged: (value) =>
                  setState(() => transportOptions['4 Wheeler'] = value ?? false),
            ),
            CheckboxSelector(
              iconPath: 'assets/icons/bus.png',
              label: 'Public Vehicle',
              value: transportOptions['Public Vehicle'] ?? false,
              onChanged: (value) =>
                  setState(() => transportOptions['Public Vehicle'] = value ?? false),
            ),
          ],
        ),
      ],
    );
  }
}

class CheckboxSelector extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool value;
  final void Function(bool?) onChanged;

  const CheckboxSelector({
    super.key,
    required this.iconPath,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.blue.shade300;
    }

    return Row(
      children: [
        InkWell(
          onTap: () => onChanged(!value), // Update value on tap
          borderRadius: BorderRadius.circular(10.0),
          child: Padding(
            padding: const EdgeInsets.only(right: 50.0), // Add right padding
            child: Row(
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: value,
                  onChanged: onChanged,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(50.0), // Adjust as needed
                    side: BorderSide(
                      color: Colors.red, // Set border color to red
                      width: 2.0, // Adjust border width as needed
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Image.asset(iconPath, height: 35),
                SizedBox(width: 8),
                Text(label),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
