import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/components/article_card.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  bool _isLoading = true;
  List<DocumentSnapshot> _arti;

  Future<List<DocumentSnapshot>> getArticles(BuildContext context) async {
    try {
      QuerySnapshot art =
          await Firestore.instance.collection("articles").getDocuments();
      _arti = art.documents;
      print(_arti[0].data);
      return _arti;
    } catch (e) {
      print("sorry couldn't fetch data");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
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
