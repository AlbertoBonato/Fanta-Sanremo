import 'package:fanta_sanremo/screens/bet_screen.dart';
import 'package:fanta_sanremo/screens/quiz/quiz_screen.dart';
import 'package:fanta_sanremo/screens/rank_screen.dart';
import 'package:flutter/material.dart';

import '../gettone_screen.dart';

class MenuData {
  MenuData(
      {this.imagePath = '',
      this.titleTxt = '',
      this.startColor = '',
      this.endColor = '',
      this.meals,
      this.destination});

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  List<String> meals;
  Widget destination;

  static List<MenuData> tabIconsList = <MenuData>[
    MenuData(
        imagePath: 'assets/images/casino_color.png',
        titleTxt: 'Gettone',
        meals: <String>['Seleziona', 'gettone evento'],
        startColor: '#890620',
        endColor: '#2c0703',
        destination: GettoneScreen()),
    MenuData(
      imagePath: 'assets/images/question_color.png',
      titleTxt: 'Quiz',
      meals: <String>['Indovina la', 'domanda di', 'storia'],
      startColor: '#890620',
      endColor: '#2c0703',
      destination: QuizScreen(),
    ),
    MenuData(
        imagePath: 'assets/images/betting.png',
        titleTxt: 'Televoto',
        meals: <String>['Scommetti su', 'chi vincerà', 'il festival'],
        startColor: '#890620',
        endColor: '#2c0703',
        destination: BetScreen()),
    MenuData(
        imagePath: 'assets/images/ranking.png',
        titleTxt: 'Classifica',
        meals: <String>['Visualizza la', 'classifica', 'attuale'],
        startColor: '#890620',
        endColor: '#2c0703',
        destination: RankScreen()),
  ];
}
