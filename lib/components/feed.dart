import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    Firestore.instance.collection('articles').getDocuments().then((value) {
      var v = value.documents;
      for (int i = 0; i < v.length; i++) print(v[i]['tag']);
    });
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.sort),
      // ),
      body: null,
    );
  }
}
