 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Follow extends StatelessWidget {
  final celeb,fan;
  Follow(this.celeb,this.fan);

  Future<void> func() async {
    final FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    final fan = _user.email;
    await Firestore.instance.collection("follow").add({'celeb':celeb,'fan':fan});
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
        onPressed: func,
        icon: Icon(Icons.add_circle_outline),
        label: Text("Follow"));
  }
}
