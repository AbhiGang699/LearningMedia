import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/bookmark_screen.dart';

import './zefyr_editor.dart';
import 'feed.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  String _uid;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((value) => _uid = value.uid);
    List<Widget> _body = [
      Center(
        child: Feed(),
      ),
      Center(
        child: BookmarkScreen(),
      ),
      Center(
        child: Profile(_uid),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (_index == 2)
            IconButton(
              icon: Icon(Icons.exit_to_app_sharp),
              onPressed: () {
                return showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Logging Out?'),
                      content: Text('Are you sure to logout?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Yes'),
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                          },
                        ),
                        TextButton(
                          child: Text('No'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          if (_index == 0)
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
          if (_index == 0)
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditorPage(),
                  ),
                );
              },
            ),
        ],
        centerTitle: true,
        elevation: 20,
        title: Text('Dubious'),
      ),
      body: _body[_index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        unselectedIconTheme: IconThemeData(color: Colors.black45),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Feed",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_half),
            label: "Bookmarks",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: "Profile",
            backgroundColor: Colors.blue,
          ),
        ],
        currentIndex: _index,
        onTap: (value) {
          print(value);
          setState(() {
            _index = value;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
