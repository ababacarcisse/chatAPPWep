import 'package:flutter/material.dart';
import 'package:banner_listtile/banner_listtile.dart';
import 'package:mychat_app/functions/MyFunction.dart';
import 'package:mychat_app/ui/Pages/groupe/GroupChatPage.dart';

class ListGroupeTitle extends StatefulWidget {
  final groupId;
  final name;
  final groupName;

  final onTap;
  const ListGroupeTitle({
    super.key,
    this.groupId,
    this.name,
    required this.groupName,
    this.onTap,
  });

  @override
  State<ListGroupeTitle> createState() => _ListGroupeTitleState();
}

class _ListGroupeTitleState extends State<ListGroupeTitle> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => navigate(
          context,
          ChatPage(
            groupId: widget.groupId,
            groupName: widget.groupName,
            name: widget.name,
          ))),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Center(
          child: BannerListTile(
            backgroundColor: Colors.blue,
            borderRadius: BorderRadius.circular(8),
            imageContainer: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  widget.groupName.substring(0, 1).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            title: Text(
              widget.groupName,
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Text("Rejoindre la discussion avec ${widget.name}",
                style: const TextStyle(fontSize: 13, color: Colors.white)),
            trailing: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                )),
          ),
        ),
      ),
    );
  }
}
