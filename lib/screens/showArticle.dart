import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/components/image.dart';
import 'package:flutter_complete_guide/screens/comment_screen.dart';
import 'package:zefyr/zefyr.dart';

class ViewerPage extends StatefulWidget {
  final DocumentSnapshot article;
  ViewerPage(this.article);
  @override
  State<StatefulWidget> createState() => ViewNote();
}

class ViewNote extends State<ViewerPage> {
  ZefyrController _controller;
  FocusNode _focusNode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlatButton.icon(
              label: Text('Upvote'),
              icon: Icon(Icons.thumb_up_alt_outlined),
              onPressed: () {},
            ),
            FlatButton.icon(
              label: Text("Downvote"),
              icon: Icon(Icons.thumb_down_alt_outlined),
              onPressed: () {},
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
      appBar: AppBar(
        title: Text(widget.article['title'] == null
            ? "View Note"
            : widget.article['title']),
        actions: [IconButton(icon: Icon(Icons.star), onPressed: () {})],
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
  }
}
