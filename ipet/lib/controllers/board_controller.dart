import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// List<User> userFromJson(String str) =>
//     List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

// String userToJson(List<User> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Animal {
  static const String url = 'https://ipet-server.run.goorm.site/api/v1/boards';

  static Future<List<User>> getInfo() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<User> user = (json.decode(response.body) as List)
            .map((json) => User.fromJson(json))
            .toList();
        return user;
      } else {
        Fluttertoast.showToast(msg: "Error occurred. Please try again");
        return <User>[];
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      print(e.toString());
      return <User>[];
    }
  }
}

class User {
  User({
    required this.name,
    required this.img,
  });

  String name;
  String img;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(name: json['title'], img: json['attachmentIds']);
  }
}

// Future<List<Animal>> getAllPost() async {
//   final response = await http
//       .get(Uri.parse('https://ipet-server.run.goorm.site/api/v1/boards'));
//   if (response.statusCode == 200) {
//     List<dynamic> data = json.decode(response.body);
//     return data.map<Animal>((json) => Animal.fromJson(json)).toList();
//   } else {
//     throw Exception('Failed to load post list');
//   }
// }

// class Animal {
//   final String name;
//   final String imgPath;

//   Animal({required this.name, required this.imgPath});

//   factory Animal.fromJson(Map<String, dynamic> json) {
//     return Animal(
//       name: json['title'],
//       imgPath: json['attachmentIds'][0],
//     );
//   }
// }



// 시도했던 코드
//  List<User> _user = <User>[];
//   bool loading = false;

//   String? userEmail;
//   @override
//   void initState() {
//     super.initState();
//     _loadUserEmail();
//     Animal.getInfo().then((value) {
//       setState(() {
//         _user = value;
//         loading = true;
//       });
//     });
//   }

// 아래는 body부분
// GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 8.0,
//           mainAxisSpacing: 8.0,
//         ),
//         itemCount: _user.length,
//         itemBuilder: (BuildContext context, int index) {
//           return GestureDetector(
//             onTap: () {
//               // 클릭 시 원하는 동작 수행
//               //print('Clicked on post ${posts[index].id}');
//             },
//             child: Card(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Image.network(
//                     _user[index].img,
//                     height: 120.0,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       _user[index].name,
//                       style: TextStyle(
//                           fontSize: 16.0, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),