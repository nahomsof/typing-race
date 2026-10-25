import 'package:flutter/material.dart';

class RaceStats extends StatelessWidget {
  final int elapsedSecond;
  final double wpm;
  final double accuracy;
  const RaceStats({
    super.key,
    required this.accuracy,
    required this.elapsedSecond,
    required this.wpm,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              const Text(
                "TIME",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                "${elapsedSecond}s",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ],
          ),

          Column(
            children: [
              const Text(
                "WPM",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                wpm.toStringAsFixed(1),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ],
          ),

          Column(
            children: [
              const Text(
                "ACCURACY",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                "${accuracy.toStringAsFixed(1)}%",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
