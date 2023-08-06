import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quiz_app/QuestionBank.dart';

void main() => runApp(const Quizzler());

// Creates an audio player object for playing true or false sounds, check out the audio player package for more...
AudioPlayer player = AudioPlayer();

// Makes an instance of the questionbrain class that contains the questions and answer data.
QuestionBrain questionBrain = QuestionBrain();
bool? selectedOption;

class Quizzler extends StatelessWidget {

  const Quizzler

  ({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage

  ({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

  String currentQuestion = questionBrain.getQuestion();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Card(
            color: Colors.white70,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  currentQuestion,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25.0,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ),
        ),

        Expanded(
          child: Card(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () async {
                setSelectedOption(true);
                await verifyAnswer();
              }

              ,
            ),
          ),
        ),
        Expanded(
          child: Card(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                setSelectedOption(false);
                await verifyAnswer();
              },
            ),
          ),
        ),

      ],
    );
  }


  Future<void> verifyAnswer() async {
    if (questionBrain.isCorrect(selectedOption ?? false)) {
      await playSoundAlert(1);
    } else {
      playSoundAlert(2);
    }
    setState(() {
      currentQuestion = nextQuestion();
    });
  }

  String nextQuestion() => questionBrain.getQuestion();

  Future<void> playSoundAlert(int number) async {
    await player.setAsset('asset/audio/tone$number.wav');
    player.play();
  }

  void setSelectedOption(bool option) => selectedOption = option;


}


