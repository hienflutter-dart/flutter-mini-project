import 'package:flutter/material.dart';
import '../Checkdata/DataLogic_Login.dart';
import '../User/user.dart';
import 'signup.dart';
import '../Sqlite/Sqlite.dart';
import 'trangchu.dart';

String tg = '';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool show = true;
  bool isLoginTrue = false;
  final usrName = TextEditingController();
  final password = TextEditingController();
  final db = DatabaseHelper();

  // Hàm đăng nhập
  Future<void> login() async {
    Users? usrDetails = await db.getUser(usrName.text);
    var res = await db.authenticate(Users(usrName: usrName.text, password: password.text));
    if (res == true) {
      // Nếu đăng nhập thành công, chuyển đến trang chính (Trangchu)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Trangchu(isAuthenticated: true), // Truyền isAuthenticated = true
        ),
      );
    } else {
      // Nếu đăng nhập không thành công, hiển thị thông báo lỗi
      setState(() {
        isLoginTrue = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(
          child: Text(
            'LOGIN',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w200,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 250,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 30, 30),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.boy_rounded),
                ),
              ),
              const Text(
                'HELLO\nWELCOME BACK',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: usrName,
                decoration: InputDecoration(
                  hintStyle: const TextStyle(fontWeight: FontWeight.w400),
                  border: const OutlineInputBorder(),
                  labelText: 'Nhập vào tên nè!',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: <Widget>[
                  TextField(
                    obscureText: show,
                    controller: password,
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(fontWeight: FontWeight.w400),
                      border: const OutlineInputBorder(),
                      labelText: 'Mật khẩu',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          show = !show;
                        });
                      },
                      child: Text(show ? 'SHOW' : 'HIDE'),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  login(); // Gọi hàm đăng nhập khi nhấn nút "LOGIN"
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('LOGIN'),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        const Text('NEW USER,'),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => Signup()),
                              ),
                            );
                          },
                          child: const Text('SIGN UP'),
                        )
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('FORGOT PASSWORD'),
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              if (isLoginTrue) // Hiển thị thông báo lỗi nếu đăng nhập không thành công
                const Text(
                  "Mật khẩu hoặc tên đăng nhập không đúng.",
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}