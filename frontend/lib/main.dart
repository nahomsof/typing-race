import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _typedCharacters = 0;
  final TextEditingController typingController = TextEditingController();

  void typedCharacters() {
    setState(() {
      _typedCharacters = typingController.text.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('You have written this amount of words'),
            Text(
              'Characters: $_typedCharacters',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            
            TextField(
              controller: typingController,
              onChanged: (value) => typedCharacters(),
            ),
          ],
        ),
      ),
    );
  }
}
