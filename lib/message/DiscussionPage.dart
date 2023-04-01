import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:mychat_app/functions/MyFunction.dart';

import 'chatpaggg.dart';

class DIscussionPage extends StatefulWidget {
  const DIscussionPage({super.key, required this.userId});
  final String userId;

  @override
  State<DIscussionPage> createState() => _DIscussionPageState();
}

class _DIscussionPageState extends State<DIscussionPage>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(widget.userId)
                .collection("messages")
                .snapshots(),
            builder: (context, AsyncSnapshot snapshop) {
              if (snapshop.hasData) {
                if (snapshop.data.docs.length < 1) {
                  return const Center(
                    child: Text("aucun message n'est disponible"),
                  );
                }
                return ListView.builder(
                    itemCount: snapshop.data.docs.length,
                    itemBuilder: (context, Index) {
                      var otherUserId = snapshop.data.docs[Index].id;
                      var last_msg = snapshop.data.docs[Index]["last_msg"];
                      return FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection("users")
                              .doc(otherUserId)
                              .get(),
                          builder: (contect, AsyncSnapshot asyncSnapshot) {
                            if (asyncSnapshot.hasData) {
                              var friend = asyncSnapshot.data;
                              return ListTile(
                                leading: CircleAvatar(
                                  child: Text(
                                    friend["name"].substring(0, 3),
                                  ),
                                ),
                                title: Text(friend["name"]),
                                subtitle: Container(
                                    child: Text(
                                  "$last_msg",
                                  style: const TextStyle(color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                )),
                                onTap: () {
                                  navigate(
                                      context,
                                      ChatScreen(
                                        currentuser: widget.userId,
                                        otherUser: friend["name"],
                                        otherUserId: friend["uid"],
                                      ));
                                },
                              );
                            }
                            return const LinearProgressIndicator();
                          });
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
