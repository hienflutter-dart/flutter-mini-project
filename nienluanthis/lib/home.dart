import 'package:flutter/material.dart';
import 'package:nienluanthis/sqlite/nhacnho.dart';
import 'package:nienluanthis/test.dart'; // Đảm bảo đường dẫn đúng đến AlarmPage
import 'package:nienluanthis/UserProfileScreen.dart'; // Đảm bảo đường dẫn đúng đến UserProfileScreen
import 'package:nienluanthis/sqlite/user.dart';
import 'bieudo.dart'; // Đảm bảo đường dẫn đúng đến BMIChartScreen

class HomeScreen extends StatefulWidget {
  final User user; // Thay đổi để nhận đối tượng User

  HomeScreen({required this.user}); // Sử dụng required để nhận đối tượng User

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late BMIManager _bmiManager;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _bmiManager = BMIManager(widget.user.username);
    _pages = [
      AlarmPage(), // Thay đổi với các widget bạn muốn
      UserProfileScreen(user: widget.user,), // Truyền đối tượng User vào UserProfileScreen
      BMIChartScreen(username: widget.user.username),
    ];

    // Kiểm tra và nhắc nhở nhập dữ liệu BMI
    _bmiManager.checkAndPromptForNewEntry(context);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'Alarm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart), // Thay đổi biểu tượng nếu cần
            label: 'BMI Chart', // Thay đổi tiêu đề nếu cần
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
