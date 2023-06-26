import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_final23/fourth_screen.dart';
import 'package:project_final23/user_account/login_screen.dart';
import 'package:project_final23/user_account/signin_screen.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'second_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget example2 = SplashScreenView(
      navigateRoute: LogInScreen(),
      duration: 6000,
      imageSize: 130,
      imageSrc: "assets/images/logo_project.png",
      text: "Music Box",
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30.0,
      ),
      colors: [
        Colors.purple,
        Colors.blue,
        Colors.yellow,
        Colors.red,
      ],
      backgroundColor: Colors.white,
    );

    return MaterialApp(
      title: 'Music Box',
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 500,
              child: example2,
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/spotify_logo.png",
                  height: 30.0,
                ),
                SizedBox(width: 10.0),
                Text(
                  "Powered by Spotify",
                  style: TextStyle(fontSize: 15.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
