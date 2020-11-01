import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/article_card.dart';

class BookmarkScreen extends StatefulWidget {
  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  Future<List<DocumentSnapshot>> _bookmark;
  List<String> _urls = List<String>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bookmark = getBookmark();
  }

  Future<List<DocumentSnapshot>> getBookmark() async {
    List<DocumentSnapshot> _arti = List<DocumentSnapshot>();
    var _user = await FirebaseAuth.instance.currentUser();

    var result = await Firestore.instance
        .collection('users')
        .document(_user.uid)
        .collection('bookmark')
        .getDocuments();

    var bookmarklist = result.documents;
    for (var i in bookmarklist) {
      var fetch = await Firestore.instance
          .collection('articles')
          .document(i.documentID)
          .get();
      _arti.add(fetch);
    }
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _bookmark,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data.length == 0
              ? Center(
                  child: GestureDetector(
                      // onTap: refreshArticles,
                      child: Text('No articles bookmarked yet')),
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return ArticleCard(
                        snapshot.data[index], false, _urls[index], true);
                  },
                  itemCount: snapshot.data.length,
                );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
