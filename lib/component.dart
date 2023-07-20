import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
import 'package:chat/template.dart';
import 'package:chat/chat_room.dart';
import 'package:chat/home.dart';
import 'package:chat/notice.dart';

class template extends StatelessWidget {
  // 定型文ボタン
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: TextListScreen()),
    );
  }
}

// カメラボタン
class camera extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: ChatRoom()),
    );
  }
}

// ホームボタン
class home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: MyToggleButtonScreen()),
    );
  }
}

// 通知ボタン
class notice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: TimeListScreen()),
    );
  }
}

// 情報ボタン
class info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: TextListScreen()),
    );
  }
}
