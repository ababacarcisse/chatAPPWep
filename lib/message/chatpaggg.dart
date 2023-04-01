import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mychat_app/message/widget/messageTextfield.dart';
import 'package:mychat_app/message/widget/single_message.dart';

class ChatScreen extends StatefulWidget {
  final String otherUser;
  final String currentuser;
  final String otherUserId;
  ChatScreen({
    required this.otherUserId,
    required this.currentuser,
    required this.otherUser,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController messageEditingController;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    super.initState();
    messageEditingController = TextEditingController();
  }

  @override
  void dispose() {
    messageEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUser),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: Container(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(widget.currentuser)
                      .collection("messages")
                      .doc(widget.otherUserId)
                      .collection("chats")
                      .orderBy("date", descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshop) {
                    if (snapshop.hasData) {
                      if (snapshop.data.docs.length < 1) {
                        return const Center(child: Text("Aucun message "));
                      }
                      return ListView.builder(
                          itemCount: snapshop.data.docs.length,
                          reverse: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, Index) {
                            bool isMe =
                                snapshop.data.docs[Index]["senderid"] == userId;

                            return SingleMessageWidget(
                                message: snapshop.data.docs[Index]["message"],
                                isMe: isMe);
                          });
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            )),
            MessageTextFiedWidget(
              otherUserID: widget.otherUserId,
              currentUserID: widget.currentuser,
              otherUserName: widget.otherUser,
              currentUserName: '',
            ),
          ],
        ),
      ),
    );
  }
}
