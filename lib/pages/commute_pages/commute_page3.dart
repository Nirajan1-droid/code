import 'package:flutter/material.dart';

class CommutePage3 extends StatefulWidget {
  @override
  _CommutePage3State createState() => _CommutePage3State();
}

class _CommutePage3State extends State<CommutePage3> {
  List<CommuteForm> forms = [CommuteForm()]; // Initial form list

  void addNewForm() {
    setState(() {
      forms.add(CommuteForm());
    });
  }

  void deleteForm() {
    if (forms.length > 1) {
      setState(() {
        forms.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Commute'),
      ),
      body: Column(
        children: [
          Text('Have some pre-tasks?',
            style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.0),

          // Home and arrow icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icons/home-colored-p.png', height: 50.0), // Replace with your home icon image asset path
              Image.asset('assets/icons/right-dot-arrow.png', height: 50.0), // Replace with your home icon image asset path
            ],
          ),
          SizedBox(height: 20.0),

          // Text paragraph
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0), // Adjust margin values as needed
            child: Text(
              'Add tasks that you do at home before heading to destination',
              textAlign: TextAlign.left,
            ),
          ),

        SizedBox(height: 20.0),
        Container(
          height: MediaQuery.of(context).size.height * 0.35, 
          child:
            SingleChildScrollView(
              child: Column(
                children: [
                  for (var form in forms) buildCommuteForm(form),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 10.0),
              ElevatedButton(
                onPressed: addNewForm,
                child: Text('New'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // 10px border radius
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              ElevatedButton(
                onPressed: deleteForm,
                child: Text('Delete'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // 10px border radius
                  ),
                ),
              ),
            ],
          ),
        SizedBox(height: 10.0),
          Column(
      children: [
        Padding(padding: EdgeInsets.symmetric(horizontal: 10.0), 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // SizedBox(width: 10.0),
            ElevatedButton(
              onPressed: () => handleSkip(),
              child: Text('Skip'),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width * 0.46, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
               backgroundColor: Colors.grey.shade200,
              ),
            ),
            ElevatedButton(
              onPressed: () => handleNext(),
              child: Text('Next'),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width * 0.46, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
               backgroundColor: Colors.green.shade100,
              ),
            ),
            // SizedBox(width: 10.0),
          ],
        ),
        )
      ],
    ),
        ],
      ),
    );
  }

  Widget buildCommuteForm(CommuteForm form) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0), // Adjust margin values as needed
          child:
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Task Name',
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners
                      ),
                    ),
                    controller: form.textFieldController1,
                  ),
                ),
              ],
            ),
        ),
        SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0), // Adjust margin values as needed
          child:
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Start Time',
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners
                    ),
                    ),
                    controller: form.textFieldController2,
                  ),
                  flex: 4,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'End Time',
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners
                    ),
                    ),
                    controller: form.textFieldController3,
                  ),
                  flex: 4,
                ),
              ],
            ),
        ),
      ],
    );
  }
}

class CommuteForm {
  final TextEditingController textFieldController1 = TextEditingController();
  final TextEditingController textFieldController2 = TextEditingController();
  final TextEditingController textFieldController3 = TextEditingController();
}

void handleSkip()
{
  print("Skipped");
}

void handleNext()
{
  print("Next");
}