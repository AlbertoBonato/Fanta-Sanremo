import 'dart:convert';
import 'dart:io';

import 'package:fanta_sanremo/models/user.dart';
import 'package:fanta_sanremo/utils/utils.dart';

class GettoneState {
  String selectedGettoneName;
  DateTime selectedGettoneDate;

  GettoneState.nullo()
      : this.selectedGettoneDate = null,
        this.selectedGettoneName = null;

  GettoneState.fromUserGettone(UserGettone userGettone)
      : this.selectedGettoneName = userGettone.name,
        this.selectedGettoneDate = userGettone.selectionDate;

  GettoneState.fromJson(Map<String, dynamic> json)
      : this.selectedGettoneName = json['selectedGettoneName'],
        this.selectedGettoneDate = DateTime.parse(json['selectedGettoneDate']);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'selectedGettoneName' : this.selectedGettoneName,
    'selectedGettoneDate' : this.selectedGettoneDate.toIso8601String()
  };

  Future<void> persist() async {
    final file = await _localGettoneFile;
    if (this.selectedGettoneDate != null &&
        this.selectedGettoneName != null) {
      await file.writeAsString(jsonEncode(this));
    }
  }

  @override
  String toString() {
    return 'GettoneState{selectedGettoneName: $selectedGettoneName,'
        'selectedGettoneDate: $selectedGettoneDate}';
  }
}

Future<File> get _localGettoneFile async {
  final path = await localPath;
  return File('$path/gettone_state.txt');
}

Future<GettoneState> readGettoneState() async {
  try {
    final file = await _localGettoneFile;
    String contents = await file.readAsString();
    GettoneState quizState = GettoneState.fromJson(jsonDecode(contents));
    return quizState;
  } catch (e) {
    print('error reading gettone state $e');
    return GettoneState.nullo();
  }
}
