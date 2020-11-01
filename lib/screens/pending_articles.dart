import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/article_card.dart';

class PendingArticlesScreen extends StatefulWidget {
  @override
  _PendingArticlesScreenState createState() => _PendingArticlesScreenState();
}

class _PendingArticlesScreenState extends State<PendingArticlesScreen> {
  Future<List<DocumentSnapshot>> _userfuture;
  List<DocumentSnapshot> _arti;
  List<String> _urls = List<String>();
  FirebaseUser _user;
  var _uid;

  Future<List<DocumentSnapshot>> getArticles() async {
    try {
      _user = await FirebaseAuth.instance.currentUser();
      _uid = _user.uid;
      QuerySnapshot art = await Firestore.instance
          .collection("articles")
          .where('isApproved', isEqualTo: false)
          .getDocuments();
      _arti = art.documents;
      if (art.documents.length == 0) return null;
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
          if (snapshot.hasData && _urls.length > 0) {
            return RefreshIndicator(
              onRefresh: refreshArticles,
              child: snapshot.data == null
                  ? Center(
                      child: GestureDetector(
                          onTap: refreshArticles,
                          child: Text('No articles to read? Tap to refresh')),
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        bool isAuthor = (_uid == _arti[index]["user"]);
                        return ArticleCard(
                          _arti[index],
                          isAuthor,
                          _urls[index],
                          false,
                          true,
                          refresh: refreshArticles,
                        );
                      },
                      itemCount: _arti.length,
                    ),
            );
          } else {
            return Center(child: Text('No approval pending...'));
          }
        });
  }
}
