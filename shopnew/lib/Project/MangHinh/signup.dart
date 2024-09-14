import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shopnew/Project/MangHinh/trangchu.dart';
import '../Sqlite/Sqlite.dart';
import '../User/user.dart';
import 'login.dart';
import 'textfield.dart';


class Signup extends StatefulWidget{
  const Signup({Key? key});

  @override
  State<Signup> createState() => _MyAppState();
}


class _MyAppState extends  State<Signup>{
  bool show = true;


  final fullName = TextEditingController();
  final email = TextEditingController();
  final usrName = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final db = DatabaseHelper();
  signUp()async{
    var res = await db.createUser(Users(fullName: fullName.text,email: email.text,usrName: usrName.text, password: password.text));
    if(res>0){
      if(!mounted)return;
      Navigator.push(context, MaterialPageRoute(builder: (context)=>  LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Center(
            child: Text('SIGN UP',style:TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w300,
              color: Colors.white
            )
          ),
        )
      ),
      body: Container(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InputField(hint: "Full name", icon: Icons.person, controller: fullName),
              InputField(hint: "Email", icon: Icons.email, controller: email),
              InputField(hint: "Username", icon: Icons.account_circle, controller: usrName),
              InputField(hint: "Password", icon: Icons.lock, controller: password,passwordInvisible: true),
              ElevatedButton(
                onPressed: () {
                  signUp();
                },
                style:  TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('SIGN UP'),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
    );
  }
  void Thongbao(String x) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Cảnh báo'),
            content: Text(x),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close')),
            ],
          );
        });
  }
}

