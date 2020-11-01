import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

class UserTile extends StatelessWidget {
  final _uid;
  UserTile(this._uid);

  DocumentSnapshot _user;

  Future<DocumentSnapshot> getUser() async {
    _user = await Firestore.instance.collection("users").document(_uid).get();
    return _user;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => UserCard(_uid))),
      child: FutureBuilder(
          future: getUser(),
          builder: (context, snap) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5,
                child: ListTile(
                  leading: snap.hasData
                      ? CircleAvatar(
                          backgroundImage:
                              NetworkImage(_user.data["image_url"]),
                        )
                      : CircularProgressIndicator(),
                  title: snap.hasData
                      ? Text(_user.data["fullname"])
                      : Text("Loading...."),
                ),
              ),
            );
          }),
    );
  }
}
