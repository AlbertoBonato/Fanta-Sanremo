import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanta_sanremo/models/group.dart';
import 'package:fanta_sanremo/models/invitation.dart';
import 'package:fanta_sanremo/screens/home/home.dart';
import 'package:fanta_sanremo/services/database.dart';
import 'package:fanta_sanremo/utils/components.dart';
import 'package:fanta_sanremo/utils/shared_helpers.dart';
import 'package:fanta_sanremo/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupSelection extends StatefulWidget {
  @override
  _GroupSelectionState createState() => _GroupSelectionState();
}

class _GroupSelectionState extends State<GroupSelection> {

  // Gruppi dove sono stato invitato
  List<Group> groupsInvited = <Group>[];

  void initGroups() async {
    QuerySnapshot myInvitations = await getMyInvitations();
    List<String> groupIds =
        myInvitations.docs.map((d) => Invitation.fromDoc(d).groupId).toList();
    List<Group> groups = (await getGroups(groupIds)).docs
        .map((e) => Group.fromDoc(e)).toList();
    setState(() {
      groupsInvited.addAll(groups);
    });
  }

  @override
  void initState() {
    initGroups();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Seleziona Gruppo")),
        body: SafeArea(child: GroupsList(groups: groupsInvited)));
  }
}

class GroupsList extends StatelessWidget {
  const GroupsList({
    Key key,
    @required this.groups,
  }) : super(key: key);

  final List<Group> groups;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: groups.length,
          itemBuilder: (context, i) {
            return ListTile(
                title: Text(
                  groups[i].name,
                  style: TextStyle(
                      color: color_b5,
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                ),
                trailing: IconButton(
                    icon: Icon(
                      Icons.check_outlined,
                      color: color_b5,
                    ),
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) =>
                            ConfirmGroupDialog(groups[i]))));
          }),
    );
  }
}

class ConfirmGroupDialog extends StatelessWidget {
  final Group group;
  ConfirmGroupDialog(this.group);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: color_b5,
      title: Text('Selezione gruppo',
          style: TextStyle(
              color: color_b1, fontSize: 30, fontWeight: FontWeight.w800)),
      content: Text(
        group.name,
        style: TextStyle(
            color: color_b1, fontSize: 22, fontWeight: FontWeight.w500),
      ),
      actions: <Widget>[
        MyDialogButton(
            label: 'Cancella', action: () => Navigator.of(context).pop()),
        MyDialogButton(
            label: 'Conferma',
            action: () {
              joinGroup(group).then((value) async {
                await saveGroupId(group.id);
                User user = FirebaseAuth.instance.currentUser;
                await saveDisplayName(user.displayName);
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.pushReplacement(
                    context, MyPageTransition(child: Home()));
              }).catchError((err) {
                Navigator.of(context).pop();
              });
            }),
      ],
    );
  }
}
