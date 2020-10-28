import 'package:flutter/material.dart';

class Article extends StatelessWidget {
  final String id;
  final String text;
  // final String imageUrl;
  // final String videoUrl;
  final String userId;
  final String tag;

  Article({this.id, this.tag, this.text, this.userId});
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: null,
      ),
    );
  }
}
