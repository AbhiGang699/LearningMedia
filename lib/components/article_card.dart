import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget{
  final DocumentSnapshot doc;
  ArticleCard(this.doc);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Card(
          elevation: 10,
          margin: EdgeInsets.all(10),
          child: Text("${doc.data}"),
      ),
    );
  }
}