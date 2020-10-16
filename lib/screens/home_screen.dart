import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      child: Text('Articles'),
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
                FirebaseAuth.instance.signOut();
              },
            ),
          // Text('Dubious'),
          if (_index == 0)
            IconButton(
              icon: Icon(Icons.apps),
              onPressed: () {},
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
