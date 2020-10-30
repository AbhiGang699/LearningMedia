import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/comment_card.dart';
import 'package:intl/intl.dart';

class CommentScreen extends StatefulWidget {
  final DocumentSnapshot article;
  CommentScreen(this.article);
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  FocusNode _focus;
  Future<String> _user;
  Future<List<DocumentSnapshot>> _userfuture;
  @override
  void initState() {
    // TODO: implement initState
    _user = getUser();
    super.initState();
    _focus = FocusNode();
    _userfuture = getComments();
  }

  Future<String> getUser() async {
    var user = await FirebaseAuth.instance.currentUser();
    print("uid:" + user.uid);
    return user.uid;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _focus.dispose();
    super.dispose();
  }

  var _comment = TextEditingController();
  bool isPosting = false;
  bool isLoaded = false;

  Future<void> post() async {
    setState(() {
      isPosting = true;
    });
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot _userdetails =
        await Firestore.instance.collection('users').document(_user.uid).get();
    await Firestore.instance
        .collection('articles')
        .document(widget.article.documentID)
        .collection('comments')
        .document()
        .setData({
      'comment': _comment.text,
      'time': DateTime.now().toString(),
      'date': DateFormat.yMMMMd('en_US').format(DateTime.now()).toString(),
      'uid': _user.uid,
      'username': _userdetails['username'],
    });
    if (_focus.hasFocus) _focus.unfocus();
    _comment.clear();
    setState(() {
      isPosting = false;
    });
    refresh();
  }

  Future<List<DocumentSnapshot>> getComments() async {
    if (!isLoaded) {
      var fetch = await Firestore.instance
          .collection('articles')
          .document(widget.article.documentID)
          .collection('comments')
          .getDocuments();
      comments = fetch.documents;
      if (comments != null)
        comments.sort((a, b) {
          return a['time'].compareTo(b['time']);
        });
      comments = new List.from(comments.reversed);
    }
    return comments;
  }

  Future<List<DocumentSnapshot>> refresh() {
    setState(() {
      _userfuture = getComments();
    });
    return _userfuture;
  }

  List<DocumentSnapshot> comments;
  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: BottomAppBar(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    focusNode: _focus,
                    controller: _comment,
                    decoration: InputDecoration(labelText: 'Write your views'),
                  ),
                ),
              ),
              isPosting
                  ? CircularProgressIndicator()
                  : FlatButton(
                      onPressed: post,
                      child: Text("Post"),
                    ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: FutureBuilder(
            future: _userfuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              if (comments == null)
                return Center(
                  child: Text("No comments yet..."),
                );
              return Container(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    kBottomNavigationBarHeight -
                    kToolbarHeight,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    print(comments[index]['uid']);
                    return CommentCard(
                        comments[index], comments[index]['uid'] == _user);
                  },
                  itemCount: comments.length,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
