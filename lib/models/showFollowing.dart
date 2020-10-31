import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './user_tile.dart';

class ShowFollowing {
  final _uid;
  ShowFollowing(this._uid);

  DocumentSnapshot _doc;

  Future<DocumentSnapshot> getFollowingHelper() async {
    _doc = await Firestore.instance.collection("follow").document(_uid).get();
    return _doc;
  }

  void getFollowing(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return FutureBuilder(
              future: getFollowingHelper(),
              builder: (context, snap) {
                if (snap.hasData) print(_doc.data);
                return snap.hasData
                    ? (_doc.data == null || _doc.data.length == 0
                        ? Center(
                            child: Text("No users to show"),
                          )
                        : ListView.builder(
                            itemCount: _doc.data.length,
                            itemBuilder: (context, index) {
                              List<String> followingList = List<String>();
                              for (var i in _doc.data.keys)
                                followingList.add(i);
                              return UserTile(followingList[index]);
                            }))
                    : Center(child: CircularProgressIndicator());
              });
        });
  }
}
