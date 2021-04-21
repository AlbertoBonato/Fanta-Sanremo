import 'package:fanta_sanremo/screens/home/home.dart';
import 'package:fanta_sanremo/utils/components.dart';
import 'package:fanta_sanremo/utils/shared_helpers.dart';
import 'package:fanta_sanremo/utils/theme.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'group_init.dart';

Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class LoginScreen extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
              color: color_b1,
              image: DecorationImage(
                  image: AssetImage('assets/images/ariston2.jpg'),
                  fit: BoxFit.fill,
                  alignment: Alignment.centerLeft,
                  scale: 0.4),),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
              ),
              ElevatedButton(
                child: Text(
                  "Accedi con Google",
                ),
                onPressed: () => signInWithGoogle().then((UserCredential cred) async {
                  User user = cred.user;
                  saveEmail(user.email);
                  saveDisplayName(user.displayName);
                  String groupId = await getGroupId();
                  Navigator.pushReplacement(
                      context,
                      MyPageTransition(
                          child: (groupId == null)
                              ? GroupInit()
                              : Home()));
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
