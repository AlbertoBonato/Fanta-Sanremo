import 'package:fanta_sanremo/screens/home/home.dart';
import 'package:fanta_sanremo/services/database.dart';
import 'package:fanta_sanremo/utils/components.dart';
import 'package:fanta_sanremo/utils/theme.dart';
import 'package:flutter/material.dart';

class NewGroup extends StatefulWidget {
  @override
  _NewGroupState createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  final TextEditingController _groupNameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Crea Gruppo")),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 64,
                ),
                Text("Nome Gruppo"),
                TextField(
                  controller: _groupNameCtrl,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: color_b5,
                        ),
                      ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: color_b5,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: color_b5,
                  ),
                ),
                SizedBox(
                  height: 64,
                ),
                ElevatedButton(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "Inserisci ed entra",
                    ),
                  ),
                  onPressed: () async {
                    bool insertOk = await createGroup(_groupNameCtrl.text);
                    if (insertOk) {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.pushReplacement(
                          context, MyPageTransition(child: Home()));
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
