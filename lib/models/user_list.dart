import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/user_tile.dart';

class UserList {
  void showList(BuildContext context, List<String> _users) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          if (_users.isEmpty)
            return Center(
              child: Text("No Users to Show"),
            );
          return ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                return UserTile(_users[index]);
              });
        });
  }
}
