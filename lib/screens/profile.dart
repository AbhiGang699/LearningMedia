import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_complete_guide/helper/authentication.dart';
import 'package:flutter_complete_guide/models/article_card.dart';
import 'package:flutter_complete_guide/models/user_tile.dart';

class Profile extends StatefulWidget {
  final String uid;

  Profile(this.uid);
  @override
  _ProfileState createState() => _ProfileState(uid);
}

class _ProfileState extends State<Profile> {
  final String _uid;
  _ProfileState(this._uid);
  final obj = Authentication();
  String name = '';
  String url = '';
  bool _isCurrent = false;
  bool doesFollow = false;

  var _len = 0;
  List<DocumentSnapshot> _arti, _followers;
  bool isloading = true;

  DocumentSnapshot following, _doc, _followerDoc;

  Future<DocumentSnapshot> getFollowingCurrent() async {
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
      getFollowingCurrent().then((value) {
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
      getFollowingCurrent().then((value) {
        setState(() {
          doesFollow = false;
        });
      });
    });
  }

  Future<List<DocumentSnapshot>> getArticles() async {
    try {
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

  Future<DocumentSnapshot> getFollowingHelper() async {
    _doc = await Firestore.instance.collection("follow").document(_uid).get();
    return _doc;
  }

  Future<List<DocumentSnapshot>> getFollowersHelper() async {
    _followers = (await Firestore.instance.collection("follow").getDocuments())
        .documents;
    return _followers;
  }

  void getFollowing(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return FutureBuilder(
              future: getFollowingHelper(),
              builder: (context, snap) {
                if (snap.hasData) print(_doc.data);
                return snap.hasData
                    ? (_doc.data == null || _doc.data.length == 0
                        ? Center(
                            child: Text("No users to show"),
                          )
                        : ListView.builder(
                            itemCount: _doc.data.length,
                            itemBuilder: (context, index) {
                              List<String> followingList = List<String>();
                              for (var i in _doc.data.keys)
                                followingList.add(i);
                              return UserTile(followingList[index]);
                            }))
                    : Center(child: CircularProgressIndicator());
              });
        });
  }

  void getFollowers(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return FutureBuilder(
              future: getFollowersHelper(),
              builder: (context, snap) {
                List<String> followerList = List<String>();
                if (snap.hasData) {
                  for (var i in _followers) {
                    for (var j in i.data.keys) {
                      if (j == _uid) followerList.add(i.documentID);
                    }
                  }
                }
                return snap.hasData
                    ? (followerList.length == 0 || _followers == null)
                        ? Center(
                            child: Text("No users to Show"),
                          )
                        : ListView.builder(
                            itemCount: followerList.length,
                            itemBuilder: (context, index) {
                              return UserTile(followerList[index]);
                            })
                    : Center(child: CircularProgressIndicator());
              });
        });
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
                            future: getFollowingCurrent(),
                            builder: (context, snap) {
                              if (snap.hasData) {
                                if (following.data != null)
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
                          getFollowers(context);
                        },
                        child: Text("Followers"),
                      ),
                      RaisedButton(
                        child: Text("Following"),
                        onPressed: () {
                          getFollowing(context);
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
