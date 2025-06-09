import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BatteryChart extends StatelessWidget {
  final double value;
  const BatteryChart({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.center,
        maxY: 100,
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: value,
                color: Colors.green,
                width: 40,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
