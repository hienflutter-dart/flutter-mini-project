import 'package:flutter/material.dart';
import 'package:nienluanthis/sqlite/databasebmi.dart';
import 'package:nienluanthis/sqlite/userdata.dart';
import 'bmi_chart.dart';

class BMIChartScreen extends StatefulWidget {
  final String username;

  BMIChartScreen({required this.username});

  @override
  _BMIChartScreenState createState() => _BMIChartScreenState();
}

class _BMIChartScreenState extends State<BMIChartScreen> {
  final DatabaseBmi _dbHelper = DatabaseBmi();
  List<UserData> _userDataList = [];

  @override
  void initState() {
    super.initState();
    _loadBMIData();
  }

  Future<void> _loadBMIData() async {
    List<Map<String, dynamic>> bmiData = await _dbHelper.getBMIData(widget.username);
    setState(() {
      _userDataList = bmiData.map((map) => UserData.fromMap(map)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biểu đồ BMI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BMIChart(userDataList: _userDataList),
      ),
    );
  }
}
