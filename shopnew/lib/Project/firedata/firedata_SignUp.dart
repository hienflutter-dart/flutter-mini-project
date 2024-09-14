import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uid/uid.dart';

import 'firedata_SignUp.dart';


class firebase {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void SignUp(String name, String email, String phone, String password, Function thanhcong) {
    _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((user) {
          _createUser('1', name, phone, thanhcong);
          print(user);
        }).catchError((err) {});
  }

  _createUser(String userid, String name, String phone, Function thanhcong) {
    var user = {
      "name": name,
      "phone": phone
    };
    var ref = FirebaseDatabase.instance.ref().child("users"); // Replace .reference() with .ref()
    ref.child(userid).set(user).then((user) {
      thanhcong();
    }).catchError((err) {});
  }
}