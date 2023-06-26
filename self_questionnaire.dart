import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:project_final23/fourth_screen.dart';
import 'questionnaire_model.dart';

class SelfQuestionnaire extends StatefulWidget {
  final String imgEmotion;
  SelfQuestionnaire({Key? key, required this.imgEmotion}) : super(key: key);

  @override
  State<SelfQuestionnaire> createState() => _SelfQuestionnaireState();
}

class _SelfQuestionnaireState extends State<SelfQuestionnaire> {
  List<Question> questionList = getQuestions();
  int currentQuestionIndex = 0;
  int totalMarks = 0;
  List<Answer?> selectedAnswers = List.filled(5, null);
  late String setEmotion = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Self Questionnaire"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _statusBar(),
          _questionWidget(),
          _answerList(),
          _nextButton(),
        ]),
      ),
    );
  }

  _statusBar() {
    return LinearProgressIndicator(
      value: (currentQuestionIndex + 1) / questionList.length,
      minHeight: 8,
      backgroundColor: Colors.grey[300],
      valueColor: AlwaysStoppedAnimation<Color>(
        currentQuestionIndex == questionList.length - 1
            ? Colors.green
            : Colors.blue,
      ),
    );
  }

  _questionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            questionList[currentQuestionIndex].questionText,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }

  _answerList() {
    return Column(
      children: questionList[currentQuestionIndex]
          .answersList
          .map(
            (e) => _answerButton(e),
          )
          .toList(),
    );
  }

  Widget _answerButton(Answer answer) {
    int index = questionList[currentQuestionIndex].answersList.indexOf(answer);
    bool isSelected = selectedAnswers.isNotEmpty &&
        selectedAnswers[currentQuestionIndex] == answer;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 48,
      child: ElevatedButton(
        child: Text(answer.answerText),
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          primary: isSelected ? Colors.orangeAccent : Colors.blue,
          onPrimary: isSelected ? Colors.black : Colors.black,
        ),
        onPressed: () {
          setState(() {
            selectedAnswers[currentQuestionIndex] = answer;
          });
        },
      ),
    );
  }

  _nextButton() {
    bool isLastQuestion = currentQuestionIndex == questionList.length - 1;
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 48,
      child: ElevatedButton(
        child: Text(isLastQuestion ? "Submit" : "Next"),
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          primary: Colors.blueGrey,
          onPrimary: Colors.white,
        ),
        onPressed: () {
          if (isLastQuestion) {
            for (Question question in questionList) {
              if (selectedAnswers[currentQuestionIndex] != null) {
                question.updateScore(selectedAnswers[currentQuestionIndex]!);
              }
              totalMarks += question.score;
            }
            if (totalMarks == 5) {
              setEmotion = "Happy";
            } else if (totalMarks >= 1 && totalMarks <= 4) {
              setEmotion = "Natural";
            } else if (totalMarks == 0) {
              setEmotion = "Sad";
            }
            print(setEmotion);
            print(widget.imgEmotion);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FourthScreen(
                  imgEmotion: widget.imgEmotion,
                  qusEmotion: setEmotion,
                ),
              ),
            );
          } else {
            //next question
            setState(() {
              // selectedAnswers = [];
              currentQuestionIndex++;
            });
          }
        },
      ),
    );
  }
}
