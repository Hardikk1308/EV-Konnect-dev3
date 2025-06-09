import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:kawach/components/Batterygraph.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final databaseRef = FirebaseDatabase.instance.ref('sensor');
  Map<String, dynamic> latestData = {};
  List<Map<String, dynamic>> lastFiveRides = [];

  @override
  void initState() {
    super.initState();

    databaseRef.orderByKey().limitToLast(1).onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null && data.isNotEmpty) {
        final latest = Map<String, dynamic>.from(data.values.first);
        setState(() {
          latestData = latest;
        });
      }
    });

    databaseRef.orderByKey().limitToLast(500).once().then((snapshot) async {
      final data = snapshot.snapshot.value as Map?;
      if (data != null) {
        final entries =
            data.entries
                .map((e) => Map<String, dynamic>.from(e.value))
                .toList();

        entries.sort((a, b) => (a['time'] ?? '').compareTo(b['time'] ?? ''));

        final List<Map<String, dynamic>> rides = [];
        Map<String, dynamic>? start;

        for (final entry in entries) {
          final current =
              double.tryParse(entry['current']?.toString() ?? '0') ?? 0;

          if (current > 0 && start == null) {
            start = entry;
          } else if (current == 0 && start != null) {
            final double rideDistance = calculateDistance(
              double.tryParse(start['latitude']?.toString() ?? '0') ?? 0,
              double.tryParse(start['longitude']?.toString() ?? '0') ?? 0,
              double.tryParse(entry['latitude']?.toString() ?? '0') ?? 0,
              double.tryParse(entry['longitude']?.toString() ?? '0') ?? 0,
            );

            final ride = {
              'startTime': start['time'],
              'endTime': entry['time'],
              'startLat': start['latitude'],
              'startLng': start['longitude'],
              'endLat': entry['latitude'],
              'endLng': entry['longitude'],
              'distance': rideDistance.toString(),
            };

            rides.add(ride);
            start = null;
          }
        }

        final List<Map<String, dynamic>> ridesWithPlaces = [];
        for (var ride in rides.reversed.take(5)) {
          final startPlace = await getPlaceName(
            ride['startLat'],
            ride['startLng'],
          );
          final endPlace = await getPlaceName(ride['endLat'], ride['endLng']);
          ride['startLocation'] = startPlace;
          ride['endLocation'] = endPlace;
          ridesWithPlaces.add(ride);
        }

        setState(() {
          lastFiveRides = ridesWithPlaces;
        });
      }
    });
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371e3; // Earth's radius in meters
    final phi1 = lat1 * (pi / 180);
    final phi2 = lat2 * (pi / 180);
    final deltaPhi = (lat2 - lat1) * (pi / 180);
    final deltaLambda = (lon2 - lon1) * (pi / 180);

    final a =
        sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distance = R * c;

    return distance / 1000; // in kilometers
  }

  Future<String> getPlaceName(String? latStr, String? lngStr) async {
    final lat = latStr ?? '';
    final lng = lngStr ?? '';
    if (lat.isEmpty || lng.isEmpty) return 'Unknown';

    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyBSUmzgvcFvNiUDusmdBPdOIk7kKREDrFA';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final address = json['results']?[0]?['formatted_address'];
        if (address != null && address is String && address.isNotEmpty) {
          return address;
        }
      }
    } catch (e) {
      debugPrint('Reverse geocode error: $e');
    }

    return '$lat, $lng';
  }

  String formatDistance(String? distanceStr) {
    final km = double.tryParse(distanceStr ?? '') ?? 0;
    if (km < 1.0) {
      final meters = (km * 1000).round();
      return '$meters m';
    } else {
      return '${km.toStringAsFixed(2)} km';
    }
  }

  Color getBatteryColor(double battery) {
    if (battery >= 50) return const Color(0xff2cff05);
    if (battery >= 25) return Colors.yellow;
    return Colors.red;
  }

  Color getTemperatureColor(double temp) {
    if (temp <= 40) return const Color(0xff2cff05);
    if (temp <= 50) return Colors.yellow;
    return Colors.red;
  }

  Color getVoltageColor(double voltage) {
    if (voltage >= 65 && voltage <= 80) return const Color(0xff2cff05);
    return Colors.red;
  }

  Widget buildCard({
    required String title,
    required String value,
    required String description,
    IconData? icon,
    Color color = Colors.grey,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon, color: Colors.black87, size: 32),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
           Positioned(
          top: -15,
          right: -15,
          child: IconButton(
            icon: const Icon(Icons.info_outline, size: 18,color: Colors.black,),
            tooltip: "Info",
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: Colors.white,
                  title: Text(title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(description,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text("Close",),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        ],
      ),
    );
  }

  Widget buildRideCard(Map<String, dynamic> ride) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Start: ${ride['startLocation']}",
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            "End: ${ride['endLocation']}",
            style: const TextStyle(color: Colors.black87, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            "Time: ${ride['startTime']} → ${ride['endTime']}",
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            "Distance: ${formatDistance(ride['distance'])}",
            style: const TextStyle(color: Colors.black45),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final current =
        double.tryParse(latestData['current']?.toString() ?? '0') ?? 0;
    final soc = double.tryParse(latestData['soc']?.toString() ?? '0') ?? 0;
    final voltage =
        double.tryParse(latestData['voltage']?.toString() ?? '0') ?? 0;
    final temp =
        double.tryParse(latestData['avg_temp']?.toString() ?? '0') ?? 0;
    final distance = latestData['distance']?.toString() ?? '--';
    final speed = latestData['speed']?.toString() ?? '--';
    final chargeCycle = latestData['cycle_count']?.toString() ?? '--';

    final screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 197, 220, 250),
                  Color.fromARGB(255, 186, 228, 253),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 5,
              // leading: IconButton(
              //   icon: const Icon(Icons.arrow_back, color: Colors.black54),
              //   onPressed: () => Navigator.pop(context),
              // ),
              title: const Text(
                'Statistics',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              bottom: const TabBar(
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  Tab(text: 'Battery'),
                  Tab(text: 'Ride'),
                  Tab(text: 'Graphs'),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: TabBarView(
            children: [
              // First tab - Battery Stats
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 5,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = screenWidth > 600 ? 6 : 4;
                    return StaggeredGrid.count(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 20,
                      children: [
                        StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 2,
                          child: buildCard(
                            title: "Battery Health",
                            value: "Good",
                            color: const Color(0xff2cff05),
                            icon: Icons.battery_charging_full, description: 'Indicates the overall health of the battery based on usage and condition.',
                          ),
                        ),
                        StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 1,
                          child: buildCard(
                            title: "Voltage",
                            value: "${voltage.toStringAsFixed(1)}V",
                            icon: Icons.flash_on,
                            color: getVoltageColor(voltage), description: 'Shows the real-time voltage of the battery pack.',
                          ),
                        ),
                        StaggeredGridTile.count(
                          crossAxisCellCount: 2,
                          mainAxisCellCount: 1,
                          child: buildCard(
                            title: "Battery Level",
                            value: "${soc.toStringAsFixed(1)}%",
                            icon: Icons.battery_std,
                            color: getBatteryColor(soc), description: 'Indicates the current state of charge of the battery pack. A higher percentage means more charge available.',
                          ),
                        ),
                        StaggeredGridTile.count(
                          crossAxisCellCount: 2,
                          mainAxisCellCount: 1,
                          child: buildCard(
                            title: "Temperature",
                            value: "${temp.toStringAsFixed(1)}°C",
                            icon: Icons.thermostat,
                            color: getTemperatureColor(temp), description: 'Indicates the average temperature of the battery pack. High temperatures can affect performance and lifespan.',
                          ),
                        ),
                        StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 1,
                          child: buildCard(
                            title: "Charging Cycles",
                            value: chargeCycle,
                            icon: Icons.electrical_services,
                            color: Colors.grey.shade600, description: 'Indicates the number of complete charge and discharge cycles the battery has gone through. More cycles can indicate wear and tear.',
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Second tab - Ride Info
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  buildCard(
                    title: "Total Distance",
                    value: "$distance km",
                    icon: Icons.route, description: 'Total distance traveled during the last ride.',
                  ),
                  const SizedBox(height: 20),
                  buildCard(
                    title: "Speed",
                    value: "$speed km/h",
                    icon: Icons.speed, description: 'The average speed during the last ride.',
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Last 5 Rides",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...lastFiveRides.map((ride) => buildRideCard(ride)).toList(),
                ],
              ),

              // Third tab - Graphs
              // You can choose either BatteryGraphs or BatteryDashboard implementation
              // BatteryGraphs gives separate graphs for each metric
              // BatteryDashboard gives a more comprehensive dashboard view

              // Option 1: Basic Battery Graphs
              const BatteryGraphs(),

              // Option 2: Dashboard style (uncomment to use)
              //const BatteryDashboard(),
            ],
          ),
        ),
      ),
    );
  }
}
