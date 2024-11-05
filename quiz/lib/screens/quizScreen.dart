import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizScreen extends StatefulWidget {

  final Function toggleTheme; // Adicionando o parâmetro opcional

  const QuizScreen({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _questionIndex = 0;
  int _totalScore = 0;

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
      'texto': '8 - Quem é o vilão que frequentemente enfrenta a Mulher Maravilha?',
      'imagem': 'lib/assets/mulher_maravilha.jpg',
      'respostas': [
        {'text': 'Luthor', 'score': 0},
        {'text': 'Ares', 'score': 1},
        {'text': 'Sinestro', 'score': 0},
        {'text': 'Brainiac', 'score': 0},
      ],
    },
    {
      'texto': '9 - Qual é o nome do lado obscuro da Liga da Justiça, que inclui vilões como Lex Luthor?',
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

  void _responder(int score) {
    setState(() {
      _totalScore += score;
      _questionIndex++;
    });
  }

  void _reiniciarQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  void _salvarResultado() async {
    // Salvar o resultado no Firestore
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('rankings').add({
        'name': user.email,
        'score': _totalScore,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz', textAlign: TextAlign.center),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6), // Ícone para alternar tema
            onPressed: () {widget.toggleTheme();},
          ),
        ],
      ),
      body: Center(
        child: _questionIndex < perguntas.length
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    perguntas[_questionIndex]['imagem'] as String,
                    width: MediaQuery.of(context).size.width * 0.9, 
                    height: MediaQuery.of(context).size.width * 0.7,
                  ),
                  SizedBox(height: 16),
                  Text(
                    perguntas[_questionIndex]['texto'] as String,
                    style: TextStyle(fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ...(perguntas[_questionIndex]['respostas'] as List<Map<String, Object>>).map((answer) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
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
                    );
                  }).toList(),
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
                      _salvarResultado(); // Salvar resultado ao final do quiz
                      _reiniciarQuiz();
                    },
                    child: Text('Reiniciar Quiz'),
                  ),
                ],
              ),
      ),
    );
  }
}
