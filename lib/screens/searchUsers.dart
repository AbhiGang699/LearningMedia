import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/authentication.dart';
import 'package:flutter_complete_guide/components/follow_botton.dart';

class ExploreUsers extends StatefulWidget {
  @override
  _ExploreUsersState createState() => _ExploreUsersState();
}

class _ExploreUsersState extends State<ExploreUsers> {
  List<DocumentSnapshot> _users;
  List<bool> follow = List<bool>();
  final obj = new Authentication();
  FirebaseUser _cu;

  Future<List<DocumentSnapshot>> getUsers() async {
    QuerySnapshot result =
        await Firestore.instance.collection("users").getDocuments();
    _users = result.documents;
    _cu = await FirebaseAuth.instance.currentUser();
    final String _c = _cu.email;
    for (int i = 0; i < _users.length; i++) {
      if (_users[i].data["email"] == _c) {
        _users.removeAt(i);
        break;
      }
    }
    for (int i = 0; i < _users.length; i++) {
      if (await obj.doesFollow(_users[i].data["email"], _cu.email) == true) {
        follow.add(true);
      } else {
        follow.add(false);
      }
    }
    return _users;
  }

  @override
  Widget build(BuildContext context) {
    getUsers();
    return FutureBuilder(
        future: getUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return Container(
              child: ListView.builder(
                  //shrinkWrap: true,
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(_users[index].data["image_url"]),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _users[index].data["fullname"],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _users[index].data["username"],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "${_users[index].data["followers"]} followers",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        trailing: follow[index]
                            ? Text("Un follow")
                            : GestureDetector(
                                child: Follow(_users[index].data["email"],_cu.email),
                                onTap: () {
                                  setState(() {
                                    getUsers();
                                    follow[index]=true;
                                  });
                                },
                              ),
                      ),
                    );
                  }),
            );
          else
            return CircularProgressIndicator();
        });
  }
}
