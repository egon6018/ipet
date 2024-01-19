import "package:flutter/material.dart";
import "package:ipet/controllers/auth_controller.dart";

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AuthController authController = AuthController();

  bool isSignUpScreen = true;
  final _formkey = GlobalKey<FormState>();

  String userEmail = '';
  String userPassword = '';

  void _tryValidation() {
    // 변수명앞에 '_'를 붙이면 private변수라는 뜻
    final isValid = _formkey.currentState!.validate();

    if (isValid) {
      _formkey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext contextLogin) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0.0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            // 첫번째 position은 배경
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary),
                )),
            // 두번째 position은 text form field
            Positioned(
                top: 100,
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  // height: isSignUpScreen ? 300.0 : 240.0,
                  height: 240.0,
                  width: MediaQuery.of(context).size.width - 40,
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 5)
                      ]),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSignUpScreen = false;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    '로그인',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: !isSignUpScreen
                                            ? Colors.black
                                            : Colors.grey[400]),
                                  ),
                                  if (!isSignUpScreen)
                                    Container(
                                      margin: const EdgeInsets.only(top: 3),
                                      height: 2,
                                      width: 55,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSignUpScreen = true;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    '회원가입',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: isSignUpScreen
                                            ? Colors.black
                                            : Colors.grey[400]),
                                  ),
                                  if (isSignUpScreen)
                                    Container(
                                      margin: const EdgeInsets.only(top: 3),
                                      height: 2,
                                      width: 55,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )
                                ],
                              ),
                            )
                          ],
                        ),
                        if (isSignUpScreen) // 회원가입 text form field가 나오도록
                          Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            child: Form(
                                key: _formkey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      // email address 적는 칸
                                      keyboardType: TextInputType.emailAddress,
                                      controller:
                                          authController.userEmailController,
                                      key: const ValueKey(1),
                                      validator: (value) {
                                        // email address에 이메일형식(@)을 갖추지 않으면 안됨
                                        if (value!.isEmpty ||
                                            !value.contains('@')) {
                                          return 'Please enter a valid email address';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        userEmail = value!;
                                      },
                                      onChanged: (value) {
                                        userEmail = value;
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.email,
                                            color: Colors.grey[400],
                                          ),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(35.0)),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            // 클릭했을때도 border이 나오게
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(35.0)),
                                          ),
                                          hintText: 'Email Address',
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[400],
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(10.0)),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    TextFormField(
                                      // password 적는 칸
                                      obscureText: true,
                                      controller:
                                          authController.userPasswordController,
                                      key: const ValueKey(2),
                                      validator: (value) {
                                        // password를 최소 6글자이상으로 해달라
                                        if (value!.isEmpty ||
                                            value.length < 6) {
                                          return 'Password must be at least 6 characters long';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        userPassword = value!;
                                      },
                                      onChanged: (value) {
                                        userPassword = value;
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.key,
                                            color: Colors.grey[400],
                                          ),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(35.0)),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            // 클릭했을때도 border이 나오게
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(35.0)),
                                          ),
                                          hintText: 'Password',
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[400],
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(10.0)),
                                    )
                                  ],
                                )),
                          ),
                        if (!isSignUpScreen) // 로그인에서만 나오는 text form field
                          Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            child: Form(
                                key: _formkey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      // email address 적는 칸
                                      keyboardType: TextInputType.emailAddress,
                                      controller:
                                          authController.userEmailController,
                                      key: const ValueKey(3),
                                      validator: (value) {
                                        // email address에 이메일형식(@)을 갖추지 않으면 안됨
                                        if (value!.isEmpty ||
                                            !value.contains('@')) {
                                          return 'Please enter a valid email address';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        userEmail = value!;
                                      },
                                      onChanged: (value) {
                                        userEmail = value;
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.email,
                                            color: Colors.grey[400],
                                          ),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(35.0)),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            // 클릭했을때도 border이 나오게
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(35.0)),
                                          ),
                                          hintText: 'Email Address',
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[400],
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(10.0)),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    TextFormField(
                                      // password 적는 칸
                                      obscureText: true,
                                      controller:
                                          authController.userPasswordController,
                                      key: const ValueKey(4),
                                      validator: (value) {
                                        // password를 최소 6글자이상으로 해달라
                                        if (value!.isEmpty ||
                                            value.length < 6) {
                                          return 'Password must be at least 6 characters long';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        userPassword = value!;
                                      },
                                      onChanged: (value) {
                                        userPassword = value;
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.key,
                                            color: Colors.grey[400],
                                          ),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(35.0)),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            // 클릭했을때도 border이 나오게
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(35.0)),
                                          ),
                                          hintText: 'Password',
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[400],
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(10.0)),
                                    )
                                  ],
                                )),
                          )
                      ],
                    ),
                  ),
                )),
            // 세번째 position은 아래 check 전송버튼
            Positioned(
                //top: isSignUpScreen ? 350 : 290,
                top: 290,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        // 새로운 사용자 등록이 끝난 후에 그 다음과정이 진행되어야 하므로 async방식
                        if (isSignUpScreen) {
                          // 회원가입 할때, 전송버튼
                          _tryValidation();
                          authController.SignUp(contextLogin);
                        } else {
                          // 로그인화면일때, 전송버튼
                          _tryValidation();
                          authController.loginUser(contextLogin);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Colors.blue,
                                Colors.blueAccent,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(
                                    0, 1), // 버튼 그림자가 가지는 버튼으로부터의 수직,수평거리
                              )
                            ]),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 40.0,
                          weight: 100.0,
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
