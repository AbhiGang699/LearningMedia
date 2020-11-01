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
  final bool canTap; //true if the user profile should show on tap else false

  ArticleCard(this.doc, this.isAuthor, this.url, this.canTap);

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

  Future<void> refresh() async {
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
    refresh();
  }

  Future<void> unmark(id) async {
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _isPressed,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting)
          return Center(
            child: Text(""),
          );

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
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Column(
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
                        trailing: this.widget.isAuthor
                            ? IconButton(
                                iconSize: 20,
                                icon: Icon(Icons.edit),
                                onPressed: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) => Scaffold(
                                    body: EditorPage.edit(widget.doc),
                                  ),
                                )),
                                color: Colors.grey,
                              )
                            : IconButton(
                                iconSize: 20,
                                icon: snap.data
                                    ? Icon(Icons.star)
                                    : Icon(Icons.star_border),
                                onPressed: () =>
                                    action(widget.doc.documentID, snap.data),
                                color: Colors.black,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        );
      },
    );
  }
}
