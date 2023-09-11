import 'dart:async';

import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // A boolean and text to show whether we are making API calls or not
  bool showApiBtn = false;
  String apiTxt = "no api calls now";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Debouncing API calls'),
        ),
        body: Column(
          children: [
            Text('data'),
          ],
        ),
      ),
    );
  }
}
