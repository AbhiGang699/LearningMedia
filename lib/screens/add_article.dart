import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/components/image_input.dart';
import 'package:image_picker/image_picker.dart';

class AddArticle extends StatefulWidget {
  @override
  _AddArticleState createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {
  File _storedImage;
  void _selectImage() async {
    showModalBottomSheet(
        // shape: ShapeBorderClipper(),
        context: context,
        builder: (_) {
          return Container(
            height: 100,
            child: Center(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton.icon(
                      onPressed: () async {
                        final _picker = ImagePicker();
                        final _picked = await _picker.getImage(
                            source: ImageSource.camera, imageQuality: 50);
                        if (File(_picked.path) == null) return null;

                        setState(() {
                          _storedImage = File(_picked.path);
                        });
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.camera,
                        // size: 70,
                      ),
                      label: Text('Camera'),
                    ),
                    FlatButton.icon(
                      onPressed: () async {
                        final _picker = ImagePicker();
                        final _picked = await _picker.getImage(
                            source: ImageSource.gallery, imageQuality: 50);
                        if (_picked == null) return null;

                        setState(() {
                          _storedImage = File(_picked.path);
                        });
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.add_photo_alternate,
                        // size: 70,
                      ),
                      // splashColor: Colors.red,
                      label: Text('Gallery'),
                    ),
                  ],
                ),
              ),
            ),
            // behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create new article'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              UserImageInput(_selectImage, _storedImage),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Body'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
