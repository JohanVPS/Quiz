import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz/widgets/cores.dart';
import 'package:quiz/widgets/inputDec.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String _nome = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String erro = '';
  bool _isLoading = false;

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (_password == _confirmPassword) {
          UserCredential userCredential =
              await _auth.createUserWithEmailAndPassword(
            email: _email,
            password: _password,
          );

          String uid = userCredential.user!.uid;

          await _firestore.collection('users').doc(uid).set({
            'name': _nome,
            'email': _email,
          });

          final snackBar = SnackBar(
            content: Text('Cadastro concluído: ${userCredential.user!.email}'),
            duration: Duration(seconds: 5), // Duração da SnackBar
          );
          Navigator.pop(context);
          // Exibe a SnackBar
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          final snackBar = const SnackBar(
            content: Text('As senhas não correspondem'),
            duration: Duration(seconds: 5), // Duração da SnackBar
          );
          // Exibe a SnackBar
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } catch (e) {
        if (e is FirebaseAuthException) {
          if (e.code == 'email-already-in-use') {
            erro = 'Email já cadastrado';
          } else if (e.code == 'weak-password') {
            erro = 'Digite uma senha com mais de 6 digitos';
          } else if (e.code == 'invalid-email') {
            erro = 'Email inválido';
          } else {
            erro = 'Erro ao cadastrar';
          }
        }
        final snackBar = SnackBar(
          content: Text(erro),
          duration: Duration(seconds: 5), // Duração da SnackBar
        );
        // Exibe a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _mobile(size) {
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.40,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: size.width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/assets/dc_logo.png',
                  height: 200,
                ),
                //SizedBox(height: size.height * 0.00001),
                Text(
                  'Criar uma conta',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.08,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  'Inscreva-se para começar',
                  style: TextStyle(
                    fontSize: size.width * 0.04,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: corBranca(),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.09),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.02),
                      TextFormField(
                        decoration: inputDec('Nome', Icons.person),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu nome';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _nome = value;
                        },
                      ),
                      SizedBox(height: size.height * 0.02),
                      TextFormField(
                        decoration: inputDec('Email', Icons.email),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira um e-mail';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _email = value;
                        },
                      ),
                      SizedBox(height: size.height * 0.02),
                      TextFormField(
                        decoration: inputDec('Senha', Icons.lock),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira uma senha';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _password = value;
                        },
                      ),
                      SizedBox(height: size.height * 0.02),
                      TextFormField(
                        decoration: inputDec('Confirme sua senha', Icons.lock),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira uma senha';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _confirmPassword = value;
                        },
                      ),
                      SizedBox(height: size.height * 0.02),
                      _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _signup,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: corDestaque(),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Text(
                                  'Inscrever-se',
                                  style: TextStyle(
                                    color: corBranca(),
                                    fontSize: size.height * 0.022,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Cadastre-se com',
                          style: TextStyle(
                            color: corLetra(), 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
                          // Ícone do Google
                          const SizedBox(width: 20),
                          // Ícone da Apple
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
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Já tem uma conta?'),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Entrar',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: corDestaque(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          color: corDestaque(),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1, // espalhamento
                blurRadius: 5, // desfoque
                offset: Offset(0, 0) // posição x,y
                )
          ]),
      child: _mobile(size),
    ));
  }
}