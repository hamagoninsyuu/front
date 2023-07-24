// import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:chat/template.dart';
import 'package:chat/chat_room.dart';
import 'package:chat/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TimeListScreen extends StatefulWidget {
  @override
  _TimeListScreenState createState() => _TimeListScreenState();
}

class _TimeListScreenState extends State<TimeListScreen> {
  TextEditingController _textEditingController = TextEditingController();

  Future<int> _generateId() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('photos').get();
    int count = snapshot.docs.length;
    return count + 1;
  }

  Future<void> _addTextToFirestore(String time) async {
    await FirebaseFirestore.instance.collection('photos').add({
      'time': time,
    });
  }

  int selectedIndex = 3; // ボタンがどこから始まるか
  List<Widget> pegelist = [
    TextListScreen(),
    ChatRoom(),
    MyToggleButtonScreen(),
    TimeListScreen(),
    TextListScreen()
  ]; //リスト一覧

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            // 背景画像
            child: Image.asset(
              'images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            // 鳥のアイコン
            top: 30,
            left: -10,
            width: 400,
            height: 400,
            child: Image.asset(
              'images/bird.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Container(
              width: 320.0,
              height: 300.0,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  // 四角形の黒い枠線
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('photos')
                    .orderBy('time')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final texts = snapshot.data!.docs
                      .map((doc) => doc['time'] as String)
                      .toList();
                  return ListView.builder(
                    itemCount: texts.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            // Handle the onTap event and navigate to the ChatRoom widget
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChatRoom(selectedTime: texts[index]),
                              ),
                            );
                          },
                          child: Center(
                            child: Text(
                              texts[index],
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.black,
                                decorationThickness: 2.0,
                                decorationStyle: TextDecorationStyle.solid,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: ' ',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: ' ',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: ' ',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: ' ',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.help_outline),
              label: ' ',
              backgroundColor: Colors.black,
            ),
          ],
          currentIndex: selectedIndex,
          onTap: (int index) {
            setState(() {
              selectedIndex = index;
            });

            // 画面遷移の処理
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => pegelist[selectedIndex], // 選択された画面に遷移
              ),
            );
          },
        ),
      ),
    );
  }
}
