import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
//import 'package:fluttertoast/fluttertoast.dart';

import "login.dart";
import 'model.dart';
import 'package:ipet/animal_page.dart';

// 검색어
String searchText = '';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // 리스트뷰에 표시할 내용
  static List<String> animalName = [
    '말티즈',
    '말티즈',
    '웰시코기',
    '푸들',
    '포메라니안',
    '비글',
    '치와와',
    '리트리버',
    '비글',
    '보더콜리',
  ];
  static List<String> animalImagePath = [
    'images/말티즈.png',
    'images/말티즈2.jpeg',
    'images/웰시코기.jpeg',
    'images/푸들.jpeg',
    'images/포메라니안.jpeg',
    'images/비글.jpg',
    'images/치와와.jpeg',
    'images/리트리버.jpg',
    'images/비글2.jpg',
    'images/보더콜리.jpg'
  ];

  final List<Animal> animalData = List.generate(animalName.length,
      (index) => Animal(animalName[index], animalImagePath[index]));

  List<Animal> searchResults = [];

  @override
  Widget build(BuildContext contextHome) {
    // 현재 화면의 크기를 가져오기
    double screenWidth = MediaQuery.of(context).size.width;
    // 화면 크기에 따라 동적으로 그리드 열 수 설정
    int gridColumns = (screenWidth / 150).floor();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'I-PET',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0.0,
        actions: [
          // 로그인, 회원가입 버튼 구현해야됨
          TextButton(
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(right: 15.0),
                  primary: Theme.of(context).colorScheme.onPrimary,
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0)),
              onPressed: () {
                Navigator.push(contextHome,
                    MaterialPageRoute(builder: (context) => const Login()));
              },
              child: const Text("로그인")),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: '검색어를 입력해주세요.',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true, // 중요: 이 속성을 true로 설정해야 합니다.
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridColumns, // 동적으로 설정된 열 수
              ),
              // items 변수에 저장되어 있는 모든 값 출력
              itemCount: animalData.length,
              itemBuilder: (BuildContext context, int index) {
                // 검색 기능, 검색어가 있을 경우
                if (searchText.isNotEmpty &&
                    !animalData[index]
                        .name
                        .toLowerCase()
                        .contains(searchText.toLowerCase())) {
                  return const SizedBox.shrink(); // 검색어에 맞지 않으면 아이템을 숨김
                }
                // 검색어가 없을 경우, 모든 항목 표시
                else {
                  return GestureDetector(
                    onTap: () {
                      // 게시물 상세조회로 이동하는 동작 추가
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AnimalPage(
                                animal: animalData[index],
                              )));
                      debugPrint(animalData[index].name);
                    },
                    child: Card(
                      elevation: 3,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.elliptical(20, 20))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(20.0), // 테두리의 둥근 정도를 설정
                            child: Image.asset(
                              animalData[index].imgPath,
                              fit: BoxFit.cover,
                              width: double.infinity, // 이미지의 폭을 조절
                              height: 130.0, // 이미지의 높이를 조절
                            ),
                          ),
                          Text(animalData[index].name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0))
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('로그인', style: TextStyle(fontSize: 20)),
              accountEmail: const Text('해주세요', style: TextStyle(fontSize: 20)),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0))),
            ),
            ListTile(
              leading: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('찾고싶어요'),
              onTap: () {
                print("'찾고싶어요' is clicked");
              },
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.dog,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('목격했어요'),
              onTap: () {
                print("'목격했어요' is clicked");
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                    '로그인 후, 사용가능합니다',
                    textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.blue,
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}

// void flutterToast() {
//   Fluttertoast.showToast(
//       msg: '로그인 후, 사용가능합니다',
//       gravity: ToastGravity.BOTTOM,
//       backgroundColor: Colors.redAccent,
//       fontSize: 20.0,
//       textColor: Colors.white,
//       toastLength: Toast.LENGTH_LONG);
// }
