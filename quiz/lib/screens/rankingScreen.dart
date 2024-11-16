import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz/widgets/cores.dart';

class RankingScreen extends StatelessWidget {
  final Function toggleTheme;

  const RankingScreen({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ranking',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? corBranca() : corPreta(),
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            color: _isDarkMode ? corBranca() : corPreta(),
            onPressed: () {
              toggleTheme();
            },
          ),
        ],
        backgroundColor: corDestaque(),
        elevation: 4,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rankings')
            .orderBy('score', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final documents = snapshot.data?.docs;

          if (documents == null || documents.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum dado disponível.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: documents.length,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            itemBuilder: (context, index) {
              final name = documents[index]['name'];
              final score = documents[index]['score'];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _isDarkMode ? Color(0xFF1D1B20) : Color(0xFFF7F2FA),
                    child: Text(
                      '${index + 1}    |',
                      style: TextStyle(
                        color: _isDarkMode ? corBranca() : corPreta(),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Text(
                    score.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      color: score < 7 ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
