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

  Future<bool> doesFollow(String celeb,String fan) async{
    final QuerySnapshot result=await Firestore.instance.collection("follow").where("celeb",isEqualTo: celeb).where("fan",isEqualTo: fan).getDocuments();
    List<DocumentSnapshot> doc=result.documents;
    bool ans;
    if(doc.isEmpty) ans=false;
    else ans=true;
    print(ans);
    return ans;
  }

  Future<List<DocumentSnapshot>> getUsers() async {
    QuerySnapshot result = await Firestore.instance.collection("users").getDocuments();
    List<DocumentSnapshot> _users=result.documents;
    return _users;
  }

  Future<List<DoucmentSnapshot>> getOtherUsers async {

}
}
