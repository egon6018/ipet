import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ipet/login_home.dart';

class AuthController {
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  var login_userEmail; // 로그인 한 다음, 홈화면 drawer바에서 이메일을 나타내기 위해

  Future saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  // 로그아웃 함수
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token'); // 토큰 삭제
  }

  Future loginUser(BuildContext context) async {
    const url = 'https://ipet-server.run.goorm.site/api/v1/members/login';

    var response = await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": userEmailController.text,
          "password": userPasswordController.text,
        }));

    if (response.statusCode == 200) {
      // 로그인 성공하면
      var loginArr = json.decode(response.body);

      // save this token in shared preferences and make user logged
      saveToken(loginArr['data']['tokenInfo']['accessToken'] ?? '');
      saveEmail(loginArr['data']['email'] ?? '');

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const LoginHome()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          '로그인되지 않았습니다',
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue,
      ));
      print("Login Error");
      print(response.body);
    }
  }

  Future SignUp(BuildContext context) async {
    const url = 'https://ipet-server.run.goorm.site/api/v1/members/join';

    var response = await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": userEmailController.text,
          "password": userPasswordController.text,
        }));

    if (response.statusCode == 200) {
      // 회원가입 성공하면

      final userInfo = json.decode(response.body);

      print('회원가입 성공: $userInfo');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          '회원가입이 되었습니다! 다시 로그인 해주세요',
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue,
      ));

      Navigator.pop(context);

      // 사용자 정보 추출
      //final UserEmail = userInfo['email'];

      //Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          '회원가입이 되지 않았습니다',
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue,
      ));
      print("SignUp Error");
      print(response.body);
    }
  }
}
