import 'package:flutter/material.dart';
import 'package:nienluanthis/sqlite/user.dart';
import 'package:nienluanthis/sqlite/databaseuser.dart';
import 'home.dart'; // Đảm bảo đường dẫn đúng

class EditProfileScreen extends StatefulWidget {
  final User user;

  EditProfileScreen({required this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _genderController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  final Databaseuser _databaseHelper = Databaseuser();

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _usernameController.text = widget.user.username;
    _emailController.text = widget.user.email;
    _birthDateController.text = widget.user.birthDate.toLocal().toString().substring(0, 10);
    _genderController.text = widget.user.gender;
    _weightController.text = widget.user.weight.toString();
    _heightController.text = widget.user.height.toString();
  }

  void _saveChanges() async {
    try {
      final updatedUser = User(
        id: widget.user.id,
        username: _usernameController.text,
        email: _emailController.text,
        birthDate: DateTime.parse(_birthDateController.text),
        gender: _genderController.text,
        weight: double.parse(_weightController.text),
        height: double.parse(_heightController.text),
        password: '', // Không thay đổi mật khẩu
      );

      await _databaseHelper.updateUser(updatedUser);

      // Điều hướng đến trang chính sau khi lưu thay đổi
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(user: updatedUser)),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lưu thay đổi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh Sửa Thông Tin'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Tên người dùng'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _birthDateController,
                decoration: const InputDecoration(labelText: 'Ngày sinh (yyyy-MM-dd)'),
                keyboardType: TextInputType.datetime,
              ),
              TextField(
                controller: _genderController,
                decoration: const InputDecoration(labelText: 'Giới tính'),
              ),
              TextField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Cân nặng (kg)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: _heightController,
                decoration: const InputDecoration(labelText: 'Chiều cao (m)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Lưu thay đổi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
