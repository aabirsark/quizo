import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Quizo {
  // ! routes
  static final String homePageRoute = "/";
  static final String quizPageRoute = "/quiz_page";

  // ! Shared Prefrences Keys !

  static SharedPreferences prefs;

  // ! sp keys;
  static final String pointsKey = "ktpionts";
}
