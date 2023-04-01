import 'package:firebase_auth/firebase_auth.dart';
import 'package:mychat_app/data/models/database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future registerEmailAndPasword(
      String name, String email, String password) async {
    try {
      User users = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      //appelle la base de donée
      DatabaseService(uid: users.uid).savingUserData(name, email);
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // pour le login
  Future loginEmailAndPassword(String email, String passWord) async {
    try {
      User users = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: passWord))
          .user!;
      DatabaseService(uid: users.uid).gettingUserData(email);

      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //deconnexion
  Future logOutFunction() async {
    return await firebaseAuth.signOut();
  }

  Future<String?> getCurrentUserDisplayName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload(); // Met à jour les informations de l'utilisateur
      return user.displayName;
    }
    return null;
  }
}
