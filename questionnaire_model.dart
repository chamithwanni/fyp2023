class Question {
  final String questionText;
  final List<Answer> answersList;
  int score= 0;

  Question(this.questionText, this.answersList);

  void updateScore(Answer selectedAnswer) {
    score = calculateMarks(selectedAnswer);
  }

  int calculateMarks(Answer selectedAnswer) {
    for (Answer answer in answersList) {
      if (selectedAnswer == answer) {
        return answer.marks;
      }
    }
    // Return 0 if the selected answer is not found in the answersList
    return 0;
  }
}

class Answer {
  final String answerText;
  final int marks;

  Answer(this.answerText,this.marks);
}

List<Question> getQuestions() {
  List<Question> list = [];
  //can add questions and answer here

  list.add(Question(
    "Moments in life when you feel strong That's it...",
    [
      Answer("Strongly Disagree",1),
      Answer("Disagree",2),
      Answer("Undecided",3),
      Answer("Agree",4),
      Answer("Strongly Agree",5)
    ],
  ));

  list.add(Question(
    "Imagine that happiness is always around you...",
    [
      Answer("Strongly Disagree",1),
      Answer("Disagree",2),
      Answer("Undecided",3),
      Answer("Agree",4),
      Answer("Strongly Agree",5)
    ],
  ));

  list.add(Question(
    "You enjoy traveling because you value mental freedom...",
    [
      Answer("Strongly Disagree",1),
      Answer("Disagree",2),
      Answer("Undecided",3),
      Answer("Agree",4),
      Answer("Strongly Agree",5)
    ],
  ));

  list.add(Question(
    "Looking at today's events, You thought you had a great day...",
    [
      Answer("Strongly Disagree",1),
      Answer("Disagree",2),
      Answer("Undecided",3),
      Answer("Agree",4),
      Answer("Strongly Agree",5)
    ],
  ));

  list.add(Question(
    "You suffered rare defeats in mental disorders and social conflicts...",
    [
      Answer("Strongly Disagree",1),
      Answer("Disagree",2),
      Answer("Undecided",3),
      Answer("Agree",4),
      Answer("Strongly Agree",5)
    ],
  ));
  return list;
}

