import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/article_card.dart';

class BookMarkScreen extends StatefulWidget {
  @override
  _BookMarkScreenState createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends State<BookMarkScreen> {
  Future<List<DocumentSnapshot>> _bookmarklist;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _bookmarklist,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );

          if (snap.data.length == 0)
            return Center(
              child: Text('No articles bookmarked yet...'),
            );
          return ListView.builder(
            itemBuilder: (context, index) => ArticleCard(
              snap.data[index],
              false,
              snap.data[index][''],
              true,
            ),
            itemCount: snap.data.length,
          );
        });
  }
}
