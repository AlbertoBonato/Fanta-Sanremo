import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanta_sanremo/state/quiz_state.dart';
import 'package:fanta_sanremo/state/app_state.dart';
import 'package:fanta_sanremo/screens/quiz/quiz_timer.dart';
import 'package:fanta_sanremo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fanta_sanremo/models/question.dart';
import 'package:fanta_sanremo/services/database.dart';
import 'package:fanta_sanremo/utils/theme.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _completeQuestion(int questionIndex) {
    print('completed question');
    context.read<AppState>().completeQuestion(questionIndex);
  }

  _submitAnswer(Question question, int optionIndex) async {
    print('submitted answer');
    bool guessed = (question.correctAnswer == optionIndex);
    DocumentReference newEvent = await addQuestionEvent(question.index, guessed);
    if (guessed && newEvent != null && newEvent.id != null) {
      updatePointsAfterQuestion(newEvent.id);
    } else {
      print('Error adding question event');
    }
    context.read<AppState>().registerAnswer(question.index, optionIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz"),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              image: AssetImage('assets/images/modugno_3.jpg'),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 32),
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(8),
                                topRight: Radius.circular(68),
                              ),
                              color: color_b1.withOpacity(0.6),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.black38,
                                    offset: Offset(2, 2),
                                    blurRadius: 10.0),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 32, left: 32),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(68),
                                ),
                                color: color_b1.withOpacity(0.6),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.black38,
                                      offset: Offset(0, 2),
                                      blurRadius: 10.0),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Consumer<AppState>(builder: (context, state, child) {
                    List<QuestionState> questionStates =
                        state.quizState.questionStates;
                    return PageView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _pageController,
                      itemCount: questionStates.length,
                      itemBuilder: (ctx, i) {
                        QuestionState qState = questionStates[i];
                        int questionIndex = qState.question.index;
                        if (!qState.question.visible) return HiddenQuestion();
                        if (qState.completed)
                          return CompletedQuestion(questionState: qState);
                        return qState.opened
                            ? DisclosedQuestion(
                                question: qState.question,
                                onQuestionCompleted: _completeQuestion,
                                onAnswerSubmitted: _submitAnswer,
                              )
                            : ClosedQuestion(
                                questionIndex: questionIndex);
                      },
                    );
                  }),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CompletedQuestion extends StatelessWidget {
  final QuestionState questionState;

  CompletedQuestion({@required this.questionState});

  @override
  Widget build(BuildContext context) {
    int outcomeIndex = 0;
    if (questionState.givenAnswerIndex != 0)
      outcomeIndex = (questionState.question.correctAnswer ==
              questionState.givenAnswerIndex)
          ? 1
          : 2;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding:
              const EdgeInsets.only(top: 64, left: 32, right: 64, bottom: 32),
          child: Text(
            '${questionState.question.index}. ${questionState.question.demand}',
            style: TextStyle(
                color: color_b5, fontWeight: FontWeight.w600, fontSize: 20),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 100, top: 68),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.from([1, 2, 3, 4].map((e) => CompletedAnswerOption(
                  optionIndex: e,
                  qState: questionState,
                ))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Container(
            height: 64,
            color: outcomes[outcomeIndex].color,
            child: Center(
                child: Text(
              outcomes[outcomeIndex].message,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w900),
            )),
          ),
        )
      ],
    );
  }
}

class ClosedQuestion extends StatefulWidget {
  final int questionIndex;

  ClosedQuestion({@required this.questionIndex});

  @override
  _ClosedQuestionState createState() => _ClosedQuestionState();
}

class _ClosedQuestionState extends State<ClosedQuestion> {

  _startTimer() {
    context.read<AppState>().openQuestion(widget.questionIndex);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: _startTimer,
          child: Container(
            height: 182,
            padding:
                const EdgeInsets.only(top: 64, left: 32, right: 64, bottom: 0),
            child: Text(
              '${this.widget.questionIndex}. Mostra la domanda!',
              style: TextStyle(
                  color: color_b5, fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }
}

class HiddenQuestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding:
              const EdgeInsets.only(top: 64, left: 32, right: 64, bottom: 32),
          child: Text(
            '???',
            style: TextStyle(
                color: color_b5, fontWeight: FontWeight.w600, fontSize: 20),
          ),
        ),
      ],
    );
  }
}

