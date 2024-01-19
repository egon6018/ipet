import 'package:dio/dio.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:http/http.dart' as http;

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:ipet/controllers/witness_controller.dart';
import 'package:ipet/controllers/auth_controller.dart';

class Witness extends StatefulWidget {
  const Witness({super.key});

  @override
  State<Witness> createState() => _WitnessState();
}

class _WitnessState extends State<Witness> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  //File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  final List<XFile> _selectedImages = [];
  List<dynamic> imageIds = []; // 서버에서 이미지id들 받을 리스트
  String first = '1'; // AI 추천 첫번째 품종
  String second = '2'; // AI 추천 두번째 품종
  String third = '3'; // AI 추천 세번째 품종

  WitnessController witnessController = WitnessController();

  AuthController authController = AuthController();

  String? userToken;
  @override
  void initState() {
    super.initState();
    _loadUserToken();
  }

  Future<void> _loadUserToken() async {
    String? token = await authController.getToken();
    setState(() {
      userToken = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '목격했어요',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      fixedSize:
                          MaterialStateProperty.all(const Size(100, 100)),
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () async {
                      const maxImages = 1;
                      if (_selectedImages.length < maxImages) {
                        XFile? image = await _imagePicker.pickImage(
                            // 이미지 선택
                            source: ImageSource.gallery);
                        if (image != null) {
                          // 아래에 선택한 이미지들이 보이게 하기 위해서
                          setState(() {
                            _selectedImages.add(image);
                          });

                          // 여기서부터 dio패키지로 이미지업로드 구현과정
                          dynamic sendData = image.path;
                          var formData = FormData.fromMap(
                              {'file': await MultipartFile.fromFile(sendData)});

                          print("사진을 서버에 업로드 합니다.");
                          var dio = Dio();
                          try {
                            dio.options.contentType = 'multipart/form-data';
                            dio.options.maxRedirects.isFinite;

                            //dio.options.headers = {'token': userToken}; // 토큰 필요X

                            var response = await dio.post(
                              'https://ipet-server.run.goorm.site/api/v1/images?category=images',
                              data: formData,
                            );
                            print('성공적으로 업로드했습니다');
                            print(response.data);

                            imageIds.add(response.data['data'][0]['id']);
                            setState(() {
                              first = response.data['data'][0]['ai']['first'];
                              second = response.data['data'][0]['ai']['second'];
                              third = response.data['data'][0]['ai']['third'];
                            });
                          } catch (e) {
                            if (e is DioError) {
                              print('DioError: ${e.message}');
                              if (e.response != null) {
                                print('Response data: ${e.response?.data}');
                                print(
                                    'Response status: ${e.response?.statusCode}');
                              }
                            } else {
                              print('Unexpected error: $e');
                            }
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: const Text('이미지를 선택해주세요!'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('확인'),
                                  ),
                                ],
                              );
                            },
                          );
                          print('이미지 선택에 실패했거나 이미지를 선택하지 않았습니다.');
                        }
                      } else {
                        // 이미지 선택 제한에 도달한 경우에 대한 메시지 표시
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: const Text(
                                  '이미지는 $maxImages개까지만 선택하실 수 있습니다.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('확인'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Center(
                      child: Text(
                        '이미지 선택 및 업로드',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  SizedBox(
                    height: 100.0,
                    child: _selectedImages.isNotEmpty
                        ? Image.file(
                            File(_selectedImages[0].path),
                            fit: BoxFit.cover,
                            width: 100.0, // 이미지의 폭을 조절
                            height: 100.0, // 이미지의 높이를 조절
                          )
                        : const Center(
                            child: Text(
                              '이미지를 선택해주세요',
                              style: TextStyle(fontSize: 17.0),
                            ),
                          ),
                    // child: ListView.builder(
                    //   scrollDirection: Axis.horizontal, // 수평 스크롤을 위해
                    //   itemCount: _selectedImages.length,
                    //   itemBuilder: (context, index) {
                    //     return Image.file(
                    //       File(_selectedImages[index].path),
                    //       width: 100.0,
                    //       height: 100.0,
                    //     );
                    //   },
                    // ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Container(
                          // AI추천 1
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white, // 배경색 설정
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 3),
                          ),
                          // child: Image.network(
                          //     'https://ipet-server.run.goorm.site/api/v1/images/breeds?q=$first'),
                          child: first != '1'
                              ? Image.network(
                                  'https://ipet-server.run.goorm.site/api/v1/images/breeds?q=$first',
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                )
                              : const Center(child: Text('AI\n추천품종1'))),
                      SizedBox(
                        child: Text(
                          first,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                          // AI추천 2
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 10),
                          //padding: const EdgeInsets.all(16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white, // 배경색 설정
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 3),
                          ),
                          child: second != '2'
                              ? Image.network(
                                  'https://ipet-server.run.goorm.site/api/v1/images/breeds?q=$second',
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                )
                              : const Center(child: Text('AI\n추천품종2'))),
                      SizedBox(
                        child: Text(
                          second,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                          // AI추천 3
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white, // 배경색 설정
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 3),
                          ),
                          child: third != '3'
                              ? Image.network(
                                  'https://ipet-server.run.goorm.site/api/v1/images/breeds?q=$third',
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                )
                              : const Center(child: Text('AI\n추천품종3'))),
                      SizedBox(
                        child: Text(
                          third,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      // 날짜 선택
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.primary)),
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            ).then((selectedDate) {
                              setState(() {
                                _selectedDate = selectedDate;
                              });
                            });
                          },
                          child: const Text(
                            "날짜 선택",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          height: 55,
                          child: Text(
                              _selectedDate != null
                                  ? _selectedDate.toString().split(" ")[0]
                                  : "날짜를 선택해주세요",
                              style: const TextStyle(fontSize: 20)),
                        ),
                      ],
                    ),
                    Column(
                      // 시간 선택
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.primary)),
                          onPressed: () {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((selectedTime) {
                              if (selectedTime != null) {
                                setState(() {
                                  _selectedTime = selectedTime;
                                });
                              }
                            });
                          },
                          child: const Text(
                            "시간 선택",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          height: 55,
                          child: Text(
                              _selectedTime != null
                                  ? "${_selectedTime?.format(context)}"
                                  : "시간을 선택해주세요",
                              style: const TextStyle(fontSize: 20)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Center(
                // 품종이자 제목 작성 폼
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: witnessController.titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "품종",
                    ),
                  ),
                ),
              ),
              Center(
                // 장소 작성 폼
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: witnessController.placeController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "목격한 장소",
                    ),
                  ),
                ),
              ),
              Center(
                // 생김새 작성 폼
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: witnessController.contentController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "생김새 등 작성",
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primary),
                    minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 50)),
                  ),
                  onPressed: () {
                    // 버튼 클릭 시 서버에 저장되고 게시글이 올라가야 함!

                    // 날짜와 시간, 아래 내용들 서버에 전송
                    if (_selectedDate != null && _selectedTime != null) {
                      witnessController.sendBoard(context, _selectedDate!,
                          _selectedTime!, imageIds, userToken);
                    }
                    if (_selectedDate == null) {
                      // 날짜를 입력하지 않았을 때
                      DateToast();
                    }
                    if (_selectedTime == null) {
                      // 시간을 입력하지 않았을 때
                      TimeToast();
                    }
                  },
                  child: const Text(
                    '목격했다고 알려주기',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              )
            ],
          ),
        ));
  }
}

void imageToast() {
  Fluttertoast.showToast(
      msg: '이미지를 선택해주세요',
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.redAccent,
      fontSize: 20.0,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG);
}

void DateToast() {
  Fluttertoast.showToast(
      msg: '날짜를 선택해주세요',
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.redAccent,
      fontSize: 20.0,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG);
}

void TimeToast() {
  Fluttertoast.showToast(
      msg: '시간을 선택해주세요',
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.redAccent,
      fontSize: 20.0,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG);
}
