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
      home: EditScreen(),
    );
  }
}

class EditScreen extends StatefulWidget {
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController userIdController = TextEditingController(); // เพิ่มช่องสำหรับ userId
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  bool isVisible = false;

  void submitId() {
    String id = idController.text;

    // TODO: คุณอาจต้องเพิ่มการตรวจสอบ ID ที่ซิงค์กับฐานข้อมูลในที่นี้

    // ตรวจสอบว่าค่า ID ไม่ว่าง
    if (id.isNotEmpty) {
      setState(() {
        isVisible = true; // แสดงกล่องข้อความเมื่อมีการกด submit ID
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid User ID.')),
      );
    }
  }

  Future<void> updateDatabase() async {
    String userId = userIdController.text;       // รหัสผู้ใช้ที่ต้องการอัปเดต
    String userName = userNameController.text; // ชื่อผู้ใช้
    String password = passwordController.text; // รหัสผ่าน
    String id = idController.text; // ใช้ ID ที่ผู้ใช้กรอก

    final String url = 'http://172.21.12.106/mobileapp/updatedb.php';

    final Map<String, String> data = {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'passwd': password,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(data), // ส่งข้อมูลในรูปแบบ JSON
        headers: {'Content-Type': 'application/json'}, // ระบุ Content-Type เป็น JSON
      );

      // ตรวจสอบสถานะการตอบกลับ
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Update successful!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Update failed: ${responseData['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Update failed!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: idController,
              decoration: InputDecoration(labelText: 'Enter User ID'),
            ),
            ElevatedButton(
              onPressed: submitId,
              child: Text('Submit ID'),
            ),
            if (isVisible) ...[
              TextField(
                controller: userIdController, // ช่องกรอก userId
                decoration: InputDecoration(labelText: 'User ID'),
              ),
              TextField(
                controller: userNameController,
                decoration: InputDecoration(labelText: 'User Name'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: updateDatabase,
                child: Text('Update'),
              ),
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
          ],
        ),
      ),
    );
  }
}
