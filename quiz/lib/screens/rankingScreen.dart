import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RankingScreen extends StatelessWidget {

  final Function toggleTheme; // Adicionando o parâmetro opcional

  const RankingScreen({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking', textAlign: TextAlign.center),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6), // Ícone para alternar tema
            onPressed: () {toggleTheme();},
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('rankings').orderBy('score', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final documents = snapshot.data?.docs;

          return ListView.builder(
            itemCount: documents?.length ?? 0,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(documents![index]['name']),
                trailing: Text(documents[index]['score'].toString()),
              );
            },
          );
        },
      ),
    );
  }
}
