// import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:chat/template.dart';
import 'package:chat/chat_room.dart';
import 'package:chat/notice.dart';
import 'package:chat/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TextListScreen extends StatefulWidget {
  @override
  _TextListScreenState createState() => _TextListScreenState();
}

class _TextListScreenState extends State<TextListScreen> {
  TextEditingController _textEditingController = TextEditingController();

  Future<int> _generateId() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('template').get();
    int count = snapshot.docs.length;
    return count + 1;
  }

  Future<void> _addTextToFirestore(String text, int id) async {
    await FirebaseFirestore.instance.collection('template').add({
      'id': id,
      'text': text,
    });
  }

  int selectedIndex = 0; // ボタンがどこから始まるか
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
      // resizeToAvoidBottomInset: true,  // キーボードかぶせる
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
                    .collection('template')
                    .orderBy('text')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final texts = snapshot.data!.docs
                      .map((doc) => doc['text'] as String)
                      .toList();
                  return ListView.builder(
                    itemCount: texts.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
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
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          int id = await _generateId();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Enter Text'),
                content: TextField(
                  controller: _textEditingController,
                ),
                actions: [
                  ElevatedButton(
                    child: Text('Add'),
                    onPressed: () {
                      String enteredText = _textEditingController.text;
                      _addTextToFirestore(enteredText, id);
                      _textEditingController.clear();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(  // 何個の要素を置くか。今回は5個
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
          currentIndex: selectedIndex,  // 今何個目の選択肢か
          onTap: (int index) {  // ボタン押されたとき、どこが押されたかをselectedIndexに入れる
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
