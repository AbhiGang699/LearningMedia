import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/article_card.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  Future<List<DocumentSnapshot>> _userfuture;
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

      if (_len != _arti.length) {
        _len = _arti.length;
        setState(() {});
      }
    } catch (e) {
      print("sorry couldn't fetch data");
      print(e);
    }
    _arti.sort((a, b) => a['time'].compareTo(b['time']));
    _arti = new List.from(_arti.reversed);
    _urls.clear();
    for (int i = 0; i < _arti.length; i++) {
      String id = _arti[i].data["user"];
      DocumentSnapshot result =
      await Firestore.instance.collection("users").document(id).get();
      var temp = result.data["image_url"];
      _urls.add(temp.toString());
    }
    return _arti;
  }

  Future<List<DocumentSnapshot>> refreshArticles() async {
    setState(() {
      _userfuture = getArticles();
    });
    return _userfuture;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userfuture = getArticles();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _userfuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: refreshArticles,
              child: snapshot.data.length == 0
                  ? Center(
                      child: GestureDetector(
                          onTap: refreshArticles,
                          child: Text('No articles to read? Tap to refresh')),
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        bool isAuthor = (_uid == _arti[index]["user"]);
                        return ArticleCard(
                            _arti[index], isAuthor, _urls[index],true);
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
