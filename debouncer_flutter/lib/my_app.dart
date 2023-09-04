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
  String apiTxt = "";

  // A timer to reduce calls
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Debouncing API calls'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              TextField(
                decoration: const InputDecoration(
                  label: Text('Search here'),
                ),
                onChanged: (value) {
                  // Use timer to stop making API calls on every change
                  // Now it will only call timer if it is not running or null
                  // This saves API call
                  apiTxt = value;
                  _timer ??= Timer(
                      const Duration(seconds: 3),
                      () => setState(() {
                            showApiBtn = true;
                            apiTxt = 'Searching... $apiTxt';
                            _timer = null;
                          }));
                },
              ),
              const SizedBox(
                height: 30,
              ),
              if (showApiBtn)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(apiTxt),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
