import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../components/showArticle.dart';

class ArticleCard extends StatefulWidget {
  final DocumentSnapshot doc;
  final bool isAuthor;
  final url;

  ArticleCard(this.doc, this.isAuthor, this.url);

  @override
  _ArticleCardState createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ShowArticle(this.widget.doc,this.widget.isAuthor, this.widget.url),
          ),
        );
      },
      child: Card(
        elevation: 10,
        shadowColor: Colors.grey,
        color: Colors.white,
        margin: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(this.widget.url),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    this.widget.doc.data["username"],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${this.widget.doc.data["date"]}",
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
                      onPressed: () => print("edit"),
                      color: Colors.grey,
                    )
                  :  IconButton(
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
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                this.widget.doc.data["caption"],
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.left,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "tag : ${this.widget.doc.data["tag"]}",
                  style: TextStyle(fontSize: 10),
                ),
                SizedBox(
                  width: 5,
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
