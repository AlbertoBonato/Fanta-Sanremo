import 'package:fanta_sanremo/screens/add_friends_screen.dart';
import 'package:fanta_sanremo/screens/admin_screen.dart';
import 'package:fanta_sanremo/utils/components.dart';
import 'package:fanta_sanremo/utils/shared_helpers.dart';
import 'package:fanta_sanremo/utils/theme.dart';
import 'package:fanta_sanremo/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'init/login.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  Future<String> displayName = getDisplayName();
  Future<String> email = getEmail();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 70, 22, 0),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          alignment: Alignment.centerLeft,
          image: AssetImage('assets/images/rino2filter.jpg'),
        )
      ),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'Utente: ',
              style: TextStyle(fontFamily: secondFont),
            ),
            FutureBuilder(
              future: displayName,
              builder: (context, snapshot) => Text(
                snapshot.hasData ? snapshot.data : '',
              ),
            ),
          ],
        ),
        SizedBox(
          height: 64,
        ),
        ElevatedButton(
            child: Text(
              "Log out",
            ),
            onPressed: () => showDialog(
                context: context, builder: (context) => SignOffDialog())),
        SizedBox(
          height: 64,
        ),
        ElevatedButton(
            child: Text(
              "Aggiungi amici",
            ),
            onPressed: () => Navigator.push(
                context, MyPageTransition(child: AddFriends()))),
        FutureBuilder(
            future: email,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == ADMIN_MAIL) {
                  return ElevatedButton(
                      child: Text(
                        'Pagina Admin',
                      ),
                      onPressed: () => Navigator.push(
                          context, MyPageTransition(child: AdminScreen())));
                } else {
                  return Container();
                }
              }
              return Container();
            }),
        Expanded(
          child: Center(
            child: Container(
              alignment: Alignment.centerRight,
              child: Text('Chi gioca a Sanremo ...',
              style: TextStyle(
                fontStyle:  FontStyle.italic,
                fontWeight: FontWeight.w600
              ),),
            ),
          ),
        ),
        SizedBox(
          height: 64,
        ),
      ],
        ),
    );
  }
}

class SignOffDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: color_b5,
      title: Text('Log out?',
          style: TextStyle(
              color: color_b1, fontSize: 30, fontWeight: FontWeight.w800)),
      actions: <Widget>[
        MyDialogButton(
            label: 'Cancella', action: () => Navigator.of(context).pop()),
        MyDialogButton(
            label: 'Log out',
            action: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                  context, MyPageTransition(child: LoginScreen()));
            }),
      ],
    );
  }
}
