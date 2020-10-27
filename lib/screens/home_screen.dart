import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './zefyr_editor.dart';
import '../components/searchUsers.dart';
import '../components/feed.dart';
import '../components/profile.dart';

class HomeScreen extends StatefulWidget {
  // final FirebaseUser user;
  // HomeScreen(this.user);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  List<Widget> _body = [
    Center(
      child: Feed(),
    ),
    Center(
      child: ExploreUsers(),
    ),
    Center(
      child: Profile(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: Center(
      //   child: IconButton(
      //     icon: Icon(Icons.exit_to_app_outlined),
      //     onPressed: () {},
      //   ),
      // ),
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
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text('Are you sure to logout?'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Yes'),
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.of(context).pop();
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
          // Text('Dubious'),
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
            icon: Icon(Icons.youtube_searched_for),
            label: "Explore",
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
