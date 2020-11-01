import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/admin_screen.dart';
import 'package:flutter_complete_guide/screens/home_screen.dart';

class RedirectScreen extends StatefulWidget {
  @override
  _RedirectScreenState createState() => _RedirectScreenState();
}

class _RedirectScreenState extends State<RedirectScreen> {
  Future<bool> _isAdmin;

  Future<bool> checkadmin() async {
    var user = await FirebaseAuth.instance.currentUser();
    var fetch =
        await Firestore.instance.collection('admin').document(user.email).get();
    if (fetch.data == null) return false;
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isAdmin = checkadmin();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _isAdmin,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
                Text('Redirecting'),
              ],
            ),
          );

        if (snapshot.data) return AdminScreen();
        return HomeScreen();
      },
    );
  }
}
