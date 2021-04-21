import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanta_sanremo/models/question.dart';
import 'package:fanta_sanremo/state/app_state.dart';
import 'package:fanta_sanremo/services/database.dart';
import 'package:fanta_sanremo/state/gettone_state.dart';
import 'package:fanta_sanremo/state/quiz_state.dart';
import 'package:fanta_sanremo/utils/components.dart';
import 'package:fanta_sanremo/utils/theme.dart';
import 'package:flutter/material.dart';

import 'package:fanta_sanremo/models/gettone.dart';

import 'package:provider/provider.dart';

class AdminScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pagina Admin"),
      ),
      body: ListView(
        children: [
          AddGettoneEventoMenu(),
          ShowDomandaMenu(),
        ],
      ),
    );
  }
}

class AddGettoneEventoMenu extends StatelessWidget {

  Future<List<Gettone>> gettoniF = getGettoni();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: gettoniF,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        }
        if (snapshot.hasData) {
          List<Gettone> gettoni = snapshot.data;
          return ExpansionTile(
            leading: Icon(
              Icons.add,
              color: color_b5,
            ),
            title: Text(
              'Aggiungi evento gettone',
              style: TextStyle(
                color: color_b5,
                fontWeight: FontWeight.w700,
              ),
            ),
            children: gettoni
                .map((gettone) => ListTile(
              title: Text(
                gettone.name,
                style: TextStyle(
                  color: color_b5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onTap: () => showDialog(
                  context: context,
                  builder: (context) => AddGettoneEventoDialog(gettone)),
            ))
                .toList(),
          );
        }
        return Container(child: Center(child: MyLoader()), color: color_b2,);
      }
    );
  }
}

class ShowDomandaMenu extends StatefulWidget {
  @override
  _ShowDomandaMenuState createState() => _ShowDomandaMenuState();
}

class _ShowDomandaMenuState extends State<ShowDomandaMenu> {
  Future<List<Question>> questions;

  @override
  void initState() {
    questions = getQuestions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: questions,
        builder: (context, snapshot) {
          List<Widget> showedList = (snapshot.hasData)
              ? List.from(snapshot.data
                  .map((q) => ListTile(
                        title: Text(
                          '${q.index}. ${q.demand}...',
                          style: TextStyle(
                            color: color_b5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
              onTap: () => showDialog(
                  context: context,
                  builder: (context) => ShowDomandaDialog(q))
                      ))
                  .toList())
              : <Widget>[];
          return Column(
            children: [
              ExpansionTile(
                  leading: Icon(
                    Icons.add,
                    color: color_b5,
                  ),
                  title: Text(
                    'Rendi visibile domanda',
                    style: TextStyle(
                      color: color_b5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  children: showedList),
              ListTile(
                title: Text('Pulisci stato quiz',
                  style: TextStyle(
                    color: color_b5,
                    fontWeight: FontWeight.w700,
                  ),),
                onTap: () {
                  var state = context.read<AppState>();
                  state.resetQuizState();
                },
              ),
              ListTile(
                title: Text('Stampa stato quiz',
                  style: TextStyle(
                    color: color_b5,
                    fontWeight: FontWeight.w700,
                  ),),
                onTap: () {
                  var state = context.read<AppState>();
                  state.printQuizState();
                },
              ),
              ListTile(
                title: Text('Stampa stato quiz da file',
                  style: TextStyle(
                    color: color_b5,
                    fontWeight: FontWeight.w700,
                  ),),
                onTap: () async {
                  print('${await readQuizState()}');
                },
              ),
              ListTile(
                title: Text('Stampa stato gettone',
                  style: TextStyle(
                    color: color_b5,
                    fontWeight: FontWeight.w700,
                  ),),
                onTap: () async {
                  print('${await readGettoneState()}');
                },
              ),
            ],
          );
        });
  }
}

class AddGettoneEventoDialog extends StatelessWidget {
  Gettone gettone;
  AddGettoneEventoDialog(this.gettone);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: color_b5,
      title: Text('Evento Gettone',
          style: TextStyle(
              color: color_b1, fontSize: 29, fontWeight: FontWeight.w900)),
      content: Text(
        'Aggiungere ${gettone.name}?',
        style: TextStyle(
            color: color_b1, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      actions: <Widget>[
        MyDialogButton(
            label: 'Cancella', action: () => Navigator.of(context).pop()),
        MyDialogButton(
            label: 'Conferma',
            action: () async {
              DateTime eventTime = DateTime.now();
              DocumentReference newEvent =
                  await addGettoneEvent(gettone, eventTime);
              if (newEvent != null && newEvent.id != null) {
                updateUsersPoints(gettone, newEvent.id, eventTime);
              }
              Navigator.of(context).pop();
            }),
      ],
    );
  }
}

class ShowDomandaDialog extends StatelessWidget {
  Question question;
  ShowDomandaDialog(this.question);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: color_b5,
      title: Text('Evento Domanda',
          style: TextStyle(
              color: color_b1, fontSize: 29, fontWeight: FontWeight.w900)),
      content: Text(
        'Rendere disponibile domanda ${question.index}?',
        style: TextStyle(
            color: color_b1, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      actions: <Widget>[
        MyDialogButton(
            label: 'Cancella', action: () => Navigator.of(context).pop()),
        MyDialogButton(
            label: 'Conferma',
            action: () {
              showQuestion(question);
              Navigator.of(context).pop();
            }),
      ],
    );
  }
}
