import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  final DocumentSnapshot doc;
  final bool isAuthor;
  final url;
  ArticleCard(this.doc, this.isAuthor, this.url);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print("${doc.data["user"]}"),
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
                backgroundImage: NetworkImage(url),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doc.data["username"],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${doc.data["date"]}",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              trailing: isAuthor
                  ? IconButton(
                      iconSize: 20,
                      icon: Icon(Icons.edit),
                      onPressed: () => print("edit"),
                      color: Colors.grey,
                    )
                  : null,
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                doc.data["caption"],
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.left,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "tag : ${doc.data["tag"]}",
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
