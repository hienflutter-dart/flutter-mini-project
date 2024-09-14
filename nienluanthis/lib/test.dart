import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _alarmMessageController = TextEditingController();

  TimeOfDay _time = TimeOfDay.now();
  List<Map<String, dynamic>> _alarms = [];
  Timer? _countdownTimer;
  bool _isAlarmPlaying = false;

  @override
  void initState() {
    super.initState();
    // Khởi tạo cấu hình thông báo trên Android
    var initializationSettingsAndroid =
    const AndroidInitializationSettings('app_icon');
    var initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Khởi tạo múi giờ
    tz.initializeTimeZones();
    _loadAlarmTimes(); // Tải các thời gian báo thức đã lưu
  }

  // Phát âm thanh báo thức
  Future<void> _playAlarmSound() async {
    if (!_isAlarmPlaying) {
      await _audioPlayer.play(AssetSource('sounds/alarm_sound.mp3'));
      setState(() {
        _isAlarmPlaying = true;
      });
    }
  }

  // Dừng phát âm thanh báo thức
  Future<void> _stopAlarmSound() async {
    await _audioPlayer.stop();
    setState(() {
      _isAlarmPlaying = false;
    });
  }

  // Hiển thị hộp thoại thông báo khi báo thức đã đến giờ
  Future<void> _showAlarmDialog(DateTime alarmTime, String? alarmMessage) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Báo Thức'),
          content: Text(alarmMessage ?? 'Đã đến giờ đánh thức!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Tắt'),
              onPressed: () {
                Navigator.of(context).pop();
                _stopAlarmSound();
              },
            ),
            TextButton(
              child: const Text('Báo lại sau 5 Phút'),
              onPressed: () {
                Navigator.of(context).pop();
                _rescheduleAlarm(alarmTime, alarmMessage, 5);
              },
            ),
          ],
        );
      },
    );
  }

  // Đặt lại báo thức để báo lại sau một khoảng thời gian (tính bằng phút)
  Future<void> _rescheduleAlarm(DateTime alarmTime, String? alarmMessage, int minutes) async {
    final newAlarmDateTime = alarmTime.add(Duration(minutes: minutes));
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        var remaining = newAlarmDateTime.difference(DateTime.now());
        if (remaining.inSeconds <= 0) {
          timer.cancel();
          _playAlarmSound();
          _showAlarmDialog(newAlarmDateTime, alarmMessage);
        }
      });
    });
    _updateAlarmTimes(newAlarmDateTime, alarmMessage);
  }

  // Đặt báo thức cho thời gian đã lên lịch
  Future<void> _scheduleAlarm(DateTime scheduledTime, String? alarmMessage) async {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        var remaining = scheduledTime.difference(DateTime.now());
        if (remaining.inSeconds <= 0) {
          timer.cancel();
          _playAlarmSound();
          _showAlarmDialog(scheduledTime, alarmMessage);
        }
      });
    });
    _updateAlarmTimes(scheduledTime, alarmMessage);
  }

  // Cập nhật thời gian và tin nhắn báo thức vào SharedPreferences
  Future<void> _updateAlarmTimes(DateTime newAlarmTime, String? alarmMessage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedTimes = prefs.getStringList('alarmTimes');
    List<String>? storedMessages = prefs.getStringList('alarmMessages');

    if (storedTimes == null) {
      storedTimes = [];
    }
    if (storedMessages == null) {
      storedMessages = [];
    }

    storedTimes.add(newAlarmTime.toString());
    storedMessages.add(alarmMessage ?? '');

    await prefs.setStringList('alarmTimes', storedTimes);
    await prefs.setStringList('alarmMessages', storedMessages);

    _loadAlarmTimes();
  }

  // Xóa báo thức đã lưu
  Future<void> _removeAlarm(DateTime alarmTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedTimes = prefs.getStringList('alarmTimes');
    List<String>? storedMessages = prefs.getStringList('alarmMessages');

    if (storedTimes != null && storedMessages != null) {
      int index = storedTimes.indexOf(alarmTime.toString());
      if (index != -1) {
        storedTimes.removeAt(index);
        storedMessages.removeAt(index);
      }
      await prefs.setStringList('alarmTimes', storedTimes);
      await prefs.setStringList('alarmMessages', storedMessages);
      _loadAlarmTimes();
    }
  }

  // Tải các thời gian báo thức từ SharedPreferences
  Future<void> _loadAlarmTimes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedTimes = prefs.getStringList('alarmTimes');
    List<String>? storedMessages = prefs.getStringList('alarmMessages');

    if (storedTimes != null && storedMessages != null) {
      setState(() {
        _alarms = List.generate(storedTimes.length, (index) {
          return {
            'time': DateTime.parse(storedTimes[index]),
            'message': storedMessages[index],
          };
        });
      });
    }
  }

  // Hiển thị hộp thoại chọn thời gian và nhập tin nhắn báo thức
  Future<void> _selectTimeAndSetAlarm() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null) {
      setState(() {
        _time = picked;
      });

      final now = DateTime.now();
      DateTime alarmDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        _time.hour,
        _time.minute,
      );

      if (alarmDateTime.isBefore(now)) {
        alarmDateTime = alarmDateTime.add(const Duration(days: 1));
      }

      await _showMessageInputDialog(alarmDateTime);
    }
  }

  // Hiển thị hộp thoại nhập tin nhắn cho báo thức
  Future<void> _showMessageInputDialog(DateTime alarmDateTime) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nhập Tin Nhắn Báo Thức'),
          content: TextField(
            controller: _alarmMessageController,
            decoration: const InputDecoration(hintText: 'Nhập tin nhắn của bạn'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
                _alarmMessageController.clear();
              },
            ),
            TextButton(
              child: const Text('Đặt Báo Thức'),
              onPressed: () {
                String? message = _alarmMessageController.text.isEmpty ? null : _alarmMessageController.text;
                _scheduleAlarm(alarmDateTime, message);
                Navigator.of(context).pop();
                _alarmMessageController.clear();
              },
            ),
          ],
        );
      },
    );
  }

  // Định dạng thời gian đếm ngược thành chuỗi
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đồng Hồ Báo Thức'),
        backgroundColor: Colors.blue, // Đổi màu AppBar thành xanh dương
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0), // Khoảng cách từ thanh AppBar
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (_alarms.isNotEmpty)
                  ..._alarms.map((alarm) {
                    final alarmTime = alarm['time'] as DateTime;
                    final alarmMessage = alarm['message'] as String?;
                    final now = DateTime.now();
                    final remainingTime = alarmTime.difference(now);
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.9, // Kích thước như cũ
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0), // Bo góc nhiều hơn
                        border: Border.all(color: Colors.grey, width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 4), // Đổ bóng
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${alarmTime.hour.toString().padLeft(2, '0')}:${alarmTime.minute.toString().padLeft(2, '0')}',
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), // Kích thước chữ nhỏ hơn
                                ),
                                const SizedBox(height: 4.0), // Giảm khoảng cách
                                Text(
                                  'Đếm ngược: ${remainingTime.isNegative ? 'Đã qua' : _formatDuration(remainingTime)}',
                                  style: const TextStyle(fontSize: 16, color: Colors.black54), // Kích thước chữ nhỏ hơn
                                ),
                                if (alarmMessage != null && alarmMessage.isNotEmpty)
                                  Text(
                                    'Tin nhắn: $alarmMessage',
                                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                                  ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.lightBlue,
                            onPressed: () {
                              _removeAlarm(alarmTime);
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectTimeAndSetAlarm,
        child: const Icon(Icons.access_time),
        tooltip: 'Chọn Thời Gian và Đặt Báo Thức',
      ),
    );
  }
}