/*
Called when the question is disclosed for the first time
 */
class DisclosedQuestion extends StatefulWidget {
  final Question question;
  final Function(int) onQuestionCompleted;
  final Function(Question, int) onAnswerSubmitted;
  DisclosedQuestion(
      {@required this.question,
      this.onQuestionCompleted,
      this.onAnswerSubmitted});

  @override
  _DisclosedQuestionState createState() => _DisclosedQuestionState();
}

class _DisclosedQuestionState extends State<DisclosedQuestion> {
  bool canAnswer = true;

  _timerOverListener() {
    widget.onQuestionCompleted(widget.question.index);
    setState(() {
      canAnswer = false;
    });
  }

  @override
  void dispose() {
    widget.onQuestionCompleted(widget.question.index);
    super.dispose();
  }

  _answerSubmitted(int optionIndex) {
    widget.onAnswerSubmitted(widget.question, optionIndex);
    setState(() {
      canAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding:
              const EdgeInsets.only(top: 64, left: 32, right: 64, bottom: 32),
          child: Text(
            '${widget.question.index}. ${widget.question.demand}',
            style: TextStyle(
                color: color_b5, fontWeight: FontWeight.w600, fontSize: 20),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 100, top: 68),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:
                  List.from([1, 2, 3, 4].map((idx) => DisclosedAnswerOption(
                        optionIndex: idx,
                        question: widget.question,
                        canAnswer: this.canAnswer,
                        onResponseSubmitted: _answerSubmitted,
                      )))),
        ),
        Container(
          padding: const EdgeInsets.only(left: 32),
          child: QuizTimer(
            questionIndex: widget.question.index,
            onTimerCompleted: _timerOverListener,
          ),
        )
      ],
    );
  }
}

class DisclosedAnswerOption extends StatelessWidget {
  final int optionIndex;
  final Question question;
  final bool canAnswer;
  final Function(int) onResponseSubmitted;
  DisclosedAnswerOption(
      {this.optionIndex,
      this.question,
      this.canAnswer,
      this.onResponseSubmitted});

  @override
  Widget build(BuildContext context) {
    String answer = '';
    switch (optionIndex) {
      case 1:
        answer = question.answer1;
        break;
      case 2:
        answer = question.answer2;
        break;
      case 3:
        answer = question.answer3;
        break;
      case 4:
        answer = question.answer4;
        break;
    }
    return GestureDetector(
      onTap: () async {
        if (this.canAnswer) {
          onResponseSubmitted(optionIndex);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 32),
        child: Container(
          child: Text(
            '$optionIndex. $answer',
            style: TextStyle(
                fontSize: 18, color: color_b5, fontWeight: FontWeight.w900),
          ),
        ),
      ),
    );
  }
}

class CompletedAnswerOption extends StatelessWidget {
  final int optionIndex;
  final QuestionState qState;
  CompletedAnswerOption({this.optionIndex, this.qState});

  @override
  Widget build(BuildContext context) {
    Question question = qState.question;
    String answer = '';
    switch (optionIndex) {
      case 1:
        answer = question.answer1;
        break;
      case 2:
        answer = question.answer2;
        break;
      case 3:
        answer = question.answer3;
        break;
      case 4:
        answer = question.answer4;
        break;
    }
    Color textColor = color_b5;
    if (qState.givenAnswerIndex != 0) {
      if (qState.givenAnswerIndex == optionIndex) {
        textColor =
            optionIndex == question.correctAnswer ? Colors.green : Colors.red;
      } else if (question.correctAnswer == optionIndex) {
        textColor = Colors.green;
      }
    } else if (question.correctAnswer == optionIndex) {
      textColor = Colors.blueGrey;
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 32),
      child: Container(
        child: Text(
          '$optionIndex. $answer',
          style: TextStyle(
              fontSize: 18, color: textColor, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}
