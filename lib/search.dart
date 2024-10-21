import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String id = '';
  bool isLoading = false;
  String errorMessage = '';
  List<dynamic> userData = []; // ตัวแปรสำหรับเก็บข้อมูลผู้ใช้

  Future<void> sendData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse('http://172.21.12.106/mobileapp/search.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'id': id, // ส่งค่า id ไปยัง PHP
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> fetchedData = jsonDecode(response.body);

        if (fetchedData.isNotEmpty) {
          setState(() {
            userData = fetchedData; // เก็บข้อมูลที่ดึงได้ใน userData
          });
        } else {
          setState(() {
            errorMessage = 'No data found for user ID $id';
            userData = [];
          });
        }
      } else {
        setState(() {
          errorMessage = 'Error: Failed to load data';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 51, 51, 51),
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        color: const Color.fromARGB(255, 185, 185, 185),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter User ID",
              ),
              onChanged: (text) {
                setState(() {
                  id = text;
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
            const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),

            // แสดงข้อมูลผู้ใช้หลังจากส่งข้อมูลสำเร็จ
            if (userData.isNotEmpty) 
              Expanded(
                child: ListView.builder(
                  itemCount: userData.length,
                  itemBuilder: (context, index) {
                    final user = userData[index];
                    return Card(
                      child: ListTile(
                        title: Text('User ID: ${user['user_id']}'),
                        subtitle: Text('Name: ${user['user_name']}, Password: ${user['passwd']}'),
                      ),
                    );
                  },
                ),
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
        ),
      ),
    );
  }
}
