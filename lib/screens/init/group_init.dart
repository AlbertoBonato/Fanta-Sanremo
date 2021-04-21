import 'package:fanta_sanremo/utils/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'group_selection.dart';
import 'login.dart';
import 'new_group.dart';

class GroupInit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scelta gruppo")),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                  child: Text(
                    "Crea nuovo gruppo",
                  ),
                  onPressed: () {
                    Navigator.push(
                        context, MyPageTransition(child: NewGroup()));
                  }),
              SizedBox(
                height: 64,
              ),
              ElevatedButton(
                  child: Text(
                    "Seleziona Gruppo",
                  ),
                  onPressed: () => Navigator.push(
                      context, MyPageTransition(child: GroupSelection()))),
              SizedBox(
                height: 64,
              ),
              ElevatedButton(
                  child: Text(
                    "Log out",
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.signOut().then((value) =>
                        Navigator.pushReplacement(
                            context, MyPageTransition(child: LoginScreen())));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
