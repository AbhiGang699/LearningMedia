import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './user_tile.dart';

List<DocumentSnapshot> _followers;

class ShowFollowers {
  final String _uid;
  ShowFollowers(this._uid);
  Future<List<DocumentSnapshot>> getFollowersHelper() async {
    _followers = (await Firestore.instance.collection("follow").getDocuments())
        .documents;
    return _followers;
  }

  void getFollowers(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return FutureBuilder(
              future: getFollowersHelper(),
              builder: (context, snap) {
                List<String> followerList = List<String>();
                if (snap.hasData) {
                  for (var i in _followers) {
                    for (var j in i.data.keys) {
                      if (j == _uid) followerList.add(i.documentID);
                    }
                  }
                }
                return snap.hasData
                    ? (followerList.length == 0 || _followers == null)
                        ? Center(
                            child: Text("No users to Show"),
                          )
                        : ListView.builder(
                            itemCount: followerList.length,
                            itemBuilder: (context, index) {
                              return UserTile(followerList[index]);
                            })
                    : Center(child: CircularProgressIndicator());
              });
        });
  }
}
