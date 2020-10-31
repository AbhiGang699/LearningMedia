import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<FirebaseUser> signIn(String mail, String pass) async {
    final AuthResult authResult =
        await auth.signInWithEmailAndPassword(email: mail, password: pass);
    final FirebaseUser user = authResult.user;

    assert(user != null);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await auth.currentUser();
    assert(user.uid == currentUser.uid);
    return user;
  }

  Future<FirebaseUser> registerUser(String mail, String pass) async {
    final AuthResult authResult =
        await auth.createUserWithEmailAndPassword(email: mail, password: pass);
    final FirebaseUser user = authResult.user;

    assert(user != null);
    assert(await user.getIdToken() != null);
    return user;
  }

  Future<bool> check(String name) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('name', isEqualTo: name.toLowerCase())
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length > 0) return false;
    return true;
  }

  Future<List<String>> getFollowingUsers(String _uid) async {
    DocumentSnapshot result =
        await Firestore.instance.collection("follow").document(_uid).get();
    List<String> ids = List<String>();
    if (result == null) return ids;

    for (var i in result.data.keys) {
      ids.add(i);
    }
    return ids;
  }

  Future<FirebaseUser> getCurrentUser() async {
    return await FirebaseAuth.instance.currentUser();
  }
}
