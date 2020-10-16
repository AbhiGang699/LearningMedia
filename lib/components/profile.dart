import 'package:flutter/material.dart';
// import '../screens/login_screen.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = 'name';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.black,
              ),
              Text(name),
            ],
          ),
          Expanded(
            child: Center(
              child: Text('Articles'),
            ),
          ),
        ],
      ),
    );
  }
}
