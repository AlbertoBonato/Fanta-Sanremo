import 'package:fanta_sanremo/services/database.dart';
import 'package:fanta_sanremo/utils/theme.dart';
import 'package:fanta_sanremo/utils/utils.dart';
import 'package:flutter/material.dart';

class AddFriends extends StatefulWidget {
  @override
  _AddFriendsState createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  List<String> invitations = [];
  final TextEditingController _mailAddressCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _addMailAddressToInvitations(String mailAddress) {
    setState(() {
      invitations.add(mailAddress.toLowerCase().trim());
    });
  }

  _removeMailAddress(int idx) {
    setState(() {
      invitations.removeAt(idx);
    });
  }

  _inviteNewMembers() {
    if (invitations.isEmpty) return;
    addInvitations(invitations.toSet().toList());
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _mailAddressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aggiungi amico"),
        actions: [
          Center(
              child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    child: Text(
                      'FINE',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: color_b5),
                    ),
                    onTap: _inviteNewMembers,
                  )))
        ],
      ),
      body: SafeArea(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 64,
              ),
              SizedBox(
                height: 64,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: invitations.length,
                    itemBuilder: (context, idx) {
                      return GestureDetector(
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Container(
                            width: 60,
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color_b1,
                            ),
                            child: Text(
                              invitations[idx].substring(0, 1).toUpperCase(),
                              style: TextStyle(color: color_b5),
                            ),
                          ),
                        ),
                        onTap: () {
                          _removeMailAddress(idx);
                        },
                      );
                    }),
              ),
              Divider(),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Inserisci email';
                        } else if (!validGmailValue(value)) {
                          return 'Inserisci email valida (gmail)';
                        }
                        return null;
                      },
                      controller: _mailAddressCtrl,
                      style: TextStyle(
                          color: color_b5,
                          fontSize: 22,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: color_b1,
        foregroundColor: color_b5,
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _addMailAddressToInvitations(_mailAddressCtrl.text);
            _mailAddressCtrl.clear();
          }
        },
      ),
    );
  }
}
