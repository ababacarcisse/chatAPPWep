import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageTextFiedWidget extends StatefulWidget {
  const MessageTextFiedWidget(
      {super.key,
      required this.currentUserID,
      required this.otherUserID,
      required this.currentUserName,
      required this.otherUserName});

  @override
  final String currentUserID;
  final String otherUserID;
  final String currentUserName;
  final String otherUserName;
  State<MessageTextFiedWidget> createState() => _MessageTextFiedWidgetState();
}

class _MessageTextFiedWidgetState extends State<MessageTextFiedWidget> {
  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();
    return Container(
      alignment: Alignment.bottomCenter,
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[700],
        child: Row(children: [
          Expanded(
              child: TextFormField(
            controller: messageController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "envoyer un message",
              hintStyle: TextStyle(color: Colors.white, fontSize: 16),
              border: InputBorder.none,
            ),
          )),
          const SizedBox(
            width: 12,
          ),
          GestureDetector(
            onTap: () async {
              //  sendMessage();
              String message = messageController.text;
              messageController.clear();
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(widget.currentUserID)
                  .collection("messages")
                  .doc(widget.otherUserID)
                  .collection("chats")
                  .add({
                "senderid": widget.currentUserID,
                "receverid": widget.otherUserID,
                "senderName": widget.currentUserName,
                "receverName": widget.otherUserName,
                "message": message,
                "type": "text",
                "date": DateTime.now(),
              }).then((value) => {
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(widget.currentUserID)
                            .collection("messages")
                            .doc(widget.otherUserID)
                            .set({"last_msg": message}),
                      });
              //pour l'autreuser
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(widget.otherUserID)
                  .collection("messages")
                  .doc(widget.currentUserID)
                  .collection("chats")
                  .add({
                "senderid": widget.currentUserID,
                "receverid": widget.otherUserID,
                "senderName": widget.currentUserName,
                "receverName": widget.otherUserName,
                "message": message,
                "type": "text",
                "date": DateTime.now(),
              }).then((value) => {
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(widget.otherUserID)
                            .collection("messages")
                            .doc(widget.currentUserID)
                            .set({"last_msg": message}),
                      });
            },
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                  child: Icon(
                Icons.send,
                color: Colors.white,
              )),
            ),
          )
        ]),
      ),
    );
  }
}
