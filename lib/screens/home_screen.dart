import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/add_article.dart';
import '../components/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  static List<DocumentSnapshot> _doc;
  FirebaseUser user;
  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    user = await FirebaseAuth.instance.currentUser();
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('email', isEqualTo: user.email)
        .getDocuments();
    _doc = result.documents;
  }

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
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddArticle(),
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
