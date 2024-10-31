import 'package:flutter/material.dart';

void main() {
  runApp(QuizApp());
}

class _QuizAppState extends State<QuizApp> {
  int _questionIndex = 0;
  int _totalScore = 0;

  void _responder(int score) {
    setState(() {
      _totalScore += score;
      _questionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, Object>> perguntas = [
      {
        'texto': '1 - Qual é a verdadeira identidade do Superman?',
        'respostas': [
          {'text': 'Bruce Wayne', 'score': 0},
          {'text': 'Clark Kent', 'score': 1},
          {'text': 'Hal Jordan', 'score': 0},
          {'text': 'Oliver Queen', 'score': 0},
        ],
      },
      {
        'texto': '2 - Qual é o nome da cidade natal do Batman?',
        'respostas': [
          {'text': 'Metropolis', 'score': 0},
          {'text': 'Gotham City', 'score': 1},
          {'text': 'Star City', 'score': 0},
          {'text': 'Central City', 'score': 0},
        ],
      },
      {
        'texto': '3 - Qual cor representa a ganância entre os lanternas?',
        'respostas': [
          {'text': 'Verde', 'score': 0},
          {'text': 'Azul', 'score': 0},
          {'text': 'Vermelho', 'score': 0},
          {'text': 'Laranja', 'score': 1},
        ],
      },
      {
        'texto': '4 - Qual dos seguintes personagens é um Lanterna Verde?',
        'respostas': [
          {'text': 'Barry Allen', 'score': 0},
          {'text': 'Arthur Curry', 'score': 0},
          {'text': 'Billy Batson', 'score': 0},
          {'text': 'John Stewart', 'score': 1},
        ],
      },
      {
        'texto': '5 - Qual é o nome do arqui-inimigo do Flash?',
        'respostas': [
          {'text': 'Lex Luthor', 'score': 0},
          {'text': 'Cheetah', 'score': 0},
          {'text': 'Zoom', 'score': 1},
          {'text': 'Duas-Caras', 'score': 0},
        ],
      },
      {
        'texto': '6 - Qual é o nome do planeta natal de Superman?',
        'respostas': [
          {'text': 'Júpiter', 'score': 0},
          {'text': 'Krypton', 'score': 1},
          {'text': 'Terra', 'score': 0},
          {'text': 'Apokolips', 'score': 0},
        ],
      },
      {
        'texto': '7 - Qual é a identidade secreta do Arqueiro Verde?',
        'respostas': [
          {'text': 'Oliver Queen', 'score': 1},
          {'text': 'Hal Jordan', 'score': 0},
          {'text': 'Bruce Wayne', 'score': 0},
          {'text': 'Dick Grayson', 'score': 0},
        ],
      },
      {
        'texto': '8 - Quem é o vilão que frequentemente enfrenta a Mulher Maravilha?',
        'respostas': [
          {'text': 'Luthor', 'score': 0},
          {'text': 'Ares', 'score': 1},
          {'text': 'Sinestro', 'score': 0},
          {'text': 'Brainiac', 'score': 0},
        ],
      },
      {
        'texto': '9 - Qual é o nome do lado obscuro da Liga da Justiça, que inclui vilões como Lex Luthor?',
        'respostas': [
          {'text': 'Sociedade da Justiça', 'score': 0},
          {'text': 'Injustiça', 'score': 0},
          {'text': 'Liga da Injustiça', 'score': 0},
          {'text': 'Sociedade Secreta dos Supervilões', 'score': 1},
        ],
      },
      {
        'texto': '10 - Qual Robin se torna conhecido como Capuz Vermelho?',
        'respostas': [
          {'text': 'Dick Grayson', 'score': 0},
          {'text': 'Tim Drake', 'score': 0},
          {'text': 'Jason Todd', 'score': 1},
          {'text': 'Damian Wayne', 'score': 0},
        ],
      },
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Perguntas'),
        ),
        body: _questionIndex < perguntas.length ? Column(
          children: [
            Center(
              child: Expanded(
                flex: 3,
                child: Image.network(
                  'https://d9radp1mruvh.cloudfront.net/media/challenge_img/509655_shutterstock_1506580442_769367.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                perguntas[_questionIndex]['texto'] as String,
                style: const TextStyle(fontSize: 28),
              ),
            ), // Diminui o espaço entre a imagem e a pergunta
            SizedBox(height: 16), // Espaçamento entre a pergunta e os botões
            ...(perguntas[_questionIndex]['respostas'] as List<Map<String, Object>>).map((answer) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8), // Espaçamento entre os botões
                child: ElevatedButton(
                  onPressed: () => _responder(answer['score'] as int),
                  child: Text(answer['text'] as String),
                ),
              );
            }).toList(),
          ],
        )
        : Center(
          child: Text(
            'Pontuação Total: $_totalScore',
            style: const TextStyle(fontSize: 36),
          ),
        ),
      ),
    );
  }
}

class QuizApp extends StatefulWidget {
  @override
  _QuizAppState createState() {
    return _QuizAppState();
  }
}