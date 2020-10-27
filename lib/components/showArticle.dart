import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowArticle extends StatefulWidget {
  final DocumentSnapshot doc;
  final bool isAuthor;
  final url;
  ShowArticle(this.doc, this.isAuthor, this.url);

  @override
  _ShowArticleState createState() => _ShowArticleState();
}

class _ShowArticleState extends State<ShowArticle> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explore "),
      ),
      body: Card(
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.url),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.doc.data["username"],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${widget.doc.data["date"]}",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              trailing: widget.isAuthor
                  ? IconButton(
                      iconSize: 20,
                      icon: Icon(Icons.edit),
                      onPressed: () => print("edit"),
                      color: Colors.grey,
                    )
                  : IconButton(
                iconSize: 20,
                icon: _isPressed
                    ? Icon(Icons.star)
                    : Icon(Icons.star_border),
                onPressed: () {
                  print("bookmarked");
                  setState(() {
                    _isPressed=!_isPressed;
                  });
                },
                color: Colors.grey,
              ),
            ),
            Text(widget.doc.data["body"]),
          ],
        ),
      ),
    );
  }
}
