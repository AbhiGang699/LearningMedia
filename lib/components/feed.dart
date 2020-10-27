import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'article_card.dart';
import 'package:intl/intl.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  List<DocumentSnapshot> _arti;
  List<String> _urls = List<String>();
  var _uid;
  var _len = 0;

  Future<List<DocumentSnapshot>> getArticles() async {
    try {
      final FirebaseUser _user = await FirebaseAuth.instance.currentUser();
      _uid = _user.uid;
      QuerySnapshot art =
          await Firestore.instance.collection("articles").getDocuments();
      _arti = art.documents;
      _urls.clear();
      for (int i = 0; i < _arti.length; i++) {
        String id = _arti[i].data["user"];
        DocumentSnapshot result =
            await Firestore.instance.collection("users").document(id).get();
        var temp = result.data["image_url"];
        _urls.add(temp.toString());
      }
      if (_len < _arti.length) {
        _len = _arti.length;
        setState(() {});
      }
    } catch (e) {
      print("sorry couldn't fetch data");
      print(e);
    }
    return _arti;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getArticles(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: getArticles,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  bool isAuthor = (_uid == _arti[index]["user"]);
                  return ArticleCard(_arti[index], isAuthor, _urls[index]);
                },
                itemCount: _arti.length,
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
