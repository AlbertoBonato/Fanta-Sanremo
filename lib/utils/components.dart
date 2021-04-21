
import 'package:fanta_sanremo/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Errore interno",
          style: TextStyle(
              color: color_b5, fontSize: 25, fontWeight: FontWeight.w600),
        ),
        backgroundColor: color_b2,
      ),
      body: Container(
        child: Center(
          child: Text('Contattare amministratore di sistema'),
        ),
      ),
    );
  }
}

class MyLoader extends CircularProgressIndicator {
  MyLoader() : super(valueColor: AlwaysStoppedAnimation<Color>(color_b5));
}

class MyPageTransition extends PageTransition {
  MyPageTransition({@required child})
      : super(type: PageTransitionType.rightToLeft, child: child);
}

class MyDialogButton extends TextButton {
  MyDialogButton({@required label, @required action})
      : super(
    child: Text(label,
        style: TextStyle(
            color: color_b1, fontSize: 20, fontWeight: FontWeight.w800)),
    onPressed: action,
  );
}
