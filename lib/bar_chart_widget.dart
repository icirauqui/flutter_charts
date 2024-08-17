import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomBarChart extends StatelessWidget {
  final String title;
  final List<double> barValues;
  final List<String> barNames;

  const CustomBarChart(
      {super.key,
      required this.title,
      required this.barValues,
      required this.barNames});

  @override
  Widget build(BuildContext context) {
    // Find the maximum value
    final maxValue = barValues.reduce((a, b) => a > b ? a : b);
    final adjustedMaxY = maxValue > 0 ? maxValue : 5;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24, // Adjust the size as needed
              fontWeight: FontWeight.bold, // Optional: to make the title bold
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 48.0, left: 16.0),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: adjustedMaxY + (adjustedMaxY * 0.2), //maxValue + 5,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String weekDay = barNames[groupIndex];
                      return BarTooltipItem(
                        '$weekDay\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: rod.toY.toString(),
                            style: const TextStyle(
                              color: Colors.yellow,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  touchCallback: (FlTouchEvent event, barTouchResponse) {},
                  handleBuiltInTouches: true,
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        if (value.toInt() < barNames.length) {
                          return Text(barNames[value.toInt()]);
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      interval: (adjustedMaxY / 1).roundToDouble(),
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString());
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      interval: (adjustedMaxY / 1).roundToDouble(),
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString());
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                barGroups: List.generate(barValues.length, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        borderRadius: BorderRadius.circular(4),
                        toY: barValues[index],
                        color: barValues[index] == maxValue
                            ? Colors.orange
                            : Colors.black,
                        width: 25,
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
