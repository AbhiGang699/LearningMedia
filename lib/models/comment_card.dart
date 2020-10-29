import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/comment.dart';
import 'package:flutter_complete_guide/screens/profile.dart';

class CommentCard extends StatefulWidget {
  final DocumentSnapshot comment;
  CommentCard(this.comment);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  Future<bool> _isAuthor;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isAuthor = getAuthor();
  }

  Future<bool> getAuthor() async {
    var _result = await FirebaseAuth.instance.currentUser();
    return _result.uid == widget.comment['uid'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _isAuthor,
      builder: (context, snap) => Card(
        elevation: 20,
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              trailing: snap.data
                  ? IconButton(icon: Icon(Icons.delete), onPressed: () {})
                  : null,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.comment['username'],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.comment['date'],
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                widget.comment["comment"],
                style: TextStyle(
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
