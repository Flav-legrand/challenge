import 'package:flutter/material.dart';

class CompetitionPage extends StatelessWidget {
  const CompetitionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Compétitions',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.blueAccent, // Même bleu utilisé pour toutes les pages
        elevation: 4,
        centerTitle: true, // Titre aligné à gauche
        automaticallyImplyLeading: false, // Suppression du bouton retour
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Message de bienvenue amélioré
          Container(
            color: Colors.blue[50],
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.emoji_events,
                  size: 40,
                  color: Colors.blueAccent,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Découvrez les compétitions et participez pour exceller !',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Contenu principal
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bienvenue sur la page des compétitions !',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Explorez les compétitions et testez vos limites.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200], // Arrière-plan légèrement grisé
    );
  }
}
