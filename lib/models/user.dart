import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/profile.dart';

class UserCard extends StatelessWidget{
  final String _uid;
  UserCard(this._uid);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User"),centerTitle: true,),
      body: Profile(_uid),
    );
  }
}