import 'package:fanta_sanremo/state/quiz_state.dart';
import 'package:fanta_sanremo/state/gettone_state.dart';
import 'package:fanta_sanremo/models/user.dart' as u;
import 'package:fanta_sanremo/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import '../models/question.dart';

class AppState extends ChangeNotifier {
  AppState.asyncInit(
      Future<QuizState> quizState, Future<GettoneState> gettoneState) {
    this._selectedGettoneName = '';
    this._canChangeGettone = true;
    gettoneState.then((gState) {
      this.refreshGettone(gState);
    });
    quizState.then((value) => this._quizState = value);
  }

  void refreshGettone(GettoneState gState) async {
    String selectedGettoneName = gState.selectedGettoneName;
    DateTime selectedGettoneDate = gState.selectedGettoneDate;
    if (selectedGettoneName != null && selectedGettoneDate != null) {
      DateTime now = DateTime.now();
      DateTime canChangeGettoneTime =
          selectedGettoneDate.add(gettoneLockedDuration);
      DateTime gettoneExpirationTime =
          selectedGettoneDate.add(gettoneExpiration);
      this._canChangeGettone = now.isAfter(canChangeGettoneTime);
      if (now.isAfter(gettoneExpirationTime)) {
        this._selectedGettoneName = '';
      } else {
        this._selectedGettoneName = gState.selectedGettoneName;
      }
      notifyListeners();
    }
  }

  QuizState _quizState = QuizState();

  QuizState get quizState => _quizState;

  void resetQuizState() {
    this._quizState = QuizState();
  }

  void printQuizState() {
    print('$_quizState');
  }

  String _selectedGettoneName = '';

  String get selectedGettoneName => _selectedGettoneName ?? '';

  bool _canChangeGettone = true;

  bool get canChangeGettone => _canChangeGettone;

  String _points = '';

  String get points => _points;

  List<u.User> _rank = <u.User>[u.User.nullo()];

  List<u.User> get rank => _rank;

  String _position = '';

  String get position => _position;

  void setSelectedGettone(String gettoneName) async {
    this._selectedGettoneName = gettoneName;
    this._canChangeGettone = false;
    Future.delayed(gettoneLockedDuration, () {
      this._canChangeGettone = true;
      // TODO update persisted state
      notifyListeners();
    });
    Future.delayed(gettoneExpiration, () {
      this._selectedGettoneName = null;
      // TODO update persisted state
      notifyListeners();
    });

    notifyListeners();
  }

  @deprecated
  void setPoints(String points) {
    this._points = points;
    notifyListeners();
  }

  void updateRankPositionPoints(List<u.User> rank) async {
    this._rank = rank;
    String myUid = FirebaseAuth.instance.currentUser.uid;
    this._position = (rank.indexWhere((element) {
              this._points = element.points.total.toString();
              return element.firebaseUid == myUid;
            }) +
            1)
        .toString();
    notifyListeners();
  }

  void addNewQuestions(List<Question> questions) {
    List<Question> registeredQuestions = this
        ._quizState
        .questionStates
        .map((qState) => qState.question)
        .toList();
    List<QuestionState> newQuestionStates = questions
        .where((q) => !registeredQuestions.contains(q))
        .map((q) => QuestionState(q))
        .toList();
    this._quizState.questionStates.addAll(newQuestionStates);
    this._quizState.persist();
  }

  void updateQuestionsVisibility(List<Question> questions) {
    List<Question> registeredQuestions = this
        ._quizState
        .questionStates
        .map((qState) => qState.question)
        .toList();
    List<Question> questionToUpdate = [];
    registeredQuestions.forEach((eR) {
      questions.forEach((eQ) {
        if (eR == eQ && eR.visible != eQ.visible) {
          eR.visible = !eR.visible;
          eR.demand = eQ.demand;
          eR.correctAnswer = eQ.correctAnswer;
          eR.demand = eQ.demand;
          eR.answer1 = eQ.answer1;
          eR.answer2 = eQ.answer2;
          eR.answer3 = eQ.answer3;
          eR.answer4 = eQ.answer4;
        }
      });
    });
    this
        ._quizState
        .questionStates
        .where((qS) => questionToUpdate.contains(qS.question))
        .forEach((qS) {
      qS.question.visible = !qS.question.visible;
    });
    this._quizState.persist();
  }

  void openQuestion(int index) {
    this
        ._quizState
        .questionStates
        .where((qState) => qState.question.index == index)
        .forEach((qState) {
      qState.opened = true;
    });
    this._quizState.persist();
    notifyListeners();
  }

  void registerAnswer(int index, int givenAnswerIndex) {
    this
        ._quizState
        .questionStates
        .where((qState) => qState.question.index == index)
        .forEach((qState) {
      qState.givenAnswerIndex = givenAnswerIndex;
      qState.completed = true;
    });
    this._quizState.persist();
    notifyListeners();
  }

  void completeQuestion(int index) {
    this
        ._quizState
        .questionStates
        .where((qState) => qState.question.index == index)
        .forEach((qState) {
      qState.completed = true;
    });
    this._quizState.persist();
    notifyListeners();
  }
}
