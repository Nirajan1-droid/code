import 'dart:math';

class LatLng {
  final double latitude;
  final double longitude;

  LatLng( this.latitude, this.longitude);
}

List<double> calculateDistances(List<LatLng> points) {
  List<double> distances = [];

  for (int i = 0; i < points.length - 1; i++) {
    double distance = _calculateDistance(points[i], points[i + 1]);
    distances.add(distance);
  }

  return distances;
}

double _calculateDistance(LatLng point1, LatLng point2) {
  const double earthRadius = 6371000; // Radius of the Earth in meters

  double lat1 = _degreesToRadians(point1.latitude);
  double lon1 = _degreesToRadians(point1.longitude);
  double lat2 = _degreesToRadians(point2.latitude);
  double lon2 = _degreesToRadians(point2.longitude);

  double dLat = lat2 - lat1;
  double dLon = lon2 - lon1;

  double a = pow(sin(dLat / 2), 2) +
      cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  double distance = earthRadius * c; // Distance in meters
  return distance;
}

double _degreesToRadians(double degrees) {
  return degrees * pi / 180;
}

void main() {
  List<LatLng> points = [
    LatLng(27.72085, 85.28648),
    LatLng(27.72086, 85.2863),
    LatLng(27.72068, 85.28641),
    LatLng(27.72051, 85.28647),
    LatLng(27.7201, 85.28652),
    LatLng(27.72002, 85.28655),
    LatLng(27.71997, 85.28659),
    LatLng(27.7198, 85.28678),
    LatLng(27.71961, 85.28693),
    LatLng(27.7194, 85.28649),
    LatLng(27.71901, 85.28569),
    LatLng(27.71892, 85.28549),
    LatLng(27.71852, 85.28466),
    LatLng(27.7184, 85.28444),
    LatLng(27.71815, 85.28406),
    LatLng(27.71808, 85.28398),
    LatLng(27.71786, 85.28384),
    LatLng(27.71771, 85.28379),
    LatLng(27.71608, 85.28357),
    LatLng(27.7147, 85.28341),
    LatLng(27.71292, 85.28321),
    LatLng(27.71004, 85.28286),
    LatLng(27.70976, 85.28283),
    LatLng(27.70765, 85.28257),
    LatLng(27.70693, 85.28248),
    LatLng(27.70655, 85.28242),
    LatLng(27.70443, 85.28219),
    LatLng(27.70367, 85.28208),
    LatLng(27.70216, 85.2819),
    LatLng(27.70158, 85.28185),
    LatLng(27.7004, 85.28169),
    LatLng(27.70029, 85.28167),
    LatLng(27.69968, 85.28159),
    LatLng(27.69891, 85.28149),
    LatLng(27.69864, 85.28148),
    LatLng(27.69857, 85.28152)
  ];

  List<double> distances = calculateDistances(points);
  print('Distances between points:');
  for (int i = 0; i < distances.length; i++) {
    print('Segment $i: ${distances[i].toStringAsFixed(2)} meters');
  }
}
