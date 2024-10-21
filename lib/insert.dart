import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Registration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Insert(),
    );
  }
}

class Insert extends StatefulWidget {
  const Insert({Key? key}) : super(key: key);

  @override
  _InsertState createState() => _InsertState();
}

class _InsertState extends State<Insert> {
  String userId = '';
  String userName = '';
  String passwd = '';

  Future<void> sendData() async {
    final response = await http.post(
      Uri.parse('http://172.21.12.106/mobileapp/insertdb.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': userId,
        'user_name': userName,
        'passwd': passwd,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success']) {
        print('Data sent successfully: ${responseData['message']}');
      } else {
        print('Failed to send data: ${responseData['error']}');
      }
    } else {
      print('Failed to send data. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Insert"),foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 51, 51, 51)),
      body: Container(
        padding: const EdgeInsets.all(30),
        color: const Color.fromARGB(255, 185, 185, 185),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter User ID",
              ),
              onChanged: (text) {
                setState(() {
                  userId = text;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter User Name",
              ),
              onChanged: (text) {
                setState(() {
                  userName = text;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter Password",
              ),
              obscureText: true,
              onChanged: (text) {
                setState(() {
                  passwd = text;
                });
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: sendData,
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Back to HomePage',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}