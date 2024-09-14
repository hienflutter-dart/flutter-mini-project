import 'dart:async';
import '../Logic/login_lg.dart';

class LoginBloc{
  bool show = true;

  StreamController _NameUserController = new StreamController();
  StreamController _PasswordController = new StreamController();

  Stream get Name => _NameUserController.stream;
  Stream get Password => _PasswordController.stream;

  bool CheckLoginBloc(String Name, String Password){
    if(!CheckLogin.CheckNameUser(Name)){
      _NameUserController.sink.addError('Username phải có trên 8 ký tự');
      return false;
    }
    _NameUserController.sink.add('ok');
    if(!CheckLogin.CheckPwUser(Password)){
      _PasswordController.sink.addError('PassWord phải có trên 8 ký tự');
      return false;
    }
    _PasswordController.sink.add('ok');
    return true;
  }
}

class SignBloc{

  StreamController _NameUserlgController = new StreamController();
  StreamController _EmailController = new StreamController();
  StreamController _PasswordController = new StreamController();
  StreamController _PhoneController = new StreamController();
  StreamController _PasswordCheckController = new StreamController();

  Stream get Namelg => _NameUserlgController.stream;
  Stream get Email => _EmailController.stream;
  Stream get Phone => _PhoneController.stream;
  Stream get Password => _PasswordController.stream;
  Stream get Password2 => _PasswordCheckController.stream;


  bool CheckLoginBloc(String Name, String Email,  String Phone, String Password,String Password2){
    if(!CheckSignUp.CheckNameUser(Name)){
      _NameUserlgController.sink.addError('Username phải có trên 6 ký tự');
      return false;
    }
    _NameUserlgController.sink.add('ok');
    if(!CheckSignUp.CheckEmail(Email)){
      _EmailController.sink.addError('Email không hợp lệ');
      return false;
    }
    _EmailController.sink.add('ok');
    if(!CheckSignUp.CheckPhone(Phone)){
      _PhoneController.sink.addError('Số điện thoại không hợp lệ');
      return false;
    }
    _PhoneController.sink.add('ok');
    if(!CheckSignUp.CheckPwUser(Password)){
      _PasswordController.sink.addError('PassWord phải có trên 8 ký tự');
      return false;
    }
    _PasswordController.sink.add('ok');
    if(!CheckSignUp.CheckPw2(Password2, Password)){
      _PasswordCheckController.sink.addError('Mật khẩu không chính xác');
      return false;
    }
    _PasswordCheckController.sink.add('ok');
    return true;
  }

  void SignUp(String name, String email, String phone, String password, Function thanhcong){
    SignUp(name, email, phone, password, thanhcong);
  }
}