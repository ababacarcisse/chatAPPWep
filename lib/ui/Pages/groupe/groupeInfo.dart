import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:mychat_app/data/models/database_service.dart';

class GroupeInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  const GroupeInfo(
      {super.key,
      required this.adminName,
      required this.groupId,
      required this.groupName});

  @override
  State<GroupeInfo> createState() => _GroupeInfoState();
}

class _GroupeInfoState extends State<GroupeInfo> {
  Stream? members;

  @override
  initState() {
    super.initState();
    getMember();
  }

  getMember() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMember(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    double scale = 1.0;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Group Info"),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.exit_to_app)),
          ],
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).primaryColor.withOpacity(0.2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          scale = scale == 1.0 ? 1.2 : 1.0;
                        });
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        child: Center(
                          child: Transform.scale(
                            scale: scale,
                            child: const CircleAvatar(
                              backgroundImage:
                                  NetworkImage('https://picsum.photos/200'),
                              radius: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Group: ${widget.groupName}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text("Admin: ${getName(widget.adminName)}")
                      ],
                    )
                  ],
                ),
              ),
              membersList(),
            ])));
  }

  membersList() {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            getName(snapshot.data['members'][index])
                                .substring(0, 1)
                                .toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(getName(snapshot.data['members'][index])),
                        subtitle: const Text("membre du groupe")),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("PAS DE MEMBRES"),
              );
            }
          } else {
            return const Center(
              child: Text("PAS De MEMBRES"),
            );
          }
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ));
        }
      },
    );
  }
}

String getId(String res) {
  return res.substring(0, res.indexOf("_"));
}
