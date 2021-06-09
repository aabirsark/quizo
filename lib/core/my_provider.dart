import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:quizo/models/quiz.dart';
import 'package:http/http.dart' as http;
import 'package:quizo/utils/quizo.dart';

class ResultListCounter with ChangeNotifier, DiagnosticableTreeMixin {
  Ques quiz;
  List<Results> results;

  Future<void> changeList(String string) async {
    var res = await http.get(Uri.parse(string));
    var decRes = jsonDecode(res.body);
    print(decRes);
    quiz = Ques.fromJson(decRes);

    results = quiz.results;
    notifyListeners();
  }
}

class PointsProvider with ChangeNotifier {
  num _points = Quizo.prefs.getInt(Quizo.pointsKey) ?? 0;
  num _categoryPoints = 0;

  // getter of _points
  num get points => _points;
  num get categoryPoints => _categoryPoints;

  // setter of _points
  void changeInValue(int change) {
    _points += change;
    Quizo.prefs.setInt(Quizo.pointsKey, change);
    notifyListeners();
  }

  void changeInCategoryPoints(int change) {
    _categoryPoints += change;
    notifyListeners();
  }

  void catPoints(int points) {
    _categoryPoints = points;
  }
}
