import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:path_provider/path_provider.dart';

final String ADMIN_MAIL = 'bonatoalbe@gmail.com';

const int questionPoints = 3;

class OutcomeStatus {
  String message;
  Color color;

  OutcomeStatus(this.message, this.color);
}
final List<OutcomeStatus> outcomes = [
  OutcomeStatus('Senza Risposta', Colors.red.withOpacity(0.6)),
  OutcomeStatus('Indovinato!', Colors.green.withOpacity(0.6)),
  OutcomeStatus('Risposta Errata', Colors.red.withOpacity(0.6)),
];

const int gettoneLockedMinutes = 5;
const int gettoneExpirationMinutes = 10;
const Duration gettoneExpiration = Duration(minutes: gettoneExpirationMinutes);
const Duration gettoneLockedDuration = Duration(minutes: gettoneLockedMinutes);

final firstDay = DateTime(2021, 3, 2, 23, 59);
final lastDay = DateTime(2021, 3, 6, 23, 59);
final lastBetDay = DateTime(2021, 3, 5, 01, 01);

final RegExp gmailRegex = RegExp(r"^.+@gmail\.[a-zA-Z]+");
bool validGmailValue(String mail) => gmailRegex.hasMatch(mail);

final String ACTIVATE_GETTONE_SELECTION_TASK = "agsk";
final String UNSELECT_GETTONE_TASK = "gst";

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}