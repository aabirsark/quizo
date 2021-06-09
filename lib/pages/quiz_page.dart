import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:quizo/core/my_provider.dart';
import 'package:quizo/utils/card_list.dart';

class QuizPage extends StatefulWidget {
  final String topic;
  final String uri;
  final Color color;
  final Color endColor;

  QuizPage({Key key, this.topic, this.uri, this.color, this.endColor})
      : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  ParticularQuizQues quiz;
  List<ParticularQuizResults> results;
  bool continueProcess = false;
  final _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    initProcess();
  }

  void initProcess() async {
    await Future.delayed(Duration(seconds: 5));
    var res = await http.get(Uri.parse(widget.uri));
    var decRes = jsonDecode(res.body);
    quiz = ParticularQuizQues.fromJson(decRes);
    results = quiz.results;
    // ? making fellow points => 0
    Provider.of<PointsProvider>(context, listen: false).catPoints(0);
    // ? allowing the state to continue
    continueProcess = true;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.color,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [widget.color, widget.endColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: Center(
          child: continueProcess
              ? Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: PageView(
                      controller: _pageController,
                      scrollDirection: Axis.horizontal,
                      children:
                          results.map((e) => PageManager(results: e)).toList(),
                    ),
                  ),
                )
              : WaitingWidget(widget: widget),
        ),
      ),
      floatingActionButton: continueProcess
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pop(context);
                Provider.of<PointsProvider>(context, listen: false)
                    .changeInValue(
                        context.read<PointsProvider>().categoryPoints);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Score : ${context.read<PointsProvider>().categoryPoints}  / 20")));
              },
              label: Text("Submit"),
              backgroundColor: Colors.black54,
              icon: Icon(CupertinoIcons.pencil),
            )
          : SizedBox(),
    );
  }
}

class WaitingWidget extends StatelessWidget {
  const WaitingWidget({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final QuizPage widget;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.50,
        width: MediaQuery.of(context).size.width * 0.85,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                backgroundColor: widget.endColor,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Just a Moment",
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              Text(
                "Generating Quiz",
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PageManager extends StatefulWidget {
  final ParticularQuizResults results;

  const PageManager({Key key, @required this.results}) : super(key: key);

  @override
  _PageManagerState createState() => _PageManagerState();
}

class _PageManagerState extends State<PageManager> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Text(
              widget.results.question
                  .replaceAll("&quot;", "")
                  .replaceAll("&#039;", "")
                  .replaceAll("&shy;", "")
                  .replaceAll("&rdquo;", "")
                  .replaceAll("&ldquo;", ""),
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            QuizOptions(widget: widget)
          ],
        ),
      ),
    );
  }
}

class QuizOptions extends StatefulWidget {
  const QuizOptions({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final PageManager widget;

  @override
  _QuizOptionsState createState() => _QuizOptionsState();
}

class _QuizOptionsState extends State<QuizOptions> {
  void changeBool() {
    widget.widget.results.given = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.widget.results.allAnswers
          .map((e) => Options(
                changeBoolProcessCode: changeBool,
                txt: e,
                correctAns: widget.widget.results.correctAnswer,
                results: widget.widget.results,
              ))
          .toList(),
    );
  }
}

class Options extends StatefulWidget {
  final txt;
  final correctAns;
  final ParticularQuizResults results;
  final changeBoolProcessCode;

  const Options(
      {Key key,
      @required this.txt,
      @required this.changeBoolProcessCode,
      @required this.correctAns,
      @required this.results})
      : super(key: key);

  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  Color color = Colors.grey[300];
  Color textColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    if (widget.results.given) {
      if (widget.txt == widget.correctAns) {
        color = Colors.green;
        textColor = Colors.white;
      } else {
        color = Colors.red;
        textColor = Colors.white;
      }
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            onTap: () {
              if (!widget.results.given) {
                if (widget.txt == widget.correctAns) {
                  color = Colors.green;
                  textColor = Colors.white;
                  widget.changeBoolProcessCode();
                  Provider.of<PointsProvider>(context, listen: false)
                      .changeInCategoryPoints(2);
                  setState(() {});
                } else {
                  color = Colors.red;
                  textColor = Colors.white;
                  widget.changeBoolProcessCode();
                  Provider.of<PointsProvider>(context, listen: false)
                      .changeInCategoryPoints(-2);
                  setState(() {});
                }
              } else {}
            },
            tileColor: color,
            title: Text(
              widget.txt
                  .replaceAll("&quot;", "")
                  .replaceAll("&#039;", "")
                  .replaceAll("&shy;", "")
                  .replaceAll("&rdquo;", "")
                  .replaceAll("&ldquo;", ""),
              style: TextStyle(color: textColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
