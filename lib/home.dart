import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chat/template.dart';
import 'package:chat/chat_room.dart';
import 'package:chat/notice.dart';
// import 'package:chat/information.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CupertinoSwitchTile extends StatelessWidget {
  const CupertinoSwitchTile({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Container(
        width: 51.0,
        height: 31.0,
        child: CupertinoSwitch(
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class MyToggleButtonScreen extends StatefulWidget {
  @override
  _MyToggleButtonScreenState createState() => _MyToggleButtonScreenState();
}

class _MyToggleButtonScreenState extends State<MyToggleButtonScreen> {
  bool toggleValue1 = true;  // 通知のトグル
  bool toggleValue2 = true; // 録画のトグル

  int selectedIndex = 2; // ボタンがどこから始まるか
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
          Positioned(
            child: Container(
              transform: Matrix4.translationValues(20.0, 100.0, 0.0),
              padding: EdgeInsets.all(1.0),
              width: 320.0,
              height: 420.0,
              decoration: BoxDecoration(
                border: Border.all(width: 1.0),
                color: Colors.white,
                borderRadius: BorderRadius.circular(34.0),
              ),
            ),
          ),
          Positioned(
            child: Container(
              width: 290,
              height: 260,
              transform: Matrix4.translationValues(35.0, 125.0, 0.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(143, 143, 143, 1.0),
                borderRadius: BorderRadius.circular(30),
              ),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('photos')
                    .orderBy('imageURL', descending: true)
                    .limit(1)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No data available');
                  }

                  // 最新の画像URLを取得
                  String imageURL =
                      snapshot.data!.docs[0].get('imageURL')?.toString() ?? '';

                  return Image.network(imageURL, fit: BoxFit.cover,); //  fit: BoxFit.coverでサイズいっぱいの画像になる
                },
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      // 通知の赤い丸
                      width: 9,
                      height: 9,
                      transform: Matrix4.translationValues(-90.0, 135.0, 0.0),
                      decoration: BoxDecoration(
                        color: toggleValue1 ? Colors.blue : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      // 録画の赤い丸
                      width: 9,
                      height: 9,
                      transform: Matrix4.translationValues(40.0, 135.0, 0.0),
                      decoration: BoxDecoration(
                        color: toggleValue2 ? Colors.blue : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      // 通知という文字
                      width: 40,
                      height: 50,
                      transform: Matrix4.translationValues(-60.0, 145.0, 0.0),
                      child: Text(
                        '通知',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: toggleValue1 ? Colors.blue : Colors.red,
                        ),
                      ),
                    ),
                    Container(
                      // 録画という文字
                      width: 40,
                      height: 50,
                      transform: Matrix4.translationValues(70.0, 145.0, 0.0),
                      child: Text(
                        '録画',
                        style: TextStyle(
                          fontSize: 15,
                          color: toggleValue2 ? Colors.blue : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  transform: Matrix4.translationValues(-5, 110, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40),
                      CupertinoSwitchTile(
                        value: toggleValue1,
                        onChanged: (value) {
                          setState(() {
                            toggleValue1 = value;
                          });
                        },
                      ),
                      SizedBox(width: 50),
                      CupertinoSwitchTile(
                        value: toggleValue2,
                        onChanged: (value) {
                          setState(() {
                            toggleValue2 = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar:  Theme(
        data: ThemeData(
          canvasColor: Colors.black, // ボトムナビゲーションの背景黒にする
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0), bottom: Radius.circular(20.0)),
          child:BottomAppBar(
            child: BottomNavigationBar(
              unselectedItemColor: Colors.grey, // 選択されてないアイコンの色
              selectedItemColor: Colors.white, // 選択されたアイコンの色
              items: [
                BottomNavigationBarItem(
                  icon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // 円形の装飾
                      color: selectedIndex == 0 ? Colors.blue : Colors.transparent, // 選択中の場合は青い色、それ以外は透明な色
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
                      color: selectedIndex == 1 ? Colors.blue : Colors.transparent, // 選択中の場合は青い色、それ以外は透明な色
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
                      color: selectedIndex == 2 ? Colors.blue : Colors.transparent, // 選択中の場合は青い色、それ以外は透明な色
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
                      color: selectedIndex == 3 ? Colors.blue : Colors.transparent, // 選択中の場合は青い色、それ以外は透明な色
                    ),
                    padding: EdgeInsets.all(10.0), // アイコンの余白
                    child: Icon(Icons.notifications),
                  ),
                  label: ' ',
                ),
                // BottomNavigationBarItem(
                //   icon: Container(
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle, // 円形の装飾
                //       color: selectedIndex == 4 ? Colors.blue : Colors.transparent, // 選択中の場合は青い色、それ以外は透明な色
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
