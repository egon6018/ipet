import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WitnessController {
  TextEditingController titleController =
      TextEditingController(); // 품종이자 제목작성 폼
  TextEditingController placeController = TextEditingController(); // 장소작성 폼
  TextEditingController contentController =
      TextEditingController(); // 생김새 등 내용작성 폼

  Future sendBoard(BuildContext context, DateTime selectedDate,
      TimeOfDay selectedTime, List<dynamic> imgIds, String? token) async {
    try {
      const url = 'https://ipet-server.run.goorm.site/api/v1/boards';

      // Check for null safety
      if (titleController.text == null) {
        print('Error: Null values detected - title');
      }
      if (contentController.text == null) {
        print('Error: Null values detected - content');
      }
      if (placeController.text == null) {
        print('Error: Null values detected - place');
      }
      if (token == null) {
        print('Error: Null values detected - token');
      }

      // 날짜와 시간 서버에 제출
      // final date =
      //     '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}'; // 선택한 날짜 정보를 문자열로 변환
      final date = DateFormat('yyyy-MM-dd').format(selectedDate);
      final Time = DateFormat.Hm().format(DateTime(
          // 선택한 시간 정보를 문자열로 변환
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute));

      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            "title": titleController.text,
            "content": contentController.text,
            'incidentDateTime': '${date}T$Time',
            "location": placeController.text,
            "attachmentIds": imgIds // 이미지 아이디들
          }));

      if (response.statusCode == 200) {
        print('게시물 업로드 성공! 서버 응답: ${response.body}');
        // 다시 홈으로 가도록
        Navigator.pop(context);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            '게시물 업로드 완료했습니다.',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.blue,
        ));
      } else {
        print('게시물 업로드 전송에러. 에러 코드: ${response.statusCode}');
        print('${response.body}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
    }
  }
}
