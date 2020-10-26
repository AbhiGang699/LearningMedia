import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = '';

  String url = '';

  bool isloading = true;

  @override
  Widget build(BuildContext context) {
    if (isloading)
      FirebaseAuth.instance.currentUser().then((user) {
        Firestore.instance
            .collection('users')
            .where('email', isEqualTo: user.email)
            .getDocuments()
            .then((value) {
          List<DocumentSnapshot> docu = value.documents;
          url = docu[0]['image_url'];
          name = docu[0]['fullname'];
          print(url);
          print(name);
          setState(() {
            isloading = false;
          });
        });
      });
    return isloading
        ? Center(child: CircularProgressIndicator())
        : Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(url),
                      backgroundColor: Colors.black,
                    ),
                    Text(name),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Text('Articles'),
                  ),
                ),
              ],
            ),
          );
  }
}
