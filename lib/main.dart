import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quizo/core/my_provider.dart';
import 'package:quizo/pages/home_page.dart';
import 'package:quizo/utils/quizo.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ResultListCounter()),
      ChangeNotifierProvider(create: (_) => PointsProvider())
    ],
    child: MyApp(),
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  Quizo.prefs = await SharedPreferences.getInstance();

  // Future<SharedPreferences> Quizo.prefs = await SharedPreferences.getInstance();
  // PointsProvider.setValue(Quizo.prefs.getInt(Quizo.pointsKey));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.red,
          accentColor: Colors.black,
          fontFamily: GoogleFonts.poppins().fontFamily),
      home: HomePage(),
    );
  }
}
