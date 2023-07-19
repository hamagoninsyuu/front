import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
  bool toggleValue1 = false;
  bool toggleValue2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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

                  return Image.network(imageURL);
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
                      width: 9,
                      height: 9,
                      transform: Matrix4.translationValues(-90.0, 100.0, 0.0),
                      decoration: BoxDecoration(
                        color: toggleValue1 ? Colors.blue : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 9,
                      height: 9,
                      transform: Matrix4.translationValues(40.0, 100.0, 0.0),
                      decoration: BoxDecoration(
                        color: toggleValue2 ? Colors.blue : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 50,
                      transform: Matrix4.translationValues(-60.0, 110.0, 0.0),
                      child: Text(
                        '通知',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: toggleValue1 ? Colors.blue : Colors.red,
                        ),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 50,
                      transform: Matrix4.translationValues(70.0, 110.0, 0.0),
                      child: Text(
                        '録画',
                        style: TextStyle(
                          fontSize: 20,
                          color: toggleValue2 ? Colors.blue : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  transform: Matrix4.translationValues(0, 80, 0.0),
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
