import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExploreUsers extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Card(
            child: Text("Users you may know !"),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Text(index.toString());
              },
              itemCount: 1000,
            ),
          ),
        ],
      ),
    );
  }
}
