import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/user.dart';
import 'package:flutter_complete_guide/screens/zefyr_editor.dart';
import '../screens/showArticle.dart';

class ArticleCard extends StatefulWidget {
  final DocumentSnapshot doc;
  final bool isAuthor;
  final url;
  final bool canTap;
  final bool isAdmin; //true if the user profile should show on tap else false
  final Function refresh;
  ArticleCard(this.doc, this.isAuthor, this.url, this.canTap, this.isAdmin,
      {this.refresh});

  @override
  _ArticleCardState createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  Future<bool> _isPressed;
  FirebaseUser _user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isPressed = check(widget.doc.documentID);
  }

  Future<bool> check(String id) async {
    _user = await FirebaseAuth.instance.currentUser();
    var res = await Firestore.instance
        .collection('users')
        .document(_user.uid)
        .collection('bookmark')
        .document(id)
        .get();
    // print(res.data);
    if (res.data == null) return false;

    return true;
  }

  Future<void> refreshcard() async {
    setState(() {
      _isPressed = check(widget.doc.documentID);
    });
  }

  Future<void> action(String id, bool marked) async {
    print(marked ? 'unmark' : 'mark');
    !marked
        ? await Firestore.instance
            .collection('users')
            .document(_user.uid)
            .collection('bookmark')
            .document(id)
            .setData({'bookmark': id})
        : await Firestore.instance
            .collection('users')
            .document(_user.uid)
            .collection('bookmark')
            .document(id)
            .delete();
    refreshcard();
  }

  Future<void> approve() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm?'),
            content: Text('Are you sure to approve this article?'),
            actions: <Widget>[
              TextButton(
                child: Text('Approve'),
                onPressed: () async {
                  await Firestore.instance
                      .collection('articles')
                      .document(widget.doc.documentID)
                      .updateData({'isApproved': true});

                  Navigator.of(context).pop();
                  widget.refresh();
                },
              ),
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<void> deletePost() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm?'),
            content: Text('Are you sure to delete this article?'),
            actions: <Widget>[
              TextButton(
                child: Text('Delete'),
                onPressed: () async {
                  await Firestore.instance
                      .collection('articles')
                      .document(widget.doc.documentID)
                      .delete();

                  Navigator.of(context).pop();
                  widget.refresh();
                },
              ),
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: Colors.grey,
      color: Colors.white,
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ViewerPage(this.widget.doc, this.widget.isAuthor))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            this.widget.doc.data["title"],
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${this.widget.doc.data["date"]}  ${this.widget.doc.data['tag']} ",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (this.widget.isAdmin || this.widget.isAuthor)
                      IconButton(
                        icon: Icon(Icons.delete_forever),
                        onPressed: deletePost,
                      ),
                    if (this.widget.isAdmin &&
                        (this.widget.doc['isApproved'] == false ||
                            this.widget.doc['isApproved'] == null))
                      IconButton(
                        icon: Icon(Icons.check_circle_outline),
                        onPressed: approve,
                      ),
                  ],
                ),
                trailing: this.widget.isAuthor || this.widget.isAdmin
                    ? IconButton(
                        iconSize: 20,
                        icon: Icon(Icons.edit),
                        onPressed: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Scaffold(
                            body: EditorPage.edit(widget.doc),
                          ),
                        )),
                        color: Colors.black,
                      )
                    : FutureBuilder(
                        future: _isPressed,
                        builder: (context, snap) {
                          if (snap.connectionState == ConnectionState.waiting)
                            return SizedBox(child: CircularProgressIndicator());

                          return IconButton(
                            iconSize: 20,
                            icon: snap.data
                                ? Icon(Icons.star)
                                : Icon(Icons.star_border),
                            onPressed: () =>
                                action(widget.doc.documentID, snap.data),
                            color: Colors.black,
                          );
                        },
                      ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  this.widget.doc.data["caption"],
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.left,
                ),
              ),
            ]),
          ),
          Divider(
            thickness: 2,
            indent: 15,
            endIndent: 15,
          ),
          GestureDetector(
            onTap: this.widget.canTap
                ? () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        UserCard(this.widget.doc.data["user"])))
                : null,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: widget.doc.data['isApproved']
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.spaceBetween,
                children: [
                  if (!widget.doc.data['isApproved']) Text('Pending'),
                  SizedBox(
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundImage: NetworkImage(this.widget.url),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${this.widget.doc.data["username"]}",
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(
                      width: 5,
                    )
                  ]))
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
