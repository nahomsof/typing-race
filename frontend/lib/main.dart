import 'package:flutter/material.dart';

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
  int correctChars = 0;
  static final String _targetChars =
      "The quick brown fox jumps over the lazy dog";
  static final List<String> chars = _targetChars.split('');
  bool isFinished = false;
  double accuracy = 0;
  final TextEditingController charController = TextEditingController();
  void updateTypingProgress() {
    final typed = charController.text;
    int correct = 0;

    for (int i = 0; i < typed.length && i < _targetChars.length; i++) {
      if (chars[i] == typed[i]) {
        correct++;
      }
    }

    setState(() {
      correctChars = correct;
      if (typed.length == _targetChars.length) {
        isFinished = true;
        accuracy = correctChars / typed.length * 100;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 24, color: Colors.purple),
                children: _buildCharacterSpan(),
              ),
            ),
            Text(
              "Correct characters: $correctChars \n Typed characters: ${charController.text.length} accuracy: ${accuracy.toStringAsFixed(1)}%   ${isFinished ? "\n Finshed" : ""} ",
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
