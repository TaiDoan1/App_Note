import 'package:appnote/screens/home_screen.dart';
import 'package:appnote/screens/splash_screen.dart';
import 'package:appnote/widgets/app_scaffold.dart';
import 'package:appnote/widgets/transaction_row.dart';
import 'package:flutter/material.dart';
import 'package:appnote/services/notification_service.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Note',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: const SplashScreen(),
      home: const SplashScreen()
    );
  }
}
