import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text List'),
      ),
      body: Container(
        width: 320.0,
        height: 300.0,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10.0),
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
    );
  }
}
