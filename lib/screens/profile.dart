import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_complete_guide/helper/authentication.dart';
import 'package:flutter_complete_guide/models/article_card.dart';

class Profile extends StatefulWidget {
  final String uid;
  final obj = Authentication();
  Profile(this.uid);
  @override
  _ProfileState createState() => _ProfileState(uid);
}

class _ProfileState extends State<Profile> {
  final String _uid;
  _ProfileState(this._uid);
  String name = '';
  String url = '';
  bool _isCurrent = false;
  bool doesFollow = false;

  var _len = 0;
  List<DocumentSnapshot> _arti, followers;
  bool isloading = true;

  DocumentSnapshot following;
  Future<DocumentSnapshot> getFollowing() async {
    FirebaseUser us = await FirebaseAuth.instance.currentUser();
    following =
        await Firestore.instance.collection("follow").document(us.uid).get();
    return following;
  }

  Future<void> addFollower() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection("follow")
        .document(_user.uid)
        .setData({_uid: _uid}, merge: true).whenComplete(() {
      getFollowing().then((value) {
        setState(() {
          doesFollow = false;
        });
      });
    });
  }

  Future<void> removeFollower() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection("follow")
        .document(_user.uid)
        .updateData({_uid: FieldValue.delete()}).whenComplete(() {
      getFollowing().then((value) {
        setState(() {
          doesFollow = false;
        });
      });
    });
  }

  Future<List<DocumentSnapshot>> getArticles() async {
    try {
      final FirebaseUser _user = await FirebaseAuth.instance.currentUser();

      QuerySnapshot art = await Firestore.instance
          .collection("articles")
          .where('user', isEqualTo: _uid)
          .getDocuments();
      _arti = art.documents;

      if (_len != _arti.length) {
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
    if (isloading) {
      FirebaseAuth.instance.currentUser().then((user) {
        Firestore.instance
            .collection('users')
            .document(_uid)
            .get()
            .then((docu) {
          _isCurrent = _uid == user.uid ? true : false;
          url = docu['image_url'];
          name = docu['fullname'];
          setState(() {
            isloading = false;
          });
        });
      });
    }
    FirebaseAuth.instance.currentUser().then((value) => print(value.uid));
    return isloading
        ? Center(child: CircularProgressIndicator())
        : Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                FittedBox(
                  //make this into a fitted box later
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(url),
                        backgroundColor: Colors.black,
                      ),
                      Text(
                        name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      if (_isCurrent == false)
                        FutureBuilder(
                            future: getFollowing(),
                            builder: (context, snap) {
                              if (snap.hasData) {
                                for (var i in following.data.keys) {
                                  if (i == _uid) doesFollow = true;
                                }
                              }
                              return snap.hasData
                                  ? doesFollow
                                      ? FlatButton(
                                          onPressed: () {
                                            removeFollower();
                                          },
                                          child: Text("Unfollow"))
                                      : FlatButton(
                                          onPressed: () {
                                            addFollower();
                                          },
                                          child: Text("Follow"))
                                  : CircularProgressIndicator();
                            }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        onPressed: () {
                          print("fol");
                        },
                        child: Text("Followers"),
                      ),
                      RaisedButton(
                        child: Text("Following"),
                        onPressed: () {
                          print("fol");
                        },
                      )
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                  indent: 15,
                  endIndent: 15,
                  height: 20,
                ),
                Expanded(
                  child: Center(
                    child: FutureBuilder(
                        future: getArticles(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return RefreshIndicator(
                              onRefresh: getArticles,
                              child: _arti.length == 0
                                  ? Center(child: Text("No Articles to Show "))
                                  : ListView.builder(
                                      itemBuilder: (context, index) {
                                        return ArticleCard(_arti[index],
                                            _isCurrent, url, false);
                                      },
                                      itemCount: _arti.length,
                                    ),
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }),
                  ),
                ),
              ],
            ),
          );
  }
}
