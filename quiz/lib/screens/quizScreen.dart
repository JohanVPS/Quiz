import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:percent_indicator/circular_percent_indicator.dart';

class QuizScreen extends StatefulWidget {
  final Function toggleTheme;

  const QuizScreen({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _questionIndex = 0;
  int _totalScore = 0;
  int _lastScore = 0;
  Timer? _timer;
  int _segundosRestantes = 10;
  final int _tempoTotal = 10;

  final List<Map<String, Object>> perguntas = [
    {
      'texto': '1 - Qual é a verdadeira identidade do Superman?',
      'imagem': 'lib/assets/superman.jpg',
      'respostas': [
        {'text': 'Bruce Wayne', 'score': 0},
        {'text': 'Clark Kent', 'score': 1},
        {'text': 'Hal Jordan', 'score': 0},
        {'text': 'Oliver Queen', 'score': 0},
      ],
    },
    {
      'texto': '2 - Qual é o nome da cidade natal do Batman?',
      'imagem': 'lib/assets/batman.jpg',
      'respostas': [
        {'text': 'Metropolis', 'score': 0},
        {'text': 'Gotham City', 'score': 1},
        {'text': 'Star City', 'score': 0},
        {'text': 'Central City', 'score': 0},
      ],
    },
    {
      'texto': '3 - Qual cor representa a ganância entre os lanternas?',
      'imagem': 'lib/assets/lanterna.jpg',
      'respostas': [
        {'text': 'Verde', 'score': 0},
        {'text': 'Azul', 'score': 0},
        {'text': 'Vermelho', 'score': 0},
        {'text': 'Laranja', 'score': 1},
      ],
    },
    {
      'texto': '4 - Qual dos seguintes personagens é um Lanterna Verde?',
      'imagem': 'lib/assets/lanterna_verde.jpeg',
      'respostas': [
        {'text': 'Barry Allen', 'score': 0},
        {'text': 'Arthur Curry', 'score': 0},
        {'text': 'Billy Batson', 'score': 0},
        {'text': 'John Stewart', 'score': 1},
      ],
    },
    {
      'texto': '5 - Qual é o nome do arqui-inimigo do Flash?',
      'imagem': 'lib/assets/flash.jpg',
      'respostas': [
        {'text': 'Lex Luthor', 'score': 0},
        {'text': 'Cheetah', 'score': 0},
        {'text': 'Zoom', 'score': 1},
        {'text': 'Duas-Caras', 'score': 0},
      ],
    },
    {
      'texto': '6 - Qual é o nome do planeta natal de Superman?',
      'imagem': 'lib/assets/krypton.jpeg',
      'respostas': [
        {'text': 'Júpiter', 'score': 0},
        {'text': 'Krypton', 'score': 1},
        {'text': 'Terra', 'score': 0},
        {'text': 'Apokolips', 'score': 0},
      ],
    },
    {
      'texto': '7 - Qual é a identidade secreta do Arqueiro Verde?',
      'imagem': 'lib/assets/arqueiro_verde.jpg',
      'respostas': [
        {'text': 'Oliver Queen', 'score': 1},
        {'text': 'Hal Jordan', 'score': 0},
        {'text': 'Bruce Wayne', 'score': 0},
        {'text': 'Dick Grayson', 'score': 0},
      ],
    },
    {
      'texto':
          '8 - Quem é o vilão que frequentemente enfrenta a Mulher Maravilha?',
      'imagem': 'lib/assets/mulher_maravilha.jpg',
      'respostas': [
        {'text': 'Luthor', 'score': 0},
        {'text': 'Ares', 'score': 1},
        {'text': 'Sinestro', 'score': 0},
        {'text': 'Brainiac', 'score': 0},
      ],
    },
    {
      'texto':
          '9 - Qual é o nome do lado obscuro da Liga da Justiça, que inclui vilões como Lex Luthor?',
      'imagem': 'lib/assets/viloes.jpg',
      'respostas': [
        {'text': 'Sociedade da Justiça', 'score': 0},
        {'text': 'Injustiça', 'score': 0},
        {'text': 'Liga da Injustiça', 'score': 0},
        {'text': 'Sociedade Secreta dos Supervilões', 'score': 1},
      ],
    },
    {
      'texto': '10 - Qual Robin se torna conhecido como Capuz Vermelho?',
      'imagem': 'lib/assets/capuz_vermelho.jpeg',
      'respostas': [
        {'text': 'Dick Grayson', 'score': 0},
        {'text': 'Tim Drake', 'score': 0},
        {'text': 'Jason Todd', 'score': 1},
        {'text': 'Damian Wayne', 'score': 0},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _iniciarTemporizador(); // Inicia o temporizador assim que o estado for criado
  }

  void _reiniciarTemporizador() {
    setState(() {
      _segundosRestantes = 10; // Reinicia o contador
    });
    _iniciarTemporizador();
  }

  void _pararTemporizador() {
    _timer?.cancel();
  }

  void _iniciarTemporizador() {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_segundosRestantes > 0) {
          _segundosRestantes--;
        } else {
          _pararTemporizador(); // Para o temporizador quando chegar a zero
          _responder(0); // Considera uma resposta errada ao acabar o tempo
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancela o temporizador ao sair da tela
    super.dispose();
  }

  void _responder(int score) {
    setState(() {
      _lastScore = score;
      _totalScore += score;
      _questionIndex++;
      if (_questionIndex < perguntas.length) {
        _reiniciarTemporizador(); // Reinicia o temporizador para a próxima pergunta
      }
    });
  }

  void _voltarPergunta(int score) {
    if (_questionIndex > 0) {
      setState(() {
        _totalScore -= score;
        _questionIndex--;
      });
    }
  }

  void _reiniciarQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
      _lastScore = 0;
      _segundosRestantes = 10;
    });
    _iniciarTemporizador(); // Reinicia o temporizador ao reiniciar o quiz
  }

  void _salvarResultado() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Consulta para verificar se o usuário já possui um registro no ranking
      final querySnapshot = await FirebaseFirestore.instance
          .collection('rankings')
          .where('name', isEqualTo: user.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Se o registro já existe, atualiza o documento existente
        await FirebaseFirestore.instance
            .collection('rankings')
            .doc(querySnapshot.docs[0].id)
            .update({
          'score': _totalScore,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        // Caso contrário, adiciona um novo documento
        await FirebaseFirestore.instance.collection('rankings').add({
          'name': user.email,
          'score': _totalScore,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz', textAlign: TextAlign.center),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              widget.toggleTheme();
            },
          ),
        ],
      ),
      body: Center(
        child: _questionIndex < perguntas.length
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: CircularPercentIndicator(
                      percent: _segundosRestantes / _tempoTotal,
                      radius: 60.0,
                      lineWidth: 8.0,
                      center: Text(
                        "$_segundosRestantes s",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      progressColor: const Color.fromARGB(255, 0, 140, 255),
                      backgroundColor: Color(0xFFF5F5F5),
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                  ),
                  //SizedBox(height: 2), // Espaço entre o temporizador e a imagem
                  Image.asset(
                    perguntas[_questionIndex]['imagem'] as String,
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.7,
                  ),
                  SizedBox(height: 1),
                  Text(
                    perguntas[_questionIndex]['texto'] as String,
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  ...(perguntas[_questionIndex]['respostas']
                          as List<Map<String, Object>>)
                      .map((answer) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: ElevatedButton(
                          onPressed: () {
                            _responder(answer['score'] as int);
                          },
                          child: Text(
                            answer['text'] as String,
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  _questionIndex != 0
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.05),
                            child: ElevatedButton.icon(
                              onPressed: () => _voltarPergunta(_lastScore),
                              label: Text(
                                'Back',
                                textAlign: TextAlign.justify,
                              ),
                              icon: Icon(Icons.arrow_back_rounded),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 10.0),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pontuação Total: $_totalScore/${perguntas.length}',
                    style: TextStyle(fontSize: 36),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _reiniciarQuiz();
                    },
                    child: Text('Reiniciar Quiz'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _salvarResultado();
                    },
                    child: Text('Retornar ao menu inicial'),
                  ),
                ],
              ),
      ),
    );
  }
}
