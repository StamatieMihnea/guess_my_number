import 'dart:math';
import 'package:flutter/material.dart';

const int lowerNumberLimit = 1;
const int upperNumberLimit = 100;
const String appTitle = 'Guess my number';

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
  late final Random randomizer;
  int randomlyPickedNumber = 0;
  TextEditingController textFieldController = TextEditingController();
  bool shouldReset = false;
  int? typedNumber;
  String? errorText;

  @override
  void initState() {
    super.initState();
    final int seed = DateTime.now().millisecondsSinceEpoch;
    randomizer = Random(seed);
    randomlyPickedNumber = randomizer.nextInt(upperNumberLimit) + lowerNumberLimit;
  }

  String getHintMessage(int number) {
    String numberRelationMessage;
    if (number == randomlyPickedNumber) {
      numberRelationMessage = 'You guessed the right.';
    } else if (number > randomlyPickedNumber) {
      numberRelationMessage = 'Try lower';
    } else {
      numberRelationMessage = 'Try higher';
    }
    return 'You tried $number\n $numberRelationMessage';
  }

  void popAlertDialog() {
    showDialog<bool>(
      context: context,
      builder: (BuildContext buildContext) => AlertDialog(
        title: const Text('You guessed right'),
        content: Text('It was $randomlyPickedNumber'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              setState(() {
                randomlyPickedNumber = randomizer.nextInt(upperNumberLimit) + lowerNumberLimit;
              });
              Navigator.pop(buildContext, false);
            },
            child: const Text('Try again!'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(buildContext, true);
            },
            child: const Text('Ok'),
          )
        ],
      ),
    ).then((bool? value) {
      if (value != null) {
        setState(() {
          shouldReset = value;
          typedNumber = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            appTitle,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Text(
                "I'm thinking of a number between $lowerNumberLimit and $upperNumberLimit.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "It's your turn to guess my number!",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              if (typedNumber != null)
                Text(
                  getHintMessage(typedNumber!),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 40,
                  ),
                ),
              Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Try a number!',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: textFieldController,
                        decoration: InputDecoration(
                          errorText: errorText,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (!shouldReset) {
                            setState(() {
                              typedNumber = int.tryParse(textFieldController.value.text);
                            });
                            if (typedNumber == null) {
                              setState(() {
                                errorText = 'Please enter a valid number!';
                              });
                            } else {
                              setState(() {
                                errorText = null;
                              });
                              if (typedNumber == randomlyPickedNumber) {
                                popAlertDialog();
                              }
                            }
                            textFieldController.clear();
                          } else {
                            setState(() {
                              randomlyPickedNumber = randomizer.nextInt(upperNumberLimit) + lowerNumberLimit;
                              shouldReset = false;
                            });
                          }
                        },
                        child: Text(
                          shouldReset ? 'Reset' : 'Guess',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
