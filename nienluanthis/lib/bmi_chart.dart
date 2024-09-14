import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nienluanthis/sqlite/userdata.dart';

class BMIChart extends StatelessWidget {
  final List<UserData> userDataList;

  BMIChart({required this.userDataList});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= userDataList.length) {
                  return const SizedBox.shrink();
                }
                final date = userDataList[index].date;
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    "${date.day}/${date.month}",
                    style: TextStyle(color: Colors.black, fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(value.toStringAsFixed(1), style: TextStyle(color: Colors.black, fontSize: 10));
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 0), // Thêm điểm bắt đầu tại (0,0)
              ...userDataList.asMap().entries.map((e) {
                final index = e.key + 1; // Bắt đầu từ 1 để bỏ qua điểm (0,0)
                final userData = e.value;
                final bmi = userData.bmi;
                return FlSpot(index.toDouble(), bmi);
              }).toList(),
            ],
            isCurved: true,
            barWidth: 2,
            color: Colors.blue,
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}
