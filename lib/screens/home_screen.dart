import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/feed.dart';
import 'package:flutter_complete_guide/screens/zefyr_editor.dart';
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
          if (_index == 1)
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
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text("Feed"),
            backgroundColor: Colors.orange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_sharp),
            title: Text('Profile'),
            backgroundColor: Colors.orange,
          ),
        ],
        currentIndex: _index,
        onTap: (value) {
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
