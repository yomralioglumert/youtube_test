import 'package:flutter/material.dart';
import 'package:youtube_test/screens/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        home: HomeScreen(
          channelId: "UCAq1KgLIm2g8kaOjdxN7UKQ",
        ));
  }
}
