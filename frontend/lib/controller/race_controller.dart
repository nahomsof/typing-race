import 'dart:async';

class RaceController {
  Timer? timer;
  int elapsedSecond = 0;

  int correctChars = 0;
  static final String targetChars =
      "The quick brown fox jumps over the lazy dog";
  static final List<String> chars = targetChars.split('');
  bool isFinished = false;
  double wpm = 0;
  double accuracy = 100;
  int incorrect = 0;
  int totalCorrect = 0;
  int totalTyped = 0;
  String previousText = "";

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsedSecond++;
    });
  }

  void dispose() {
    timer?.cancel();
  }

  void updateProgress(String typed) {
    if (typed.length > previousText.length) {
      for (int i = previousText.length; i < typed.length; i++) {
        if (i < targetChars.length) {
          totalTyped++;

          if (typed[i] == targetChars[i]) {
            totalCorrect++;
          }
        }
      }
    }
    previousText = typed;
    int correct = 0;
    int wrong = 0;

    if (typed.length == 1 && timer == null) {
      startTimer();
    }

    if (typed.isEmpty && timer != null) {
      timer?.cancel();
      timer = null;
    }

    final finished = typed.length == targetChars.length;
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

    correctChars = correct;
    incorrect = wrong;

    if (finished) {
      accuracy = historicalAccuracy;
      wpm = wpmValue;
    }

    isFinished = finished;
  }
}
