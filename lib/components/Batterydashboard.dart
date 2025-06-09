import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class BatteryDashboard extends StatefulWidget {
  const BatteryDashboard({super.key});

  @override
  State<BatteryDashboard> createState() => _BatteryDashboardState();
}

class _BatteryDashboardState extends State<BatteryDashboard> {
  final databaseRef = FirebaseDatabase.instance.ref('sensor');

  Map<String, List<FlSpot>> metricsData = {
    'Battery Level': [],
    'Voltage': [],
    'Temperature': [],
    'Current': [],
  };

  bool isLoading = true;
  Map<String, dynamic> latestData = {};

  @override
  void initState() {
    super.initState();
    fetchData();
    databaseRef.orderByKey().limitToLast(1).onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null && data.isNotEmpty) {
        final latest = Map<String, dynamic>.from(data.values.first);
        setState(() {
          latestData = latest;
        });
      }
    });
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    final snapshot = await databaseRef.orderByKey().limitToLast(100).once();
    final data = snapshot.snapshot.value as Map?;

    if (data != null) {
      metricsData = {
        'Battery Level': [],
        'Voltage': [],
        'Temperature': [],
        'Current': [],
      };

      final entries =
          data.entries.map((e) => Map<String, dynamic>.from(e.value)).toList();

      entries.sort(
        (a, b) => (a['time']?.toString() ?? '').compareTo(
          b['time']?.toString() ?? '',
        ),
      );

      double index = 0;
      for (final entry in entries) {
        final soc = double.tryParse(entry['soc']?.toString() ?? '0') ?? 0;
        final voltage =
            double.tryParse(entry['voltage']?.toString() ?? '0') ?? 0;
        final temp = double.tryParse(entry['avg_temp']?.toString() ?? '0') ?? 0;
        final current =
            double.tryParse(entry['current']?.toString() ?? '0') ?? 0;

        metricsData['Battery Level']!.add(FlSpot(index, soc));
        metricsData['Voltage']!.add(FlSpot(index, voltage));
        metricsData['Temperature']!.add(FlSpot(index, temp));
        metricsData['Current']!.add(FlSpot(index, current));

        if (index == entries.length - 1) {
          latestData = entry;
        }
        index++;
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  double getMinY(List<FlSpot> spots) =>
      spots.isEmpty ? 0 : spots.map((e) => e.y).reduce(min);

  double getMaxY(List<FlSpot> spots) =>
      spots.isEmpty ? 100 : spots.map((e) => e.y).reduce(max);

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
    if (voltage >= 55 && voltage <= 70) return const Color(0xff2cff05);
    return Colors.red;
  }

  Widget buildMiniGraph(String metric, Color color) {
    final spots = metricsData[metric] ?? [];
    if (spots.isEmpty) return const Center(child: Text('No data'));

    double? thresholdValue;
    if (metric == 'Temperature') thresholdValue = 50;
    if (metric == 'Voltage') thresholdValue = 70;
    if (metric == 'Battery Level') thresholdValue = 25;
    if (metric == 'Current') thresholdValue = 10;

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        minX: 0,
        maxX: spots.length - 1.0,
        minY: getMinY(spots) * 0.9,
        maxY: getMaxY(spots) * 1.1,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: color,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: color.withOpacity(0.2),
            ),
          ),
        ],
        extraLinesData: ExtraLinesData(
          horizontalLines:
              thresholdValue != null
                  ? [
                    HorizontalLine(
                      y: thresholdValue,
                      color: Colors.red,
                      strokeWidth: 1.5,
                      dashArray: [5, 5],
                      label: HorizontalLineLabel(
                        show: true,
                        alignment: Alignment.centerRight,
                        style: const TextStyle(color: Colors.red, fontSize: 10),
                        labelResolver: (line) => 'Threshold',
                      ),
                    ),
                  ]
                  : [],
        ),
      ),
    );
  }

  Widget buildDashboardCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
    required List<FlSpot> graphData,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(child: buildMiniGraph(title, color)),
        ],
      ),
    );
  }

  Widget buildBatteryGauge() {
    final soc = double.tryParse(latestData['soc']?.toString() ?? '0') ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Current Battery Status',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            width: 150,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    centerSpaceRadius: 50,
                    sections: [
                      PieChartSectionData(
                        value: soc,
                        color: getBatteryColor(soc),
                        radius: 25,
                        title: '',
                      ),
                      PieChartSectionData(
                        value: 100 - soc,
                        color: Colors.grey[300]!,
                        radius: 20,
                        title: '',
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${soc.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Charge',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHistoryGraph() {
    final spots = metricsData['Battery Level'] ?? [];
    if (spots.isEmpty) return const Center(child: Text('No data available'));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Battery Level History',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineTouchData: const LineTouchData(enabled: false),
                minX: 0,
                maxX: spots.length - 1.0,
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: const Color(0xff2cff05),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xff2cff05).withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final soc = double.tryParse(latestData['soc']?.toString() ?? '0') ?? 0;
    final voltage =
        double.tryParse(latestData['voltage']?.toString() ?? '0') ?? 0;
    final temp =
        double.tryParse(latestData['avg_temp']?.toString() ?? '0') ?? 0;
    final current =
        double.tryParse(latestData['current']?.toString() ?? '0') ?? 0;

    return RefreshIndicator(
      onRefresh: () async {
        await fetchData();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Battery Dashboard',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(height: 180, child: buildBatteryGauge()),
              const SizedBox(height: 16),
              SizedBox(height: 220, child: buildHistoryGraph()),
              const SizedBox(height: 16),
              const Text(
                'Battery Metrics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 180,
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                  children: [
                    buildDashboardCard(
                      title: 'Voltage',
                      value: '${voltage.toStringAsFixed(1)}V',
                      color: getVoltageColor(voltage),
                      icon: Icons.flash_on,
                      graphData: metricsData['Voltage']!,
                    ),
                    buildDashboardCard(
                      title: 'Temperature',
                      value: '${temp.toStringAsFixed(1)}°C',
                      color: getTemperatureColor(temp),
                      icon: Icons.thermostat,
                      graphData: metricsData['Temperature']!,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 180,
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                  children: [
                    buildDashboardCard(
                      title: 'Current',
                      value: '${current.toStringAsFixed(2)}A',
                      color: Colors.blue,
                      icon: Icons.electric_bolt,
                      graphData: metricsData['Current']!,
                    ),
                    buildDashboardCard(
                      title: 'Battery Level',
                      value: '${soc.toStringAsFixed(1)}%',
                      color: getBatteryColor(soc),
                      icon: Icons.battery_std,
                      graphData: metricsData['Battery Level']!,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: fetchData,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
