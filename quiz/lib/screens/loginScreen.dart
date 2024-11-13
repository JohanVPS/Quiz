import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mainMenuScreen.dart';
import 'SignupScreen.dart';
import 'trocaSenhaScreen.dart';
import 'package:quiz/classes/users.dart';
import 'package:quiz/widgets/cores.dart';

class Login extends StatefulWidget {
  final Function toggleTheme; // Parâmetro opcional

  const Login({super.key, required this.toggleTheme}); // Construtor atualizado

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<String> fetchUid(String email) async {
    var cliente = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (cliente.docs.isNotEmpty) {
      String uid = cliente.docs.first.id; // Acessa o ID do primeiro documento
      return uid;
    } else {
      throw Exception('Usuário não encontrado');
    }
  }

  Future<Users> _getUsers(String email) async {
    var users = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    var user = users.docs.first;

    return Users(
      name: user['name'],
      email: user['email'],
    );
  }

  void verifyLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);

        Users users = await _getUsers(_emailController.text);

        print(users);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainMenuScreen(
                toggleTheme:
                    widget.toggleTheme), // Passando toggleTheme se não for nulo
          ),
        );
      } on FirebaseAuthException catch (e) {
        print(e);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Falha no login'),
                  content: const Text('Email ou senha incorretos'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: corFundo(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: size.width * 0.03),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/assets/dc_logo.png',
                        height: size.width * 0.40,
                      ),
                      SizedBox(height: size.width * 0.05),
                      Text(
                        'É bom ver você novamente!',
                        style: TextStyle(color: corTitulo(), fontSize: 16),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: corBranca(),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Campo de Email
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email',
                            style: TextStyle(
                              color: corPreta(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: corPreta()),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 12,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Por favor, insira um email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Campo de Senha
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Senha',
                            style: TextStyle(
                              color: corPreta(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 12,
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Por favor, insira uma senha';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),

                        // Esqueceu a Senha
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrocaSenha(),
                                ),
                              );
                            },
                            child: Text(
                              'Esqueceu sua senha?',
                              style: TextStyle(
                                color: corPreta(),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Botão de Login
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: corDestaque(),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            verifyLogin();
                          },
                          child: const Text(
                            'Entrar',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Opção de continuar com Google e Apple
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Ou continue com",
                              style: TextStyle(color: corLetra()),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Card(
                              color: Color(0xFFFFFFFF),
                              child: IconButton(
                                onPressed: () {
                                  // Lógica de login com Google
                                },
                                icon: Image.asset(
                                  'lib/assets/google_icon.png',
                                  height: 50,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Card(
                              color: Color(0xFFFFFFFF),
                              child: IconButton(
                                onPressed: () {
                                  // Lógica de login com Apple
                                },
                                icon: Image.asset(
                                  'lib/assets/apple_icon.png',
                                  height: 50,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Link para cadastrar-se
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignupScreen(),
                                ),
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                text: 'Ainda não tem uma conta? ',
                                style: TextStyle(color: corLetra()),
                                children: [
                                  TextSpan(
                                    text: 'Cadastre-se',
                                    style: TextStyle(
                                      color: corDestaque(),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
