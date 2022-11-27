import 'package:flutter/material.dart';

void main() {
  runApp(const GuessMyNumberApp());
}

class GuessMyNumberApp extends StatelessWidget {
  const GuessMyNumberApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GuessMyNumberMainPage(),
    );
  }
}

class GuessMyNumberMainPage extends StatefulWidget {
  const GuessMyNumberMainPage({super.key});

  @override
  State<GuessMyNumberMainPage> createState() => _GuessMyNumberMainPageState();
}

class _GuessMyNumberMainPageState extends State<GuessMyNumberMainPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
