import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatefulWidget {
  final String id;
  final DocumentSnapshot comment;
  final bool isAuthor;
  final Function refresh;
  CommentCard(this.id, this.comment, this.isAuthor, this.refresh);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  // Future<bool> _isAuthor;
  bool _isProcessing = false;
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
  Future<void> deleteComment() async {
    await Firestore.instance
        .collection('articles')
        .document(widget.id)
        .collection('comments')
        .document(widget.comment.documentID)
        .delete();
    Navigator.of(context).pop();
    widget.refresh();
  }

  Future<void> delete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm??'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this comment?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.delete_forever),
              label: Text('Delete'),
              onPressed: deleteComment,
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            trailing: widget.isAuthor
                ? IconButton(icon: Icon(Icons.delete), onPressed: delete)
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
    );
  }
}
