import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
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

  final TextEditingController charController = TextEditingController();
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        elapsedSecond++;
      });
    });
  }

  void updateTypingProgress() {
    final typed = charController.text;

    int correct = 0;

    for (int i = 0; i < typed.length && i < _targetChars.length; i++) {
      if (chars[i] == typed[i]) {
        correct++;
      }
    }

    if (typed.length == 1 && timer == null) {
      startTimer();
    }

    if (typed.length == _targetChars.length) {
      isFinished = true;
      if (elapsedSecond > 0) {
        wpm = correctChars / 5 / (elapsedSecond / 60);
      }
      timer?.cancel();
      timer = null;
    }

    setState(() {
      correctChars = correct;
      if (typed.length == _targetChars.length) {
        isFinished = true;
        accuracy = correct / typed.length * 100;
      }
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
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text("Time: ${elapsedSecond}s"),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 24, color: Colors.purple),
                children: _buildCharacterSpan(),
              ),
            ),
            Text(
              "Correct characters: $correctChars \n Typed characters: ${charController.text.length} accuracy: ${accuracy.toStringAsFixed(1)}%   ${isFinished ? "\n Finshed" : ""} ${wpm == 0 ? "" : wpm.toStringAsFixed(1)} ",
            ),
            TextField(
              controller: charController,
              onChanged: (_) => updateTypingProgress(),
            ),
          ],
        ),
      ),
    );
  }
}
