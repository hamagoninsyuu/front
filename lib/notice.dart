import 'package:flutter/material.dart';
import 'package:chat/template.dart';
import 'package:chat/chat_room.dart';
import 'package:chat/home.dart';
// import 'package:chat/information.dart';
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
    // InformationScreen()
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
                            child: Container(
                              padding: EdgeInsets.only(
                                  bottom: 8.0), // 下線の下に8ピクセルの隙間を作成
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 2.0,
                                        color: Colors.black)), // 下線を作成
                              ),
                              child: Text(
                                texts[index],
                                style: TextStyle(
                                  decoration: TextDecoration
                                      .none, // 下線はContainerで作成するので、Textの下線を無効化
                                  fontSize:
                                      15.0, // Update the fontSize to your desired value
                                ),
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
          Positioned(
            top: -60,
            left: 60,
            width: 500,
            height: 500,
            child: Icon(
              Icons.remove_circle,
              size: 50,
            ),
          )
        ],
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          canvasColor: Colors.black, // ボトムナビゲーションの背景黒にする
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.0), bottom: Radius.circular(20.0)),
          child: BottomAppBar(
            child: BottomNavigationBar(
              unselectedItemColor: Colors.grey, // 選択されてないアイコンの色
              selectedItemColor: Colors.white, // 選択されたアイコンの色
              items: [
                BottomNavigationBarItem(
                  icon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // 円形の装飾
                      color: selectedIndex == 0
                          ? Colors.blue
                          : Colors.transparent, // 選択中の場合は青い色、それ以外は透明な色
                    ),
                    padding: EdgeInsets.all(10.0), // アイコンの余白
                    child: Icon(Icons.list_alt),
                  ),
                  label: ' ',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // 円形の装飾
                      color: selectedIndex == 1
                          ? Colors.blue
                          : Colors.transparent, // 選択中の場合は青い色、それ以外は透明な色
                    ),
                    padding: EdgeInsets.all(10.0), // アイコンの余白
                    child: Icon(Icons.camera_alt),
                  ),
                  label: ' ',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // 円形の装飾
                      color: selectedIndex == 2
                          ? Colors.blue
                          : Colors.transparent, // 選択中の場合は青い色、それ以外は透明な色
                    ),
                    padding: EdgeInsets.all(10.0), // アイコンの余白
                    child: Icon(Icons.home),
                  ),
                  label: ' ',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // 円形の装飾
                      color: selectedIndex == 3
                          ? Colors.blue
                          : Colors.transparent, // 選択中の場合は青い色、それ以外は透明な色
                    ),
                    padding: EdgeInsets.all(10.0), // アイコンの余白
                    child: Icon(Icons.notifications),
                  ),
                  label: ' ',
                ),
                // BottomNavigationBarItem( // ボタンは4つなので、コメントアウト
                //   icon: Container(
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle, // 円形の装飾
                //       color: selectedIndex == 4
                //           ? Colors.blue
                //           : Colors.transparent, // 選択中の場合は青い色、それ以外は透明な色
                //     ),
                //     padding: EdgeInsets.all(10.0), // アイコンの余白
                //     child: Icon(Icons.help_outline),
                //   ),
                //   label: ' ',
                // ),
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
        ),
      ),
    );
  }
}
