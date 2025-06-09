import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class BatteryGraphs extends StatefulWidget {
  const BatteryGraphs({Key? key}) : super(key: key);

  @override
  State<BatteryGraphs> createState() => _BatteryGraphsState();
}

class _BatteryGraphsState extends State<BatteryGraphs> {
  final databaseRef = FirebaseDatabase.instance.ref('sensor');
  List<FlSpot> powerSpots = [];
  List<FlSpot> temperatureSpots = [];
  List<FlSpot> socSpots = [];

  final double powerThreshold = 5000.0;
  final double temperatureThreshold = 50.0;
  final double socThreshold = 80.0;

  @override
  void initState() {
    super.initState();
    _loadGraphData();
  }

  Future<void> _loadGraphData() async {
    final snapshot = await databaseRef.limitToLast(7).get();
    final List<FlSpot> power = [];
    final List<FlSpot> temperature = [];
    final List<FlSpot> soc = [];

    if (snapshot.exists && snapshot.value != null) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      int i = 0;

      for (final entry in data.entries) {
        final item = entry.value as Map<dynamic, dynamic>;
        double? voltage = double.tryParse(item['voltage']?.toString() ?? '');
        double? current = double.tryParse(item['current']?.toString() ?? '');
        double? avgTemp = double.tryParse(item['avg_temp']?.toString() ?? '');
        double? socValue = double.tryParse(item['soc']?.toString() ?? '');

        if (voltage != null && current != null) {
          double powerValue = voltage * current;
          power.add(FlSpot(i.toDouble(), powerValue));
        }

        if (avgTemp != null) {
          temperature.add(FlSpot(i.toDouble(), avgTemp));
        }

        if (socValue != null) {
          soc.add(FlSpot(i.toDouble(), socValue));
        }

        i++;
      }
    }

    setState(() {
      powerSpots = power;
      temperatureSpots = temperature;
      socSpots = soc;
    });
  }

  LinearGradient _getGradient(String title) {
    if (title.contains("Temperature")) {
      return const LinearGradient(
        colors: [Colors.deepOrange, Colors.orangeAccent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (title.contains("State of Charge")) {
      return const LinearGradient(
        colors: [Colors.green, Colors.lightGreenAccent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return const LinearGradient(
        colors: [Color.fromARGB(255, 68, 168, 218), Color.fromARGB(255, 33, 79, 170)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }

  Widget _buildGraph(String title, List<FlSpot> data, double threshold) {
    final gradient = _getGradient(title);
    List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _loadGraphData,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 180,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: data.isEmpty
              ? const Center(child: Text("No data", style: TextStyle(color: Colors.white)))
              : LineChart(
                  LineChartData(
                    minY: 0, // 👑 Origin starts at 0 for Y-axis
                    maxX: data.length > 1 ? data.length.toDouble() - 1 : 6,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      verticalInterval: 1,
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Colors.white24,
                          strokeWidth: 1,
                          dashArray: [5, 5], // 💃 Dotted vertical lines
                        );
                      },
                      drawHorizontalLine: false,
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt().clamp(0, 6);
                            return SideTitleWidget(
                              
                              meta: meta,
                              child: Text(
                                weekdays[index],
                                style: const TextStyle(color: Colors.white38, fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: threshold / 2,
                          getTitlesWidget: (value, meta) => SideTitleWidget(
                            
                            meta: meta,
                            child: Text(
                              value.toInt().toString(),
                              style: const TextStyle(color: Colors.white38, fontSize: 10),
                            ),
                          ),
                        ),
                      ),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: data,
                        isCurved: true,
                        gradient: gradient,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              gradient.colors.first.withOpacity(0.4),
                              gradient.colors.last.withOpacity(0.0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        dotData: FlDotData(show: false),
                      ),
                      LineChartBarData(
                        spots: [
                          FlSpot(0, threshold),
                          FlSpot(data.length > 1 ? data.length.toDouble() - 1 : 0, threshold),
                        ],
                        isCurved: false,
                        color: Colors.redAccent,
                        barWidth: 1,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Battery Graphs (Last 7 days)'),
        backgroundColor: const Color(0xFF1F1B24),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildGraph('Power: Highest Value 4500W', powerSpots, powerThreshold),
            const SizedBox(height: 20),
            _buildGraph('Temperature: Safety Value below 50°C', temperatureSpots, temperatureThreshold),
            const SizedBox(height: 20),
            _buildGraph('State of Charge (SOC): Value between 20%-80%', socSpots, socThreshold),
          ],
        ),
      ),
    );
  }
}
