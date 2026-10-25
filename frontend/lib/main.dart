import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? timer;
  int elapsedSecond = 0;

  int correctChars = 0;
  static final String _targetChars =
      "The quick brown fox jumps over the lazy dog";
  static final List<String> chars = _targetChars.split('');
  bool isFinished = false;
  double wpm = 0;
  double accuracy = 0;
  int incorrect = 0;
  int totalCorrect = 0;
  int totalTyped = 0;
  String _previousText = "";

  final TextEditingController charController = TextEditingController();
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        elapsedSecond++;
      });
    });
  }

  void updateProgress() {
    final typed = charController.text;

    if (typed.length > _previousText.length) {
      for (int i = _previousText.length; i < typed.length; i++) {
        if (i < _targetChars.length) {
          totalTyped++;
          if (typed[i] == chars[i]) {
            totalCorrect++;
          }
        }
      }
    }
    _previousText = typed;

    int correct = 0;
    int wrong = 0;

    for (int i = 0; i < typed.length && i < _targetChars.length; i++) {
      if (typed[i] == chars[i]) {
        correct++;
      } else {
        wrong++;
      }
    }

    if (typed.length == 1 && timer == null) startTimer();
    if (typed.isEmpty && timer != null) {
      timer?.cancel();
      timer = null;
    }

    final finished = typed.length == _targetChars.length;
    if (finished) {
      timer?.cancel();
      timer = null;
    }

    final historicalAccuracy = totalTyped == 0
        ? 100.0
        : (totalCorrect / totalTyped) * 100;

    final wpmValue = elapsedSecond > 0 && finished
        ? (correct / 5) / (elapsedSecond / 60)
        : 0.0;

    setState(() {
      correctChars = correct;
      incorrect = wrong;
      if (finished) {
        accuracy = historicalAccuracy;
        wpm = wpmValue;
      }
      isFinished = finished;
    });
  }

  void resetRace() {
    timer?.cancel();
    charController.clear();
    timer = null;

    setState(() {
      elapsedSecond = 0;
      wpm = 0;
      correctChars = 0;
      accuracy = 100;
      isFinished = false;
      incorrect = 0;

      totalTyped = 0;
      totalCorrect = 0;
      _previousText = "";
    });
  }

  List<TextSpan> _buildCharacterSpan() {
    final spans = <TextSpan>[];
    final typed = charController.text;
    final currentIndex = typed.length;

    for (int i = 0; i < _targetChars.length; i++) {
      TextStyle style;

      if (i == currentIndex) {
        style = const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        );
      } else if (i < currentIndex) {
        if (typed[i] == chars[i]) {
          style = const TextStyle(color: Colors.green);
        } else {
          style = const TextStyle(color: Colors.redAccent);
        }
      } else {
        style = const TextStyle(color: Colors.black);
      }
      spans.add(TextSpan(text: chars[i], style: style));
    }
    return spans;
  }

  @override
  void dispose() {
    charController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Typing Race"), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text(
                        "TIME",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${elapsedSecond}s",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      const Text(
                        "WPM",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${wpm.toStringAsFixed(1)}%",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      const Text(
                        "ACCURACY",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        accuracy.toStringAsFixed(1),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 24, color: Colors.purple),
                children: _buildCharacterSpan(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 100,
                vertical: 30,
              ),
              child: TextField(
                controller: charController,
                readOnly: isFinished,
                onChanged: (_) => updateProgress(),
                decoration: const InputDecoration(
                  hintText: "Start typing here...",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(onPressed: resetRace, child: Text("Reset race")),
          ],
        ),
      ),
    );
  }
}
