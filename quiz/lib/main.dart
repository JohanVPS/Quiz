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

  void _voltar() {
    if (_questionIndex > 0) {
      setState(() {
        _questionIndex--;
        _totalScore -= 1; // Subtrai um ponto ao voltar para a pergunta anterior
      });
    }
  }

  void _reiniciarQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0; // Reinicia a pontuação
    });
  }

  @override
  Widget build(BuildContext context) {
    const int certa = 1;
    const int errada = 0;
    final List<Map<String, Object>> perguntas = [
      {
        'texto': '1 - Qual é a verdadeira identidade do Superman?',
        'respostas': [
          {'text': 'Bruce Wayne', 'score': errada},
          {'text': 'Clark Kent', 'score': certa},
          {'text': 'Hal Jordan', 'score': errada},
          {'text': 'Oliver Queen', 'score': errada},
        ],
      },
      {
        'texto': '2 - Qual é o nome da cidade natal do Batman?',
        'respostas': [
          {'text': 'Metropolis', 'score': errada},
          {'text': 'Gotham City', 'score': certa},
          {'text': 'Star City', 'score': errada},
          {'text': 'Central City', 'score': errada},
        ],
      },
      {
        'texto': '3 - Qual cor representa a ganância entre os lanternas?',
        'respostas': [
          {'text': 'Verde', 'score': errada},
          {'text': 'Azul', 'score': errada},
          {'text': 'Vermelho', 'score': errada},
          {'text': 'Laranja', 'score': certa},
        ],
      },
      {
        'texto': '4 - Qual dos seguintes personagens é um Lanterna Verde?',
        'respostas': [
          {'text': 'Barry Allen', 'score': errada},
          {'text': 'Arthur Curry', 'score': errada},
          {'text': 'Billy Batson', 'score': errada},
          {'text': 'John Stewart', 'score': certa},
        ],
      },
      {
        'texto': '5 - Qual é o nome do arqui-inimigo do Flash?',
        'respostas': [
          {'text': 'Lex Luthor', 'score': errada},
          {'text': 'Cheetah', 'score': errada},
          {'text': 'Zoom', 'score': certa},
          {'text': 'Duas-Caras', 'score': errada},
        ],
      },
      {
        'texto': '6 - Qual é o nome do planeta natal de Superman?',
        'respostas': [
          {'text': 'Júpiter', 'score': errada},
          {'text': 'Krypton', 'score': certa},
          {'text': 'Terra', 'score': errada},
          {'text': 'Apokolips', 'score': errada},
        ],
      },
      {
        'texto': '7 - Qual é a identidade secreta do Arqueiro Verde?',
        'respostas': [
          {'text': 'Oliver Queen', 'score': certa},
          {'text': 'Hal Jordan', 'score': errada},
          {'text': 'Bruce Wayne', 'score': errada},
          {'text': 'Dick Grayson', 'score': errada},
        ],
      },
      {
        'texto': '8 - Quem é o vilão que frequentemente enfrenta a Mulher Maravilha?',
        'respostas': [
          {'text': 'Luthor', 'score': errada},
          {'text': 'Ares', 'score': certa},
          {'text': 'Sinestro', 'score': errada},
          {'text': 'Brainiac', 'score': errada},
        ],
      },
      {
        'texto': '9 - Qual é o nome do lado obscuro da Liga da Justiça, que inclui vilões como Lex Luthor?',
        'respostas': [
          {'text': 'Sociedade da Justiça', 'score': errada},
          {'text': 'Injustiça', 'score': errada},
          {'text': 'Liga da Injustiça', 'score': errada},
          {'text': 'Sociedade Secreta dos Supervilões', 'score': certa},
        ],
      },
      {
        'texto': '10 - Qual Robin se torna conhecido como Capuz Vermelho?',
        'respostas': [
          {'text': 'Dick Grayson', 'score': errada},
          {'text': 'Tim Drake', 'score': errada},
          {'text': 'Jason Todd', 'score': certa},
          {'text': 'Damian Wayne', 'score': errada},
        ],
      },
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: _questionIndex > 0 && _questionIndex < perguntas.length
              ? IconButton(
                  onPressed: _voltar,
                  icon: const Icon(Icons.arrow_back),
                  tooltip: 'Voltar',
                )
              : null,
          title: const Text('Perguntas'),
          centerTitle: true,
        ),
        body: Center(
          child: _questionIndex < perguntas.length 
            ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Image.network(
                    'https://d9radp1mruvh.cloudfront.net/media/challenge_img/509655_shutterstock_1506580442_769367.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Text(
                    perguntas[_questionIndex]['texto'] as String,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
                SizedBox(height: 16),
                ...(perguntas[_questionIndex]['respostas'] as List<Map<String, Object>>).map((answer) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      onPressed: () => _responder(answer['score'] as int),
                      child: Text(answer['text'] as String),
                    ),
                  );
                }).toList(),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Pontuação Total: $_totalScore',
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _reiniciarQuiz,
                  child: const Text('Reiniciar Quiz'),
                ),
              ],
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