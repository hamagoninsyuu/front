import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat/home.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'chat App',
      debugShowCheckedModeBanner: false,  // ラベル消す
      // home: TextListScreen(), // 定型文に飛ぶ
      // home: ChatRoom(), // チャット画面に飛ぶ
      home: MyToggleButtonScreen(), // ホーム画面に飛ぶ
    );
  }
}
