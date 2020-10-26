import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/Abhi/AndroidStudioProjects/flutter_learning_app/lib/models/article_card.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  bool _isLoading = true;
  List<DocumentSnapshot> _arti;
  var _len=0;

  Future<List<DocumentSnapshot>> getArticles() async {
    try {
      QuerySnapshot art = await Firestore.instance.collection("articles").getDocuments();
      _arti = art.documents;
      if(_len<_arti.length){
        _len=_arti.length;
        setState(() {
        });
      }
      return _arti;
    } catch (e) {
      print("sorry couldn't fetch data");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getArticles,
      child: FutureBuilder(
          future: getArticles(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return ArticleCard(_arti[index]);
                },
                itemCount: _arti.length,
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
