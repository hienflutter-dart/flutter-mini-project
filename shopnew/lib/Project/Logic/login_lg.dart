
class CheckLogin{
  static bool CheckNameUser(String Name){
    return Name.length > 6;
  }

  static bool CheckPwUser(String Password){
    return Password.length >= 8;
  }
}

class CheckSignUp{
  static bool CheckNameUser(String Name){
    return Name.length > 6;
  }

  static bool CheckEmail(String Email){
    return Email.length >=10 && Email.contains('@');
  }

  static bool CheckPhone(String Phone){
    return Phone.length == 10;
  }

  static bool CheckPwUser(String Password){
    return Password.length >= 8;
  }

  static bool CheckPw2(String pw1, String pw2){
    return pw1 == pw2;
  }
}