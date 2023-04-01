import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../functions/MyFunction.dart';
import '../profil/Profile.dart';

class SearchUsersPage extends StatefulWidget {
  const SearchUsersPage({Key? key}) : super(key: key);

  @override
  _SearchUsersPageState createState() => _SearchUsersPageState();
}

class _SearchUsersPageState extends State<SearchUsersPage> {
  String searchQuery = "";
  QuerySnapshot? searchResults;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Future<void> searchUsers(String query) async {
    QuerySnapshot snapshot = await userCollection
        .where("name", isGreaterThanOrEqualTo: query)
        //   .where("name", isLessThanOrEqualTo: query + '\uf8ff')
        .where("name", isLessThanOrEqualTo: '$query\uf8ff')
        .get();
    setState(() {
      searchResults = snapshot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Users"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search for users...",
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
                searchUsers(query);
              },
            ),
          ),
          Expanded(
            child: searchResults == null
                ? const Center(child: Text("Enter a search query"))
                : ListView(
                    children: searchResults!.docs.map((document) {
                      return GestureDetector(
                        onTap: () {
                          navigate(
                              context,
                              ProfilePage(
                                email: document['email'],
                                name: document['name'],
                              ));
                        },
                        child: ListTile(
                          title: Text(document['name']),
                          subtitle: Text(document['email']),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
