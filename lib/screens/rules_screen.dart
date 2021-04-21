import 'package:fanta_sanremo/utils/theme.dart';
import 'package:fanta_sanremo/utils/utils.dart';
import 'package:flutter/material.dart';

class RulesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
            decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  image: AssetImage('assets/images/mollica.jpg'),
                )
            ),
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chi fa più punti vince',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Si fanno punti con i gettoni evento, '
                      'rispondendo correttamente a una '
                      'domanda del quiz, oppure indovinando il vincitore del Festival.',
                      softWrap: true,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Gettone evento',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Saira',
                                color: color_b5),
                            children: [
                          TextSpan(
                              text:
                                  'E\' possibile scommettere sul verificarsi '
                                      'di una tipologia di evento selezionando il gettone '
                                      'associato. Se questa si verifica '
                                      'mentre è selezionato il gettone corrispondente, '
                                      'si guadagnano i punti del gettone. '
                                      'Ogni gettone ha un valore più o meno '
                                      'inversamente proporzionale alla probabilità '
                                      'che l\'evento corrispondente avvenga. '
                                      'Una volta scelto un gettone evento, non si può cambiare '
                                  'prima di '),
                          TextSpan(
                              text: '$gettoneLockedMinutes',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: ' minuti e dopo '),
                          TextSpan(
                              text: '$gettoneExpirationMinutes',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: ' viene automaticamente deselezionato. '
                                  'Non ci sono limiti al numero di volte '
                                  'in cui si può selezionare un gettone.'),
                        ])),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Quiz',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Saira',
                                color: color_b5),
                            children: [
                          TextSpan(
                              text:
                                  'Ogni tanto verranno rese disponibili delle '
                                  'domande del quiz, ma ci sarà un tempo '
                                  'limitato per poter rispondere!\nQuindi '
                                  'non fare l\'infame andando su wikipedia!!! '
                                  'Ogni domanda giusta ti becchi '),
                          TextSpan(
                              text: '$questionPoints',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                  ' punti. Il timer parte quando si preme la '
                                      'scritta \'Mostra la domanda\'.'),
                        ])),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Televoto',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Saira',
                                color: color_b5),
                            children: [
                              TextSpan(
                                  text:
                                  'Si può scommettere sul vincitore del '
                                      'Festival fino a '),
                              TextSpan(
                                  text: '3',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                  ' giorni prima della serata finale. '
                                      'Se indovini il vincitore del festival '
                                      'guadagni '),
                              TextSpan(
                                  text: '10',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                  ' punti.'),
                            ])),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
