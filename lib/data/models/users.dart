import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String id;
  final String name;
  final String email;

  Users({
    required this.id,
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'name': name,
      'email': email,
    };
  }

  static Users fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final id = snapshot.id;
    final name = data['name'] as String;
    final email = data['email'] as String;
    return Users(
      id: id,
      name: name,
      email: email,
    );
  }

  static Users fromMap(Map<String, dynamic> map) {
    return Users(
      id: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }
}
