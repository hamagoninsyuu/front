import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:chat/template.dart';
import 'package:chat/notice.dart';
import 'package:chat/home.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class ChatRoom extends StatefulWidget {
  final String? selectedTime; // Add selectedTime as a parameter

  const ChatRoom({Key? key, this.selectedTime}) : super(key: key);

  @override
  ChatRoomState createState() => ChatRoomState();
}

class ChatL10nJa extends ChatL10n {
  const ChatL10nJa({
    String? unreadMessagesLabel, // Nullable parameter
    String attachmentButtonAccessibilityLabel = '画像アップロード',
    String emptyChatPlaceholder = 'メッセージがありません。',
    String fileButtonAccessibilityLabel = 'ファイル',
    String inputPlaceholder = 'メッセージを入力してください',
    String sendButtonAccessibilityLabel = '送信',
  }) : super(
          attachmentButtonAccessibilityLabel:
              attachmentButtonAccessibilityLabel,
          emptyChatPlaceholder: emptyChatPlaceholder,
          fileButtonAccessibilityLabel: fileButtonAccessibilityLabel,
          inputPlaceholder: inputPlaceholder,
          sendButtonAccessibilityLabel: sendButtonAccessibilityLabel,
          unreadMessagesLabel: unreadMessagesLabel ??
              '', // Use null-aware operator to convert to non-null value
        );
}

class ChatRoomState extends State<ChatRoom> {
  final List<types.Message> _messages = [];
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );

  // 相手
  final _other = const types.User(
      id: 'delivery',
      firstName: "クロネコヤマト",
      lastName: "宅急便",
      imageUrl:
          "https://cdn-xtrend.nikkei.com/atcl/contents/casestudy/00012/00600/03.png?__scale=w:600,h:403&_sh=01f0690a70");

  String? _dateDocumentId;

  @override
  void initState() {
    super.initState();
    _addMessage(types.TextMessage(
      author: _other,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: "クロネコヤマトです",
    ));
    _addMessage(types.TextMessage(
      author: _other,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: "お荷物をお届けに来ました",
    ));
    // Convert selectedTime to Firestore document ID
    _dateDocumentId = _getDocumentIdFromSelectedTime(widget.selectedTime);
    if (_dateDocumentId != null) {
      _fetchMessageHistory();
    }
  }

  void _fetchMessageHistory() {
    FirebaseFirestore.instance
        .collection('photos')
        .doc(_dateDocumentId)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        // No messages for the selected date
        return;
      }

      final List<types.Message> messages = [];
      snapshot.docs.forEach((doc) {
        final data = doc.data();
        final textMessage = types.TextMessage(
          author:
              _other, // Change this to sender or receiver based on 'senderId' and 'receiverId'
          createdAt: (data['timestamp'] as Timestamp).millisecondsSinceEpoch,
          id: doc.id,
          text: data['message'] as String? ?? '',
        );
        messages.add(textMessage);
      });

      setState(() {
        _messages.clear();
        _messages.addAll(messages);
      });
    });
  }

  int selectedIndex = 1; // ボタンがどこから始まるか
  List<Widget> pegelist = [
    TextListScreen(),
    ChatRoom(),
    MyToggleButtonScreen(),
    TimeListScreen(),
    TextListScreen()
  ]; //リスト一覧

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true, // キーボードかぶせる
      body: SingleChildScrollView(
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/background.png'), fit: BoxFit.cover),
          ),
          child: Stack(
            children: [
              Container(
                width: 320.0,
                height: 340.0,
                transform: Matrix4.translationValues(22.5, 268.0, 0.0),
                padding: EdgeInsets.all(1.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Chat(
                          theme: const DefaultChatTheme(
                              sendButtonIcon: Icon(
                                Icons.send, // 送信ボタンに表示するアイコン
                                color: Colors.grey, // アイコンの色を指定
                              ),
                              primaryColor: Colors.blue, // メッセージの背景色の変更
                              userAvatarNameColors: [
                                Colors.blue
                              ], // ユーザー名の文字色の変更
                              inputContainerDecoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20)), // 角丸にするための設定
                                color: Colors.blueGrey, // コンテナの背景色を指定
                              ),
                              attachmentButtonIcon:
                                  Icon(Icons.list_alt)), //定型文のアイコン
                          messages: _messages,
                          onSendPressed: _handleSendPressed,
                          user: _user,
                          showUserAvatars: true,
                          showUserNames: true,
                          l10n: const ChatL10nJa(),
                          //onAttachmentPressed: () {}, // 定型文のアイコンを表示
                          onAttachmentPressed: _handleAttachmentPressed,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // グレー色の四角形
              Positioned(
                top: 10,
                left: 20,
                right: 20,
                child: Center(
                  child: Container(
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

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Text('No data available');
                        }

                        // 最新の画像URLを取得
                        String imageURL = snapshot.data!.docs[0]
                                .get('imageURL')
                                ?.toString() ??
                            '';

                        return Image.network(
                          imageURL,
                          fit: BoxFit.cover,
                        ); //  fit: BoxFit.coverでサイズいっぱいの画像になる
                      },
                    ),
                    height: 245, // Change the height as needed
                    width: 350,
                    color: Colors.grey, // Set the color to grey
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:  ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0), bottom: Radius.circular(20.0)),
        child:BottomAppBar(
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
      ),
    );
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            width: 320.0,
            height: 300.0,
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: Container(
                width: 250.0,
                height: 250.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('template')
                      .orderBy('text')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasError) {
                      return Text('データの取得中にエラーが発生しました');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Text('データがありません');
                    }

                    // データを表示するウィジェットを作成する
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        // ドキュメントデータを取得
                        var data = snapshot.data!.docs[index].data();

                        // ドキュメント内のフィールドにアクセスする例
                        var text = data['text'] as String?;

                        return Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {
                              // ボタンが押された時の処理
                              _addMessage(types.TextMessage(
                                author: _user,
                                createdAt:
                                    DateTime.now().millisecondsSinceEpoch,
                                id: randomString(),
                                text: data['text'] as String? ?? '',
                              ));
                              Navigator.pop(context); // ボトムシートを閉じる
                            },
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                text ?? '',
                                style: TextStyle(fontSize: 16.0),
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
          ),
        );
      },
    );
  }

  void _handleSendPressed(types.PartialText message) async {
    final dateDocumentId = _getDocumentIdFromSelectedTime(widget.selectedTime);

    if (dateDocumentId != null) {
      await FirebaseFirestore.instance
          .collection('photos')
          .doc(dateDocumentId)
          .collection('chats')
          .add({
            'message': message.text,
            'senderId': _user.id,
            'receiverId': _other.id,
            'timestamp': FieldValue.serverTimestamp(),
          })
          .then((_) => print('Message added to Firestore!'))
          .catchError((error) => print('Error adding message: $error'));
    }

    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  String? _getDocumentIdFromSelectedTime(String? selectedTime) {
    // Convert selectedTime (formatted as "YYYY-MM-DD") to Firestore document ID
    // For example, "2023-07-21" will be converted to "20230721"
    if (selectedTime == null) {
      return null;
    }

    return selectedTime.replaceAll('-', '');
  }
}
