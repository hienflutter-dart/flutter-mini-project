import 'package:flutter/material.dart';
import 'databasebmi.dart';

class BMIManager {
  final String username;
  final DatabaseBmi _dbHelper = DatabaseBmi();

  BMIManager(this.username);

  Future<void> checkAndPromptForNewEntry(BuildContext context) async {
    Map<String, dynamic>? lastEntry = await _dbHelper.getLastEntry(username);

    if (lastEntry != null) {
      DateTime lastEntryDate = DateTime.parse(lastEntry['date']);
      if (DateTime.now().difference(lastEntryDate).inDays >= 7) {
        _promptForNewEntry(context);
      }
    } else {
      _promptForNewEntry(context);
    }
  }

  void _promptForNewEntry(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        double? weight;
        double? height;

        return AlertDialog(
          title: Text('Nhập cân nặng và chiều cao'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Cân nặng (kg)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  weight = double.tryParse(value);
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Chiều cao (cm)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  height = double.tryParse(value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (weight != null && height != null) {
                  await _dbHelper.insertBMIData(username, weight!, height!);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }
}
