import 'dart:io';

import 'package:flutter/material.dart';

class UserImageInput extends StatefulWidget {
  final Function _selectImage;
  final File _storedImage;
  UserImageInput(this._selectImage, this._storedImage);
  @override
  _UserImageInputState createState() => _UserImageInputState();
}

class _UserImageInputState extends State<UserImageInput> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget._selectImage,
      child: CircleAvatar(
        radius: 60,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Theme.of(context).accentColor),
          width: 100,
          height: 100,
          child: widget._storedImage == null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    'Tap on me to select image',
                    textAlign: TextAlign.center,
                  )),
                )
              : ClipRRect(
                  child: Image.file(
                    widget._storedImage,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(60),
                ),
        ),
      ),
    );
  }
}
