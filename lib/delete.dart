import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

void delete() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Deletion',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Delete(), // เปลี่ยนชื่อคลาสที่นี่
    );
  }
}

class Delete extends StatefulWidget { // เปลี่ยนชื่อคลาสที่นี่
  const Delete({Key? key}) : super(key: key); // เปลี่ยนชื่อคลาสที่นี่

  @override
  _DeleteState createState() => _DeleteState(); // เปลี่ยนชื่อคลาสที่นี่
}

class _DeleteState extends State<Delete> { // เปลี่ยนชื่อคลาสที่นี่
  String userInput = '';

  Future<void> sendData() async {
  final response = await http.post(
    Uri.parse('http://172.21.12.106/mobileapp/wowwow3.php'), // เปลี่ยน URL ให้ตรงกับที่ใช้งาน
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'user_id': userInput, // เปลี่ยนให้เป็น user_id
    }),
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    if (responseData['success']) {
      print('Data deleted successfully: ${responseData['message']}');
    } else {
      print('Failed to delete data: ${responseData['error']}');
    }
  } else {
    print('Failed to send data. Status code: ${response.statusCode}');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delete"),foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 51, 51, 51)),
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
                  userInput = text;
                });
              },
            ),
            const SizedBox(height: 20),
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
                  MaterialPageRoute(builder: (context) => HomePage()),
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
