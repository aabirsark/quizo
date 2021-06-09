import 'package:flutter/material.dart';

class Data {
  final name;
  final uri;
  final endColor;
  final color;

  Data(
      {@required this.name,
      this.endColor,
      @required this.uri,
      @required this.color});
}

class Structures {
  // ? this class is made for keeping all the data
  static List<Data> data = [
    Data(
        name: "General Knowladge",
        color: Colors.cyanAccent,
        endColor: Colors.cyan,
        uri: "https://opentdb.com/api.php?amount=10&category=9"),
    Data(
        name: "Mythology",
        color: Colors.amber,
        endColor: Colors.orange,
        uri: "https://opentdb.com/api.php?amount=10&category=9"),
    Data(
        name: "Music",
        color: Colors.blue,
        endColor: Colors.blueAccent,
        uri: "https://opentdb.com/api.php?amount=10&category=9"),
    Data(
        name: "Geography",
        color: Colors.red[400],
        endColor: Colors.redAccent,
        uri: "https://opentdb.com/api.php?amount=10&category=9"),
    Data(
        name: "Politics",
        color: Colors.tealAccent,
        endColor: Colors.teal,
        uri: "https://opentdb.com/api.php?amount=10&category=9"),
  ];
}

// ? this is for category based ques
class ParticularQuizQues {
  int responseCode;
  List<ParticularQuizResults> results;

  ParticularQuizQues({this.responseCode, this.results});

  ParticularQuizQues.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    if (json['results'] != null) {
      results = new List<ParticularQuizResults>();
      json['results'].forEach((v) {
        results.add(new ParticularQuizResults.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ParticularQuizResults {
  String category;
  String type;
  String difficulty;
  String question;
  bool given = false;
  String ans;
  String correctAnswer;
  List<String> allAnswers;

  ParticularQuizResults(
      {this.category,
      this.type,
      this.difficulty,
      this.question,
      this.correctAnswer,
      this.allAnswers});

  ParticularQuizResults.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    type = json['type'];
    difficulty = json['difficulty'];
    question = json['question'];
    correctAnswer = json['correct_answer'];
    allAnswers = json['incorrect_answers'].cast<String>();
    allAnswers.add(correctAnswer);
    allAnswers.shuffle();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['type'] = this.type;
    data['difficulty'] = this.difficulty;
    data['question'] = this.question;
    data['correct_answer'] = this.correctAnswer;
    data['incorrect_answers'] = this.allAnswers;
    return data;
  }
}
