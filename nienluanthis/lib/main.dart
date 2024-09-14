import 'package:flutter/material.dart';
import 'package:nienluanthis/sqlite/databaseuser.dart';
import 'package:nienluanthis/sqlite/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart'; // Thay thế bằng màn hình chính của bạn
import 'login_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
  User? user; // Khai báo biến user


  if (isLoggedIn) {
    // Lấy thông tin người dùng từ cơ sở dữ liệu nếu đã đăng nhập
    final dbHelper = Databaseuser();
    // Thay đổi username và password cho phù hợp với cách bạn lưu trữ người dùng
    user = await dbHelper.getUserByUsernameAndPassword('username', 'password');
  }

  runApp(MyApp(isLoggedIn: isLoggedIn, user: user));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final User? user;

  MyApp({required this.isLoggedIn, this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng Đăng nhập',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: isLoggedIn ? HomeScreen(user: user!) : ManHinhDangNhap(),
    );
  }
}

