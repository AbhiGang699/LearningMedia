import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/components/image.dart';
import '../components/tagdropdown.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class EditorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CreateNote();
}

class CreateNote extends State<EditorPage> {
  String _selectedtag = 'Technology';
  void setTag(String value) {
    setState(() {
      _selectedtag = value;
      print(_selectedtag);
    });
  }

  ZefyrController _controller;
  FocusNode _focusNode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Note"),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: save)],
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: ZefyrScaffold(
          child: ZefyrEditor(
            padding: EdgeInsets.all(5.0),
            controller: _controller,
            focusNode: _focusNode,
            imageDelegate: CustomImageDelegate(),
          ),
        ),
      ),
    );
    // );
  }

  @override
  void initState() {
    super.initState();
    final document =
        NotusDocument.fromDelta(Delta()..insert("Insert text here\n"));
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }

  Future<void> save() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select Tag for the article'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TagDropDownMenu(setTag),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Post'),
                onPressed: () async {
                  FirebaseUser user = await FirebaseAuth.instance.currentUser();
                  await Firestore.instance
                      .collection('articles')
                      .document(DateTime.now().toString() + user.uid)
                      .setData({
                    'user': user.uid,
                    'body': jsonEncode(_controller.document),
                    'tag': _selectedtag
                  });
                  print(jsonEncode(_controller.document.toPlainText()));
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Get Back to Editing'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
