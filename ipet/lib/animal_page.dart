import 'package:flutter/material.dart';
import 'model.dart';
import 'login_home.dart';

class AnimalPage extends StatefulWidget {
  const AnimalPage({Key? key, required this.animal}) : super(key: key);
  // animal 객체는 null값을 가질 수 없으므로 required 키워드를 붙인다
  // => 홈화면에서 AnimalPage로 이동하려고 할때, 반드시 argument가 있어야 한다는 뜻

  final Animal animal;

  @override
  State<AnimalPage> createState() => _AnimalPageState();
}

class _AnimalPageState extends State<AnimalPage> {
  LoginHome loginHome = const LoginHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.animal.name,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 250.0,
                  child: Image.asset(widget.animal.imgPath,
                      fit: BoxFit.cover), // 이미지를 확장하여 정사각형에 맞게 표시
                ),
              ),
              const SizedBox(
                width: double.infinity,
                height: 20.0,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 입력한 날짜
                    Column(
                      children: [
                        Container(
                          width: 170,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius:
                                BorderRadius.circular(10.0), // 모서리 둥글게 만들기
                          ),
                          child: const Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "발견한 날짜",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 170,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius:
                                BorderRadius.circular(10.0), // 모서리 둥글게 만들기
                          ),
                          child: const Center(
                            child: Text('2023-11-19',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                    // 입력한 시간
                    Column(
                      children: [
                        Container(
                          width: 170,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius:
                                BorderRadius.circular(10.0), // 모서리 둥글게 만들기
                          ),
                          child: const Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "발견한 시간",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 170,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius:
                                BorderRadius.circular(10.0), // 모서리 둥글게 만들기
                          ),
                          child: const Center(
                            child: Text('6:40:36',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: double.infinity,
                height: 20.0,
              ),
              Center(
                // 장소 작성 폼
                child: Container(
                  width: MediaQuery.of(context).size.width - 40.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0), // 모서리 둥글게 만들기
                  ),
                  child: const SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "인하대 후문",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: double.infinity,
                height: 20.0,
              ),
              Center(
                // 장소 작성 폼
                child: Container(
                  width: MediaQuery.of(context).size.width - 40.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0), // 모서리 둥글게 만들기
                  ),
                  child: const SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "흰색 털\n",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: double.infinity,
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    child: Text(
                      "도움이 되셨나요?",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                    height: 20.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // 버튼이 눌렸을 때 실행되는 코드 추가
                      print('포인트 +100');
                      int increasedPoints = 100;
                      Navigator.pop(context, increasedPoints);
                    },
                    style: ElevatedButton.styleFrom(
                      primary:
                          Theme.of(context).colorScheme.background, // 버튼의 기본 색상
                      onPrimary:
                          Theme.of(context).colorScheme.primary, // 텍스트의 색상
                      elevation: 5, // 그림자 효과
                      //padding: const EdgeInsets.all(10), // 내부 여백
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // 버튼의 모서리를 둥글게 만듦
                      ),
                      //fixedSize: const Size(100.0, 10.0), // 버튼의 크기를 조절
                    ),
                    child: const SizedBox(
                      //width: 50.0,
                      //height: 10.0,
                      child: Center(
                        child: Text(
                          '포인트 주기',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
