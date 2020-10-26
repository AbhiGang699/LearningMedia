import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/tagdropdown.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

// DBHelper helper=DBHelper();
class EditorPage extends StatefulWidget {
  // SavedNotes _savedNotes;
  // EditorPage(this._savedNotes);
  @override
  State<StatefulWidget> createState() => CreateNote();
}

class CreateNote extends State<EditorPage> {
  // SavedNotes _notes;
  // createNote(this._notes);
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

  // NotusDocument _loadDocument(){
  //   if(_notes.id==null) {
  //     final Delta delta = Delta()..insert("Insert text here\n"); //import quill_delta
  //     return NotusDocument.fromDelta(delta);
  //   }
  //   else{
  //     return NotusDocument.fromJson(jsonDecode(_notes.content));
  //   }
  // }

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
                  var result = await Firestore.instance
                      .collection('users').document(user.uid).get();
                  print(result.data);


                  await Firestore.instance
                      .collection('articles')
                      .document(DateTime.now().toString() + user.uid)
                      .setData({
                    'user': user.uid,
                    'body': jsonEncode(_controller.document),
                    'tag': _selectedtag,
                    'username': result.data['username'],
                    'caption': _controller.document.toPlainText().substring(0,20)+'...'
                  });
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
