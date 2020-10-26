import 'package:cloud_firestore/cloud_firestore.dart';
<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Feed extends StatefulWidget {
=======
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/components/article_card.dart';

class Feed extends StatefulWidget{
>>>>>>> 50474cb132c834acdbf5cc1fb450d8f2c8e6633b
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
<<<<<<< HEAD
  @override
  Widget build(BuildContext context) {
    Firestore.instance.collection('articles').getDocuments().then((value) {
      var v = value.documents;
      for (int i = 0; i < v.length; i++) print(v[i]['tag']);
    });
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.sort),
      // ),
      body: null,
=======
  bool _isLoading=true;
  List<DocumentSnapshot> _arti;

  Future<List<DocumentSnapshot>> getArticles () async{
    try{
      QuerySnapshot art = await Firestore.instance.collection("articles").getDocuments();
      _arti= art.documents;
      print(_arti[0].data);
      return _arti;
    }
    catch(e){
      print("sorry couldn't fetch data");
      return null;
    }
  }

  @override
  Widget build(BuildContext context){
    getArticles();
    return FutureBuilder(
        future: getArticles(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return ListView.builder(
              itemBuilder :(context,index){
                return ArticleCard(_arti[index]);
              },
              itemCount: _arti.length,
            );
          }
          else{
            return Center(child: CircularProgressIndicator());
          }
        }
>>>>>>> 50474cb132c834acdbf5cc1fb450d8f2c8e6633b
    );
  }
}
