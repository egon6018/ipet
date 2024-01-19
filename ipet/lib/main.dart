import "package:flutter/material.dart";
import "home.dart"; // 로그인 안했을때 홈화면
//import "login_home.dart"; // 로그인 했을때 홈화면

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Appbar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, 1, 145, 248),
            brightness: Brightness.light),
        useMaterial3: true,
      ),
      home: Home(),
    );
  }
}
