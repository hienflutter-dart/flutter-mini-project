import 'package:nienluanthis/sqlite/databasebmi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nienluanthis/sqlite/databaseuser.dart';
import 'package:nienluanthis/sqlite/user.dart';
import 'login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng Tạo Tài Khoản',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: ManHinhTaoTaiKhoan(),
    );
  }
}

class ManHinhTaoTaiKhoan extends StatefulWidget {
  @override
  _ManHinhTaoTaiKhoanState createState() => _ManHinhTaoTaiKhoanState();
}

class _ManHinhTaoTaiKhoanState extends State<ManHinhTaoTaiKhoan> {
  String _gioiTinh = 'Nam';
  DateTime? _ngaySinh;
  final _dateFormat = DateFormat('dd/MM/yyyy');

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final TextEditingController _tenNguoiDungController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _canNangController = TextEditingController();
  final TextEditingController _chieuCaoController = TextEditingController();
  final TextEditingController _matKhauController = TextEditingController();
  final TextEditingController _xacNhanMatKhauController = TextEditingController();

  void _chonNgaySinh(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _ngaySinh) {
      setState(() {
        _ngaySinh = picked;
      });
    }
  }

  int _tinhTuoi(DateTime? ngaySinh) {
    if (ngaySinh == null) return 0;
    final now = DateTime.now();
    int tuoi = now.year - ngaySinh.year;
    if (now.month < ngaySinh.month || (now.month == ngaySinh.month && now.day < ngaySinh.day)) {
      tuoi--;
    }
    return tuoi;
  }

  bool _kiemTraCanNangChieuCaoHopLe(int tuoi, double canNang, double chieuCao) {
    if (tuoi >= 2 && tuoi <= 5) {
      return canNang >= 13 && canNang <= 18 && chieuCao >= 90 && chieuCao <= 110;
    } else if (tuoi >= 6 && tuoi <= 10) {
      return canNang >= 18 && canNang <= 25 && chieuCao >= 110 && chieuCao <= 130;
    } else if (tuoi >= 11 && tuoi <= 15) {
      return canNang >= 35 && canNang <= 50 && chieuCao >= 130 && chieuCao <= 160;
    } else if (tuoi >= 16 && tuoi <= 20) {
      return canNang >= 50 && canNang <= 70 && chieuCao >= 160 && chieuCao <= 180;
    } else if (tuoi >= 21 && tuoi <= 30) {
      return canNang >= 55 && canNang <= 80 && chieuCao >= 165 && chieuCao <= 185;
    } else if (tuoi >= 31 && tuoi <= 40) {
      return canNang >= 60 && canNang <= 85 && chieuCao >= 165 && chieuCao <= 185;
    } else {
      return canNang >= 60 && canNang <= 90 && chieuCao >= 160 && chieuCao <= 180;
    }
  }
  String _phanLoaiBMI(double bmi) {
    if (bmi < 18.5) {
      return 'Thiếu cân';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return 'Bình thường';
    } else if (bmi >= 25 && bmi < 29.9) {
      return 'Thừa cân';
    } else {
      return 'Béo phì';
    }
  }

  IconData _chonBmiIcon(double bmi) {
    if (bmi < 18.5) {
      return Icons.sentiment_dissatisfied; // Thiếu cân
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return Icons.sentiment_satisfied; // Bình thường
    } else if (bmi >= 25 && bmi < 29.9) {
      return Icons.sentiment_neutral; // Thừa cân
    } else {
      return Icons.sentiment_very_dissatisfied; // Béo phì
    }
  }

  void _showBMIResult(BuildContext context, double canNang, double chieuCao) {
    final bmi = canNang / ((chieuCao / 100) * (chieuCao / 100));
    final bmiStatus = _phanLoaiBMI(bmi);
    final bmiIcon = _chonBmiIcon(bmi);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Kết quả đánh giá BMI'),
          content: Row(
            children: [
              Icon(bmiIcon, size: 40),
              const SizedBox(width: 16),
              Flexible(child: Text('Chỉ số BMI của bạn là ${bmi.toStringAsFixed(2)} ($bmiStatus)')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ManHinhDangNhap()),
                );
              },
              child: const Text('Đăng nhập'),
            ),
          ],
        );
      },
    );
  }




  void _taoTaiKhoan() async {
    final canNang = double.tryParse(_canNangController.text);
    final chieuCao = double.tryParse(_chieuCaoController.text);
    final tuoi = _tinhTuoi(_ngaySinh);

    if (canNang == null || chieuCao == null || tuoi == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ và chính xác thông tin.')),
      );
      return;
    }

    if (tuoi < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ứng dụng không hỗ trợ trẻ dưới 2 tuổi.')),
      );
      return;
    }

    if (!_kiemTraCanNangChieuCaoHopLe(tuoi, canNang, chieuCao)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cân nặng hoặc chiều cao không hợp lệ.')),
      );
      return;
    }

    if (_matKhauController.text != _xacNhanMatKhauController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu và xác nhận mật khẩu không khớp.')),
      );
      return;
    }

    try {
      final newUser = User(
        username: _tenNguoiDungController.text,
        email: _emailController.text,
        birthDate: _ngaySinh!,
        gender: _gioiTinh,
        weight: canNang,
        height: chieuCao,
        password: _matKhauController.text,
      );

      final userDbHelper = Databaseuser();

      // Chèn thông tin người dùng vào cơ sở dữ liệu
      final userId = await userDbHelper.insertUser(newUser);

      if (userId > 0) {
        // Chèn thông tin BMI vào bảng BMI
        final bmiDbHelper = DatabaseBmi();
        await bmiDbHelper.insertBMIData(
          _tenNguoiDungController.text,
          canNang,
          chieuCao,
        );

        // Lấy thông tin BMI từ cơ sở dữ liệu
        final bmiData = await bmiDbHelper.getLastEntry(_tenNguoiDungController.text);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tạo tài khoản thành công.')),
        );

        // Hiển thị kết quả đánh giá BMI cùng với thông tin đã lưu
        if (bmiData != null) {
          final bmi = canNang / ((chieuCao / 100) * (chieuCao / 100));
          final bmiStatus = _phanLoaiBMI(bmi);
          final bmiIcon = _chonBmiIcon(bmi);

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Kết quả đánh giá BMI'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(bmiIcon, size: 40),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Text('Chỉ số BMI của bạn là ${bmi.toStringAsFixed(2)} ($bmiStatus)'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Thông tin đã lưu vào bảng BMI:'),
                    Text('Cân nặng: ${bmiData['weight']} kg'),
                    Text('Chiều cao: ${bmiData['height']} cm'),
                    Text('Ngày: ${bmiData['date']}'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ManHinhDangNhap()),
                      );
                    },
                    child: const Text('Đăng nhập'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã xảy ra lỗi khi tạo tài khoản.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi: $e')),
      );
    }
  }

  @override
  void dispose() {
    _tenNguoiDungController.dispose();
    _emailController.dispose();
    _canNangController.dispose();
    _chieuCaoController.dispose();
    _matKhauController.dispose();
    _xacNhanMatKhauController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo Tài Khoản'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _tenNguoiDungController,
              decoration: const InputDecoration(
                labelText: 'Tên người dùng',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () => _chonNgaySinh(context),
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: _ngaySinh == null
                        ? 'Ngày tháng năm sinh'
                        : 'Ngày sinh: ${_dateFormat.format(_ngaySinh!)}',
                    border: const OutlineInputBorder(),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _canNangController,
              decoration: const InputDecoration(
                labelText: 'Cân nặng (kg)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _chieuCaoController,
              decoration: const InputDecoration(
                labelText: 'Chiều cao (cm)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                const Text('Giới tính:'),
                const SizedBox(width: 16.0),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Nam'),
                    value: 'Nam',
                    groupValue: _gioiTinh,
                    onChanged: (value) {
                      setState(() {
                        _gioiTinh = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Nữ'),
                    value: 'Nữ',
                    groupValue: _gioiTinh,
                    onChanged: (value) {
                      setState(() {
                        _gioiTinh = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _matKhauController,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_isPasswordVisible,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _xacNhanMatKhauController,
              decoration: InputDecoration(
                labelText: 'Xác nhận mật khẩu',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_isConfirmPasswordVisible,
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _taoTaiKhoan,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: const TextStyle(fontSize: 18.0),
              ),
              child: const Text('Tạo tài khoản'),
            ),
          ],
        ),
      ),
    );
  }
}