import 'package:flutter/material.dart';
import 'package:tinder/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tinder',
      theme: ThemeData(
        primaryColor: const Color(0xFFEB606E),
      ),
      home: const MainPage(),
    );
  }
}
