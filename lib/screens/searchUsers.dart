import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExploreUsers extends StatefulWidget {
  @override
  _ExploreUsersState createState() => _ExploreUsersState();
}

class _ExploreUsersState extends State<ExploreUsers> {
  List<DocumentSnapshot> _users;

  Future<List<DocumentSnapshot>> getUsers() async {
    QuerySnapshot result =
        await Firestore.instance.collection("users").getDocuments();
    _users = result.documents;
    final FirebaseUser _cu = await FirebaseAuth.instance.currentUser();
    final String _c = _cu.email;
    for (int i = 0; i < _users.length; i++) {
      if (_users[i].data["email"] == _c) {
        _users.removeAt(i);
        break;
      }
    }
    return _users;
  }

  @override
  Widget build(BuildContext context) {
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
                        trailing: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.add_circle_outline),
                          label: Text("Follow"),
                          color: Colors.green,
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
