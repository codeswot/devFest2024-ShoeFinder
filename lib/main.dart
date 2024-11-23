import 'package:flutter/material.dart';
import 'package:shoe_finder/view/ocassion.dart';

void main() {
  runApp(const ShoeFinderApp());
}

class ShoeFinderApp extends StatelessWidget {
  const ShoeFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gemini Shoe Finder',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: OccasionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
