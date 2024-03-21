import 'package:flutter/material.dart';
import 'commute_page2.dart';

class CommutePage1 extends StatefulWidget {
  @override
  _CommutePage1State createState() => _CommutePage1State();
}

class _CommutePage1State extends State<CommutePage1> {
  final _formKey = GlobalKey<FormState>(); // For form validation
  String _from = "";
  String _to = "";

  void _validateAndNavigate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CommutePage2()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill both fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Commute'),
      ),
      body: Center(
        child: SingleChildScrollView( // Allow content to scroll if overflowing
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icons/traffic-logo.png', width: 150, height: 150,fit: BoxFit.cover), // Replace 'logo.png' with your logo path
                // SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Home',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.95,
                    ),
                  ),
                  validator: (value) => (value!.isEmpty) ? 'Please enter a value' : null,
                  onSaved: (value) => _from = value!,
                ),
                SizedBox(height: 10),
                Image.asset('assets/icons/loop.png', color: Colors.green.shade300, width: 40), 
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Destination',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.95,
                    ),
                  ),
                  validator: (value) => (value!.isEmpty) ? 'Please enter a value' : null,
                  onSaved: (value) => _to = value!,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _validateAndNavigate,
                  child: Text('Next'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.95, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
