import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/components/image.dart';
import 'package:flutter_complete_guide/helper/authentication.dart';
import 'package:flutter_complete_guide/models/user_list.dart';
import 'package:flutter_complete_guide/screens/comment_screen.dart';
import 'package:flutter_complete_guide/screens/zefyr_editor.dart';
import 'package:zefyr/zefyr.dart';

class ViewerPage extends StatefulWidget {
  final DocumentSnapshot article;
  final bool isAuthor;
  ViewerPage(this.article, this.isAuthor);
  @override
  State<StatefulWidget> createState() => ViewNote();
}

class ViewNote extends State<ViewerPage> {
  ZefyrController _controller;
  FocusNode _focusNode;
  FirebaseUser _currentUser;
  final obj = Authentication();
  DocumentSnapshot voteStatus;
  bool upStatus = false;
  bool downStatus = false;
  int numberOfUpvotes = -1, numberOfDownvotes = -1;
  List<String> _userUpvoteList, _userDownvoteList;
  final _obj = UserList();

  Future<void> countVotes() async {
    numberOfUpvotes = -1;
    numberOfDownvotes = -1;
    QuerySnapshot _result = await Firestore.instance
        .collection("articles")
        .document(this.widget.article.documentID)
        .collection("votes")
        .getDocuments()
        .then((value) {
      numberOfUpvotes = max(numberOfUpvotes, 0);
      numberOfDownvotes = max(numberOfDownvotes, 0);
      return value;
    });

    _userUpvoteList = List<String>();
    _userDownvoteList = List<String>();

    for (var i in _result.documents) {
      if (i.data["isUp"] == 1) {
        numberOfUpvotes++;
        _userUpvoteList.add(i.documentID);
      }
      if (i.data["isDown"] == 1) {
        numberOfDownvotes++;
        _userDownvoteList.add((i.documentID));
      }
    }
    setState(() {});
  }

  Future<void> setCurrentUser() async {
    FirebaseAuth.instance.currentUser().then((value) {
      _currentUser = value;
      Firestore.instance
          .collection("articles")
          .document(this.widget.article.documentID)
          .collection("votes")
          .document(_currentUser.uid)
          .get()
          .then((value) {
        voteStatus = value;
        if (value.data != null) {
          if (value["isUp"] == 1) {
            setState(() {
              upStatus = true;
              downStatus = false;
            });
          }
          if (value["isDown"] == 1) {
            setState(() {
              upStatus = false;
              downStatus = true;
            });
          }
          if (value["isDown"] == 0 && value["isUp"] == 0 ||
              value.data == null) {
            setState(() {
              downStatus = false;
              upStatus = false;
            });
          }
        }
      });
    });
  }

  Future<void> setVote(Map<String, int> value) async {
    Firestore.instance
        .collection("articles")
        .document(this.widget.article.documentID)
        .collection("votes")
        .document(_currentUser.uid)
        .setData(value)
        .then((value) {
      setState(() {
        setCurrentUser();
        countVotes();
      });
    });
  }

  Future<void> upVotePressed() async {
    Map<String, int> value = {"isUp": -1, "isDown": -1};
    if (voteStatus.data == null ||
        voteStatus.data["isUp"] == 0 && voteStatus.data["isDown"] == 0 ||
        voteStatus.data["isUp"] == 0 && voteStatus.data["isDown"] == 1) {
      value = {"isUp": 1, "isDown": 0};
      upStatus = true;
    } else {
      value = {"isUp": 0, "isDown": 0};
      upStatus = false;
    }
    downStatus = false;
    setVote(value);
  }

  Future<void> downVotePressed() async {
    Map<String, int> value = {"isUp": -1, "isDown": -1};
    if (voteStatus.data == null ||
        voteStatus.data["isUp"] == 0 && voteStatus.data["isDown"] == 0 ||
        voteStatus.data["isUp"] == 1 && voteStatus.data["isDown"] == 0) {
      value = {"isUp": 0, "isDown": 1};
      downStatus = true;
      upStatus = false;
    } else {
      value = {"isUp": 0, "isDown": 0};
      downStatus = false;
      upStatus = false;
    }

    setVote(value);
  }

  void showVotes(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return TabBarView(children: null);
        });
  }

  @override
  Widget build(BuildContext context) {
    print(upStatus);
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton.icon(
                label: Text(
                  numberOfUpvotes == -1
                      ? 'fetching..'
                      : (numberOfUpvotes.toString() +
                          ' Upvote' +
                          (numberOfUpvotes != 1 ? 's' : '')),
                  style: TextStyle(
                    color: numberOfUpvotes == -1
                        ? Colors.grey
                        : (upStatus ? Colors.blue : Colors.black),
                  ),
                ),
                icon: Icon(
                  Icons.thumb_up_alt_outlined,
                  color: (upStatus ? Colors.blue : Colors.black),
                ),
                onPressed: upVotePressed,
                onLongPress: () {
                  _obj.showList(context, _userUpvoteList);
                },
              ),
              FlatButton.icon(
                label: Text(
                  numberOfDownvotes == -1
                      ? 'fetching..'
                      : (numberOfDownvotes.toString() +
                          " Downvote" +
                          (numberOfDownvotes != 1 ? 's' : '')),
                  style: TextStyle(
                    color: numberOfDownvotes == -1
                        ? Colors.grey
                        : (downStatus ? Colors.red : Colors.black),
                  ),
                ),
                icon: Icon(Icons.thumb_down_alt_outlined,
                    color: (downStatus ? Colors.red : Colors.black)),
                onPressed: downVotePressed,
                onLongPress: () {
                  _obj.showList(context, _userDownvoteList);
                },
              ),
              FlatButton.icon(
                label: Text('Comments'),
                icon: Icon(Icons.message),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CommentScreen(widget.article),
                  ));
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(widget.article['title'] == null
            ? "View Note"
            : widget.article['title']),
        actions: [
          if (widget.isAuthor)
            IconButton(
              iconSize: 20,
              icon: Icon(Icons.edit),
              onPressed: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Scaffold(
                  body: EditorPage.edit(widget.article),
                ),
              )),
              color: Colors.grey,
            )
          // : IconButton(icon: Icon(Icons.star), onPressed: () {})
          // : null
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: ZefyrScaffold(
          child: ZefyrEditor(
            padding: EdgeInsets.all(5.0),
            controller: _controller,
            focusNode: _focusNode,
            imageDelegate: CustomImageDelegate(),
            mode: ZefyrMode.view,
          ),
        ),
      ),
    );
    // );
  }

  @override
  void initState() {
    super.initState();
    final document = NotusDocument.fromJson(jsonDecode(widget.article['body']));
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
    setCurrentUser();
    countVotes();
  }
}
