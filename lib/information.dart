import 'package:flutter/material.dart';
import 'package:chat/chat_room.dart';
import 'package:chat/notice.dart';
import 'package:chat/home.dart';
import 'package:chat/template.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  int selectedIndex = 4; // ボタンがどこから始まるか
  List<Widget> pegelist = [
    TextListScreen(),
    ChatRoom(),
    MyToggleButtonScreen(),
    TimeListScreen(),
    InformationScreen()
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
              child: Center(
                child: Text(
                  '使用方法画面\n制作中', // Text to be displayed in the center of the square
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20, // Adjust the font size as needed
                    fontWeight: FontWeight.bold, // Adjust the font weight as needed
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          canvasColor: Colors.black, // ボトムナビゲーションの背景黒にする
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
            bottom: Radius.circular(20.0)
          ),
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
                BottomNavigationBarItem(
                  icon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // 円形の装飾
                      color: selectedIndex == 4 ? Colors.blue : Colors.transparent, // 選択中の場合は青い色、それ以外は透明な色
                    ),
                    padding: EdgeInsets.all(10.0), // アイコンの余白
                    child: Icon(Icons.help_outline),
                  ),
                  label: ' ',
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
        ),
      ),
    );
  }
} 