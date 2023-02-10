import 'package:flutter/material.dart';

import '../../../data/models/database_service.dart';

class GroupListPage extends StatefulWidget {
  const GroupListPage({super.key});

  @override
  _GroupListPageState createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  List<Group> _groupList = [];

  @override
  void initState() {
    super.initState();
    _getUserGroups();
  }

  _getUserGroups() async {
    DatabaseService().getUserGroups().listen((event) {
      setState(() {
        _groupList = [];
        List<String> groupData = event.data()['groups'] as List<String>;
        groupData.forEach((group) {
          String groupId = group.split('_')[0];
          String groupName = group.split('_')[1];
          _groupList.add(Group(id: groupId, name: groupName));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _groupList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_groupList[index].name),
            onTap: () {
              // Navigate to the group detail page
            },
          );
        },
      ),
    );
  }
}

class Group {
  final String id;
  final String name;

  Group({required this.id, required this.name});
}
