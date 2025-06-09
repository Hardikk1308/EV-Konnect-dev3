import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int _selectedTabIndex = 0;
  List<Map<dynamic, dynamic>> batteryData = [];
  List<Map<dynamic, dynamic>> rideData = [];

  @override
  void initState() {
    super.initState();
    fetchBatteryData();
  }

  void fetchBatteryData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('sensor');
    ref.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        final List<Map<dynamic, dynamic>> allData = [];
        data.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            allData.add(value);
          }
        });
        setState(() {
          batteryData = allData
              .where((entry) => entry.containsKey('soc') && entry.containsKey('time'))
              .toList();
        });
      }
    });
  }

  Widget buildAreaChart() {
    final data = batteryData.length > 7
        ? batteryData.sublist(batteryData.length - 7)
        : batteryData;

    if (data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Battery usage',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFFDAD4), // Light pink
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Battery level since last full charge',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFD7B8B0),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 100,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: const Color(0xFFD7B8B0),
                    strokeWidth: 0.5,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: const TextStyle(
                            color: Color(0xFFD7B8B0),
                            fontSize: 14,
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= data.length) {
                          return const SizedBox.shrink();
                        }
                        final timestamp = data[index]['time'] ?? '';
                        final date = DateTime.tryParse(timestamp);
                        final label = (date != null)
                            ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1]
                            : 'Day';
                        return Text(
                          label,
                          style: const TextStyle(
                            color: Color(0xFFFFDAD4),
                            fontSize: 14,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(data.length, (i) {
                      final soc = double.tryParse(data[i]['soc']?.toString() ?? '0') ?? 0;
                      return FlSpot(i.toDouble(), soc);
                    }),
                    isCurved: true,
                    color: const Color(0xFFFFB4A9),
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFFFFB4A9).withOpacity(0.6),
                    ),
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPieChart() {
    // Placeholder: replace with actual pie chart logic if needed
    return const Center(
      child: Text(
        'Ride Stats Coming Soon',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C1B17), // Dark chocolate brown background
      appBar: AppBar(
        title: const Text(
          'Stats',
          style: TextStyle(color: Color(0xFFFFDAD4)),
        ),
        backgroundColor: const Color(0xFF2C1B17),
        iconTheme: const IconThemeData(color: Color(0xFFFFDAD4)),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF3C2A23),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(12),
            child: Row(
              children: [
                buildTabButton('Battery', 0),
                buildTabButton('Ride', 1),
              ],
            ),
          ),
          Expanded(
            child: _selectedTabIndex == 0 ? buildAreaChart() : buildPieChart(),
          ),
        ],
      ),
    );
  }

  Widget buildTabButton(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFB4A9) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? const Color(0xFF2C1B17) : const Color(0xFFFFDAD4),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
