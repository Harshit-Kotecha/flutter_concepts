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
            const SizedBox(
              height: 30,
            ),
            TextField(
              decoration: const InputDecoration(
                label: Text('Search here'),
              ),
              onChanged: (value) {
                // Setting timer to stop making API calls on every change
                // ! However there is some bug, because this is just delaying the call
                // ! Not actually reducing the calls
                // ! So we need some other workaround
                Timer(const Duration(seconds: 3), () {
                  // Update state to show API call is made
                  setState(() {
                    showApiBtn = true;
                    apiTxt = 'Searching... $value';
                  });
                });
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
    );
  }
}
