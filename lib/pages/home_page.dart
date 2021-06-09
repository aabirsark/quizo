import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quizo/core/my_provider.dart';
import 'package:quizo/models/quiz.dart';
import 'package:quizo/pages/quiz_page.dart';
import 'package:quizo/utils/card_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    context
        .read<ResultListCounter>()
        .changeList("https://opentdb.com/api.php?amount=25");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.green, Colors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: context.watch<ResultListCounter>().results == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Container(
                    child: MainScreen(),
                  ),
                ),
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.3),
            radius: 40,
            child: Icon(
              CupertinoIcons.profile_circled,
              size: 50,
              color: Colors.white,
            )),
        SizedBox(
          height: 20,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              context.watch<PointsProvider>().points.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 35),
            ),
            Text(
              "Points",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Divider(
          color: Colors.greenAccent,
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Play By Category",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: Structures.data
                        .map(
                          (e) => InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => QuizPage(
                                          topic: e.name,
                                          uri: e.uri,
                                          endColor: e.endColor,
                                          color: e.color)));
                            },
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width * 0.55,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                  colors: [e.color, e.endColor],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      e.name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily:
                                            GoogleFonts.roboto().fontFamily,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              /// color: Colors.white,
                            ),
                          ),
                        )
                        .toList()),
              )
            ],
          ),
        ),
        Divider(
          color: Colors.greenAccent,
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          "Random Quizo",
          style: TextStyle(
            color: Colors.white,
            fontFamily: GoogleFonts.zcoolKuaiLe().fontFamily,
          ),
          textScaleFactor: 2.5,
        ),
        Text(
          "right => +2pt wrong => -2pt left => 0pt",
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
        SizedBox(
          height: 30,
        ),
        Column(
            children: context
                .watch<ResultListCounter>()
                .results
                .map((e) => QuesTionCard(e: e))
                .toList())
      ],
    );
  }
}

class QuesTionCard extends StatefulWidget {
  final Results e;
  const QuesTionCard({
    Key key,
    @required this.e,
  }) : super(key: key);

  @override
  _QuesTionCardState createState() => _QuesTionCardState();
}

class _QuesTionCardState extends State<QuesTionCard> {
  bool showAns = false;

  void replaceShowAns() {
    setState(() {
      showAns = !showAns;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${widget.e.question}"
                      .replaceAll("&quot;", "")
                      .replaceAll("&#039;", ""),
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: widget.e.allOptions
                      .map((j) => OpButton(
                            e: j,
                            process: replaceShowAns,
                            show: showAns,
                            correctOption: widget.e.correctAnswer,
                          ))
                      .toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OpButton extends StatefulWidget {
  final e;
  final correctOption;
  final bool show;
  final process;
  const OpButton({
    @required this.correctOption,
    @required this.e,
    @required this.process,
    this.show = false,
    Key key,
  }) : super(key: key);

  @override
  _OpButtonState createState() => _OpButtonState();
}

class _OpButtonState extends State<OpButton> {
  Color color = Colors.grey[300];
  Color textColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    if (widget.show) {
      if (widget.e == widget.correctOption) {
        color = Colors.green;
        textColor = Colors.white;
      } else {}
    }

    return Column(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: ListTile(
            onTap: () {
              if (!widget.show) {
                if (widget.e == widget.correctOption) {
                  color = Colors.green;
                  widget.process();
                  textColor = Colors.white;
                  Provider.of<PointsProvider>(context, listen: false)
                      .changeInValue(2);
                } else {
                  color = Colors.red;
                  widget.process();
                  textColor = Colors.white;
                  Provider.of<PointsProvider>(context, listen: false)
                      .changeInValue(-2);
                }
              } else {}

              setState(() {});
            },
            tileColor: color,
            title: Text(
              widget.e.replaceAll("&quot;", "").replaceAll("&#039;", ""),
              style: TextStyle(color: textColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
