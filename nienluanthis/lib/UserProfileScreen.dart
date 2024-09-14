import 'package:flutter/material.dart';
import 'package:nienluanthis/sqlite/databaseuser.dart';
import 'package:nienluanthis/sqlite/user.dart';
import 'login_screen.dart'; // Đảm bảo đường dẫn đúng
import 'package:intl/intl.dart'; // Đảm bảo bạn đã thêm gói intl vào pubspec.yaml
import 'thaydoitt.dart'; // Đảm bảo đường dẫn đúng

class UserProfileScreen extends StatefulWidget {
  final User user;

  UserProfileScreen({required this.user});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  User? _user;
  final Databaseuser _databaseHelper = Databaseuser();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = widget.user;
    setState(() {
      _user = user;
    });
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ManHinhDangNhap()), // Trang đăng nhập
    );
  }

  void _editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(user: _user!),
      ),
    ).then((updatedUser) {
      if (updatedUser != null) {
        setState(() {
          _user = updatedUser;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông Tin Người Dùng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editProfile, // Gọi hàm thay đổi thông tin người dùng
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildInfoRow(Icons.person, 'Tên người dùng', _user!.username),
            const SizedBox(height: 16.0),
            _buildInfoRow(Icons.email, 'Email', _user!.email),
            const SizedBox(height: 16.0),
            _buildInfoRow(Icons.calendar_today, 'Ngày sinh', _formatDate(_user!.birthDate)),
            const SizedBox(height: 16.0),
            _buildInfoRow(Icons.male, 'Giới tính', _user!.gender),
            const SizedBox(height: 16.0),
            _buildInfoRow(Icons.fitness_center, 'Cân nặng', '${_user!.weight} kg'),
            const SizedBox(height: 16.0),
            _buildInfoRow(Icons.height, 'Chiều cao', '${_user!.height} m'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 24.0, color: Colors.lightBlue),
        const SizedBox(width: 16.0),
        Expanded(
          child: Text(
            '$label: $value',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }
}
