import 'package:intl/intl.dart';

List<String> segmentTime(String expectedDepartureTime, int segments) {
  // Parse the expected departure time
  final DateFormat inputFormat = DateFormat('hh:mm a');
  final DateTime departureDateTime = inputFormat.parse(expectedDepartureTime);

  // Calculate the duration between each segment
  final Duration segmentDuration = Duration(minutes: (60 ~/ segments));

  // Initialize the segmented time array
  List<String> segmentedTimeArray = [];

  // Start with the departure time
  DateTime currentTime = DateTime(departureDateTime.year, departureDateTime.month, departureDateTime.day,
      departureDateTime.hour, departureDateTime.minute);

  // Add segments before the expected departure time
  for (int i = 0; i <= segments; i++) {
    segmentedTimeArray.add(DateFormat('hh:mm a').format(currentTime));
    currentTime = currentTime.subtract(segmentDuration);
  }

  // Reverse the list to get it in ascending order
  segmentedTimeArray = segmentedTimeArray.reversed.toList();

  return segmentedTimeArray;
}

void main() {
  // Input parameters
  String expectedDepartureTime = '1:30 PM';
  int segments = 6;

  // Segment the time
  List<String> segmentedTimeArray = segmentTime(expectedDepartureTime, segments);

  // Print the segmented time array
  print('Segmented Time Array:');
  print(segmentedTimeArray);
}
