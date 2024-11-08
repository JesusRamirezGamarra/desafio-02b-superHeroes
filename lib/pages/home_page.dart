import 'package:flutter/material.dart';
import 'dart:math';
import 'package:superheroes/models/super_hero.dart';
import 'package:superheroes/widgets/answer_button.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int correctAnswers = 0;
  int incorrectAnswers = 0;
  final int totalQuestions = 5; // Número total de preguntas para finalizar el juego
  late Superhero currentSuperhero;
  List<String> answerOptions = [];
  
  final List<Color> buttonColors = [
    Colors.purple, 
    Colors.teal,   
    Colors.amber,  
    Colors.red,    
  ];

  final List<Superhero> superheroes = [
    Superhero(name: 'Goku Super Sayayin FASE:1', imageNumber: 1),
    Superhero(name: 'Goku Super Sayayin FASE:3', imageNumber: 2),
    Superhero(name: 'Vegeta Super Sayayin FASE:2', imageNumber: 3),
    Superhero(name: 'Goku Super Sayayin FASE:Dios', imageNumber: 4),
    Superhero(name: 'Jiren', imageNumber: 5),
    Superhero(name: 'Bils', imageNumber: 6),
    Superhero(name: 'Golden Freezer', imageNumber: 7),
    Superhero(name: 'Gohan Super sayayin FASE:2', imageNumber: 8),
    Superhero(name: 'Trunks', imageNumber: 9),
    Superhero(name: 'Goku', imageNumber: 10),
    Superhero(name: 'Goku Super Sayayin FASE:4', imageNumber: 11),
    Superhero(name: 'Vegeta Majin', imageNumber: 12),
    Superhero(name: 'Vermouth', imageNumber: 13),
    Superhero(name: 'Krilin', imageNumber: 14),
    Superhero(name: 'Goku Blue', imageNumber: 15),
    Superhero(name: 'Vegeta Blue', imageNumber: 16),
    Superhero(name: 'Freezer', imageNumber: 17),
    Superhero(name: 'Vegeta', imageNumber: 18),
    Superhero(name: 'Majin Boo', imageNumber: 19),
    Superhero(name: 'Majin Boo KID', imageNumber: 20),
  ];

  @override
  void initState() {
    super.initState();
    _loadNewQuestion();
  }

  void _loadNewQuestion() {
    setState(() {
      currentSuperhero = superheroes[Random().nextInt(superheroes.length)];
      answerOptions = [currentSuperhero.name];
      while (answerOptions.length < 4) {
        String randomName = superheroes[Random().nextInt(superheroes.length)].name;
        if (!answerOptions.contains(randomName)) {
          answerOptions.add(randomName);
        }
      }
      answerOptions.shuffle();
    });
  }

  void _checkAnswer(String answer) {
    setState(() {
      if (answer == currentSuperhero.name) {
        correctAnswers++;
      } else {
        incorrectAnswers++;
      }

      if (correctAnswers + incorrectAnswers >= totalQuestions) {
        _showEndGameDialog();
      } else {
        _loadNewQuestion(); 
      }
    });
  }

  void _showEndGameDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Fin del Juego"),
          content: Text(
            "¡Has completado el juego!\n\n"
            "Correctas: $correctAnswers\n"
            "Incorrectas: $incorrectAnswers",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame(); // Reiniciar el juego
              },
              child: const Text("Reiniciar"),
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      correctAnswers = 0;
      incorrectAnswers = 0;
      _loadNewQuestion(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '¿Cómo se llama el superhéroe?',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 50.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                  minWidth: double.infinity,
                ),
                child: Image.asset(
                  'assets/images/${currentSuperhero.imageNumber}.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: answerOptions.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return AnswerButton(
                  label: answerOptions[index],
                  color: buttonColors[index % buttonColors.length],
                  onPressed: () => _checkAnswer(answerOptions[index]),
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          Text(
            '[ Correctas: $correctAnswers  |  Incorrectas: $incorrectAnswers  ] de $totalQuestions Preguntas',
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}
