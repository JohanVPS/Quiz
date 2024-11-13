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
    bool _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var size = MediaQuery.of(context).size;
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
            Image.asset(
              _isDarkMode? 'lib/assets/dc_logoWhite.png' : 'lib/assets/dc_logo.png',
              height: size.width * 0.38,
            ),
            SizedBox(height: size.height * 0.05),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5, // Largura máxima disponível
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizScreen(toggleTheme: toggleTheme)),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Para que o botão não ocupe toda a largura
                  children: [
                    Icon(Icons.play_arrow), // Ícone do botão
                    SizedBox(width: 8), // Espaço entre o ícone e o texto
                    Text('Iniciar Quiz'), // Texto do botão
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(5.0)),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5, // Largura máxima disponível
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RankingScreen(toggleTheme: toggleTheme)),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.list), // Ícone do ranking
                    SizedBox(width: 8),
                    Text('Ranking'),
                  ],
                ),
              )
            ),
            Padding(padding: EdgeInsets.all(5.0)),
             SizedBox(
              width: MediaQuery.of(context).size.width * 0.5, // Largura máxima disponível
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(toggleTheme: toggleTheme),
                      ),
                    );
                  } catch (e) {
                    print('Erro ao sair: $e');
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.exit_to_app), // Ícone de sair
                    SizedBox(width: 8),
                    Text('Sair'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
