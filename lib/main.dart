import 'package:fanta_sanremo/screens/home/home.dart';
import 'package:fanta_sanremo/screens/init/group_init.dart';
import 'package:fanta_sanremo/screens/init/login.dart';
import 'package:fanta_sanremo/state/app_state.dart';
import 'package:fanta_sanremo/state/gettone_state.dart';
import 'package:fanta_sanremo/state/quiz_state.dart';
import 'package:fanta_sanremo/utils/components.dart';
import 'package:fanta_sanremo/utils/shared_helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'utils/theme.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)
async {
  print('Messaggio ottenuto con app in backgroud!');
  print('Notifica: ${message.notification}');
  if (message.notification != null) {
    print('Notifica: ${message.notification}');
  }
  return;
}

main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(FirebaseWrapper());
}

class FirebaseWrapper extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return SomethingWentWrong();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
            return FantaSanremo();
          }
          return Container(child: Center(child: MyLoader()), color: color_b2,);
        },);
  }
}

class FantaSanremo extends StatelessWidget {

  Future<QuizState> initQuizState() async {
    return readQuizState();
  }

  Future<GettoneState> initGettoneState() async {
    return readGettoneState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState.asyncInit(initQuizState(), initGettoneState()),
      child: MaterialApp(
        title: 'Fanta Sanremo',
        debugShowCheckedModeBanner: false,
        theme: mTheme,
        initialRoute: '/',
        home: LandingPage(),
      ),
    );
  }

}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User user = FirebaseAuth.instance.currentUser;
  Future<String> groupId;

  initMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Messaggio ottenuto con app attiva (foreground)!');
      print('Notifica: ${message.notification}');
      if (message.notification != null) {
        print('Notifica: ${message.notification}');
      showDialog(context: context,
        builder: (context) => AlertDialog(
          title: Text(message.notification.title),
        )
      );
      }
    });
  }

  void checkUseridInitialization() async {
    if (user != null) {
      saveEmail(user.email);
      saveDisplayName(user.displayName);
      groupId = getGroupId();
    }
  }

  @override
  void initState() {
    super.initState();
    initMessaging();
    checkUseridInitialization();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return LoginScreen();
    } else {
      return FutureBuilder(
        future: groupId,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error reading groupId ${snapshot.error}');
            return SomethingWentWrong();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data != null) {
              return Home();
            } else
              return GroupInit();
          }
          return Container(child: Center(child: MyLoader()), color: color_b2,);
        },
      );
    }
  }
}