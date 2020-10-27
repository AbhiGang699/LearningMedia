import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'article_card.dart';
import 'package:intl/intl.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
<<<<<<< HEAD
  bool _isLoading = true;
=======
>>>>>>> a3e951b2c7111be9bc4446d273b156954928b57c
  List<DocumentSnapshot> _arti;
  List<String> _urls = List<String>();
  var _uid;
  var _len = 0;

<<<<<<< HEAD
  Future<List<DocumentSnapshot>> getArticles(BuildContext context) async {
    try {
      QuerySnapshot art =
          await Firestore.instance.collection("articles").getDocuments();
      _arti = art.documents;
      print(_arti[0].data);
      return _arti;
=======
  Future<List<DocumentSnapshot>> getArticles() async {
    try {
      final FirebaseUser _user = await FirebaseAuth.instance.currentUser();
      _uid = _user.uid;
      QuerySnapshot art =
          await Firestore.instance.collection("articles").getDocuments();
      _arti = art.documents;
      _urls.clear();
      for (int i = 0; i < _arti.length; i++) {
        String id = _arti[i].data["user"];
        DocumentSnapshot result =
            await Firestore.instance.collection("users").document(id).get();
        var temp = result.data["image_url"];
        _urls.add(temp.toString());
      }
      if (_len < _arti.length) {
        _len = _arti.length;
        setState(() {});
      }
>>>>>>> a3e951b2c7111be9bc4446d273b156954928b57c
    } catch (e) {
      print("sorry couldn't fetch data");
      print(e);
    }
    return _arti;
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    getArticles(context);
    return FutureBuilder(
      future: getArticles(context),
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => getArticles(context),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return ArticleCard(_arti[index]);
                      },
                      itemCount: _arti.length,
                    ),
                  ),
                ),
    );
=======
    return FutureBuilder(
        future: getArticles(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: getArticles,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  bool isAuthor = (_uid == _arti[index]["user"]);
                  return ArticleCard(_arti[index], isAuthor, _urls[index]);
                },
                itemCount: _arti.length,
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
>>>>>>> a3e951b2c7111be9bc4446d273b156954928b57c
  }
}

// FutureBuilder(
//         future: _refreshProducts(context),
//         builder: (ctx, snapshot) =>
//             snapshot.connectionState == ConnectionState.waiting
//                 ? Center(
//                     child: CircularProgressIndicator(),
//                   )
//                 : RefreshIndicator(
//                     onRefresh: () => _refreshProducts(context),
//                     child: Consumer<Products>(
//                       builder: (ctx, productsData, _) => Padding(
//                             padding: EdgeInsets.all(8),
//                             child: ListView.builder(
//                               itemCount: productsData.items.length,
//                               itemBuilder: (_, i) => Column(
//                                     children: [
//                                       UserProductItem(
//                                         productsData.items[i].id,
//                                         productsData.items[i].title,
//                                         productsData.items[i].imageUrl,
//                                       ),
//                                       Divider(),
//                                     ],
//                                   ),
//                             ),
//                           ),
//                     ),
//                   ),
//       ),

//       if(snapshot.hasData){
//             return ListView.builder(
//               itemBuilder :(context,index){
//                 return ArticleCard(_arti[index]);
//               },
//               itemCount: _arti.length,
//             );
//           }
//           else{
//             return Center(child: CircularProgressIndicator());
//           }
