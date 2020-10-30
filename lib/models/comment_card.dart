import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/comment.dart';
import 'package:flutter_complete_guide/screens/profile.dart';

class CommentCard extends StatefulWidget {
  final DocumentSnapshot comment;
  final bool isAuthor;
  CommentCard(this.comment, this.isAuthor);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  // Future<bool> _isAuthor;
  @override
  void initState() {
    // TODO: implement initState
    // _isAuthor = getAuthor();
    super.initState();
  }

  // Future<bool> getAuthor() async {
  //   var _result = await FirebaseAuth.instance.currentUser();
  //   return _result.uid == widget.comment['uid'];
  // }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Card(
      elevation: 20,
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            trailing: widget.isAuthor
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
=======
    return FutureBuilder(
      future: getAuthor(),
      builder: (context, snap) => snap.hasData
          ? Card(
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
            )
          : CircularProgressIndicator(),
>>>>>>> 5aff5ea494a407c9f9fa95542d1b9f811a29ed3c
    );
  }
}
