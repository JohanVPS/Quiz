import 'package:flutter/material.dart';

void main() {
  runApp(QuizApp());
}

class _QuizAppState extends State<QuizApp> {
  int _questionIndex = 0;
  int _totalScore = 0;
  bool _isDarkTheme = false;

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

  void _mudarTema() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    const int certa = 1;
    const int errada = 0;

    final List<Map<String, Object>> perguntas = [
      {
        'texto': '1 - Qual é a verdadeira identidade do Superman?',
        'imagem': Image.asset('lib/assets/superman.jpg'), // Imagem para a primeira pergunta
        'respostas': [
          {'text': 'Bruce Wayne', 'score': errada},
          {'text': 'Clark Kent', 'score': certa},
          {'text': 'Hal Jordan', 'score': errada},
          {'text': 'Oliver Queen', 'score': errada},
        ],
      },
      {
        'texto': '2 - Qual é o nome da cidade natal do Batman?',
        'imagem': Image.asset('lib/assets/batman.jpg'), // Imagem para a segunda pergunta
        'respostas': [
          {'text': 'Metropolis', 'score': errada},
          {'text': 'Gotham City', 'score': certa},
          {'text': 'Star City', 'score': errada},
          {'text': 'Central City', 'score': errada},
        ],
      },
      {
        'texto': '3 - Qual cor representa a ganância entre os lanternas?',
        'imagem': Image.asset('lib/assets/lanterna.jpg'), // Imagem para a terceira pergunta
        'respostas': [
          {'text': 'Verde', 'score': errada},
          {'text': 'Azul', 'score': errada},
          {'text': 'Vermelho', 'score': errada},
          {'text': 'Laranja', 'score': certa},
        ],
      },
      {
        'texto': '4 - Qual dos seguintes personagens é um Lanterna Verde?',
        'imagem': Image.asset('lib/assets/lanterna_verde.jpeg'), // Imagem para a quarta pergunta
        'respostas': [
          {'text': 'Barry Allen', 'score': errada},
          {'text': 'Arthur Curry', 'score': errada},
          {'text': 'Billy Batson', 'score': errada},
          {'text': 'John Stewart', 'score': certa},
        ],
      },
      {
        'texto': '5 - Qual é o nome do arqui-inimigo do Flash?',
        'imagem': Image.asset('lib/assets/flash.jpg'), // Imagem para a quinta pergunta
        'respostas': [
          {'text': 'Lex Luthor', 'score': errada},
          {'text': 'Cheetah', 'score': errada},
          {'text': 'Zoom', 'score': certa},
          {'text': 'Duas-Caras', 'score': errada},
        ],
      },
      {
        'texto': '6 - Qual é o nome do planeta natal de Superman?',
        'imagem': Image.asset('lib/assets/krypton.jpeg'), // Imagem para a sexta pergunta
        'respostas': [
          {'text': 'Júpiter', 'score': errada},
          {'text': 'Krypton', 'score': certa},
          {'text': 'Terra', 'score': errada},
          {'text': 'Apokolips', 'score': errada},
        ],
      },
      {
        'texto': '7 - Qual é a identidade secreta do Arqueiro Verde?',
        'imagem': Image.asset('lib/assets/arqueiro_verde.jpg'), // Imagem para a sétima pergunta
        'respostas': [
          {'text': 'Oliver Queen', 'score': certa},
          {'text': 'Hal Jordan', 'score': errada},
          {'text': 'Bruce Wayne', 'score': errada},
          {'text': 'Dick Grayson', 'score': errada},
        ],
      },
      {
        'texto': '8 - Quem é o vilão que frequentemente enfrenta a Mulher Maravilha?',
        'imagem': Image.asset('lib/assets/mulher_maravilha.jpg'), // Imagem para a oitava pergunta
        'respostas': [
          {'text': 'Luthor', 'score': errada},
          {'text': 'Ares', 'score': certa},
          {'text': 'Sinestro', 'score': errada},
          {'text': 'Brainiac', 'score': errada},
        ],
      },
      {
        'texto': '9 - Qual é o nome do lado obscuro da Liga da Justiça, que inclui vilões como Lex Luthor?',
        'imagem': Image.asset('lib/assets/viloes.jpg'), // Imagem para a nona pergunta
        'respostas': [
          {'text': 'Sociedade da Justiça', 'score': errada},
          {'text': 'Injustiça', 'score': errada},
          {'text': 'Liga da Injustiça', 'score': errada},
          {'text': 'Sociedade Secreta dos Supervilões', 'score': certa},
        ],
      },
      {
        'texto': '10 - Qual Robin se torna conhecido como Capuz Vermelho?',
        'imagem': Image.asset('lib/assets/capuz_vermelho.jpeg'), // Imagem para a décima pergunta
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
      theme: _isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          leading: _questionIndex > 0 && _questionIndex < perguntas.length
              ? IconButton(
                  onPressed: _voltar,
                  icon: const Icon(Icons.arrow_back),
                  tooltip: 'Voltar',
                )
              : null,
          actions: [
            IconButton(
              onPressed: () {
                _mudarTema();
              },
              icon: _isDarkTheme
                  ? Icon(Icons.mode_night_rounded)
                  : Icon(Icons.light_mode_rounded),
            )
          ],
          title: const Text('Perguntas'),
          centerTitle: true,
        ),
        body: Center(
          child: _questionIndex < perguntas.length
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.width * 0.7,
                      child: perguntas[_questionIndex]['imagem'] as Widget,
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Text(
                        perguntas[_questionIndex]['texto'] as String,
                        style: const TextStyle(fontSize: 28),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 16),
                    ...(perguntas[_questionIndex]['respostas'] as List<Map<String, Object>>).map((answer) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ElevatedButton(
                          onPressed: () => _responder(answer['score'] as int),
                          child: Text(
                            answer['text'] as String,
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
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
                        'Pontuação Total: $_totalScore/${perguntas.length}',
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