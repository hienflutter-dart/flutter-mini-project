import 'package:flutter/material.dart';
import 'package:nienluanthis/home.dart';
import 'package:nienluanthis/tk_screen.dart';
import 'package:nienluanthis/sqlite/databaseuser.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng Đăng nhập',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: ManHinhDangNhap(),
    );
  }
}

class ManHinhDangNhap extends StatefulWidget {
  @override
  _ManHinhDangNhapState createState() => _ManHinhDangNhapState();
}

class _ManHinhDangNhapState extends State<ManHinhDangNhap> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordError = false;

  Future<void> _saveLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
  }

  void _dangNhap() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Kiểm tra thông tin đầu vào
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin.')),
      );
      return;
    }

    // Tạo đối tượng DatabaseHelper và kiểm tra thông tin đăng nhập
    final dbHelper = Databaseuser();
    final user = await dbHelper.getUserByUsernameAndPassword(username, password);

    if (user == null) {
      setState(() {
        _isPasswordError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tên đăng nhập hoặc mật khẩu không chính xác.')),
      );
      return;
    } else {
      setState(() {
        _isPasswordError = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng nhập thành công!')),
      );
      await _saveLoginStatus();
      // Chuyển đến màn hình HomeScreen với đối tượng User
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(user: user), // Truyền đối tượng User vào HomeScreen
        ),
      );
    }
  }


  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 50.0),
              const SizedBox(height: 20.0),
              const Text(
                'Chào mừng',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32.0),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Tên đăng nhập',
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Mật khẩu',
                  prefixIcon: const Icon(Icons.lock),
                  errorText: _isPasswordError ? 'Mật khẩu không chính xác' : null,
                ),
                obscureText: true,
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _dangNhap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  textStyle: const TextStyle(fontSize: 18.0),
                ),
                child: const Text('Đăng nhập'),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManHinhTaoTaiKhoan()),
                  );
                },
                child: const Text(
                  'Tạo tài khoản',
                  style: TextStyle(color: Colors.lightBlue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

