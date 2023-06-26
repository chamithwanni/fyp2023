import 'package:flutter/material.dart';
import 'package:project_final23/fourth_screen.dart';
import 'package:project_final23/self_questionnaire.dart';

class ThirdScreen extends StatelessWidget {
  ThirdScreen({Key? key, required this.emotion}) : super(key: key);

  final String emotion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Box'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
              child: Image.asset(
                'assets/images/logo_project.png',
                height: 60,
                width: 60,
                alignment: Alignment.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Would you like to answer the self questionnaire?',
                style: TextStyle(fontSize: 24.0),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to the questionnaire page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelfQuestionnaire(imgEmotion: emotion),
                      ),
                    );
                  },
                  icon: Icon(Icons.question_answer),
                  label: Text('Answer the Questionnaire'),
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to the fourth screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => 
                            FourthScreen(imgEmotion: emotion, qusEmotion: ""),
                      ),
                    );
                  },
                  icon: Icon(Icons.skip_next),
                  label: Text('Skip'),
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
