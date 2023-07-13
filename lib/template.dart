import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TextListScreen extends StatelessWidget {
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
    );
  }
}
