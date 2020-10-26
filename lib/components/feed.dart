import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/Abhi/AndroidStudioProjects/flutter_learning_app/lib/models/article_card.dart';

class Feed extends StatefulWidget{
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
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
    );
  }
}
