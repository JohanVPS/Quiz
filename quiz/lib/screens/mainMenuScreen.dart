import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz/screens/loginScreen.dart';
import 'quizScreen.dart';
import 'rankingScreen.dart';

class MainMenuScreen extends StatelessWidget {
  final Function toggleTheme; // Adicionando o parâmetro opcional

  const MainMenuScreen({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Principal', textAlign: TextAlign.center,),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6), // Ícone para alternar tema
            onPressed: () {toggleTheme();},
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizScreen(toggleTheme: toggleTheme)),
                );
              },
              child: Text('Iniciar Quiz'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RankingScreen(toggleTheme: toggleTheme)),
                );
              },
              child: Text('Ranking'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(toggleTheme: toggleTheme)
                    ),
                  );
                } catch (e) {
                  print('Erro ao sair: $e');
                }
              },
              child: Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }
}
