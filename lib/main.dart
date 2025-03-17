import 'dart:async';

import 'package:agendometro/Pages/HomePage.dart';
import 'package:agendometro/Pages/HomePage2.dart';
import 'package:agendometro/Pages/LoginPage.dart';
import 'package:agendometro/Pages/RegistrarPage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: SplashScreen(),
      title: 'Flutter Demo',
      initialRoute: 'splash',
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        'splash': (BuildContext context) => SplashScreen(),
        '/': (BuildContext context) => LoginPage(),
        'home': (BuildContext context) => HomePage(),
        'home2': (BuildContext context) => HomePage2(),
        'registrar': (BuildContext context) => RegistrarPage(),
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', 'ES'), // Español de España
      ],
      locale: const Locale('es', 'ES'),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Esperar 2 segundos y luego navegar a la pantalla principal
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacementNamed(context, '/'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
          child: SizedBox(
        width: double.infinity,
        height: 300,
        child: Image.asset("assets/loggo.png"),
      )),
    );
  }
}
