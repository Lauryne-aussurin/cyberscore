import 'package:flutter/material.dart';

void main() => runApp(const CyberScoreApp());

class CyberScoreApp extends StatelessWidget {
  const CyberScoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const QCMPage(),
    );
  }
}

class QCMPage extends StatefulWidget {
  const QCMPage({super.key});

  @override
  State<QCMPage> createState() => _QCMPageState();
}

class _QCMPageState extends State<QCMPage> {
  int score = 0;
  int questionIndex = 0;

  // Questions extraites de ton document PDF
  final List<Map<String, dynamic>> questions = [
    {
      'q': "Que faire quand un étranger demande de télécharger un fichier ?",
      'a': [
        {'texte': 'Télécharger et ouvrir le fichier', 'points': 0},
        {'texte': "Vérifier l'identité de l'émetteur", 'points': 2},
      ],
    },
    {
      'q': "Quels sont les indices d'un phishing (hameçonnage) ?",
      'a': [
        {'texte': 'L\'urgence du message et les fautes', 'points': 2},
        {'texte': 'Un message d\'un ami proche', 'points': 0},
      ],
    },
    {
      'q': "Quel est le meilleur type de mot de passe ?",
      'a': [
        {'texte': 'Ma date de naissance ou mon chien', 'points': 0},
        {'texte': 'Une phrase de passe (Passphrase)', 'points': 2},
      ],
    },
    {
      'q': "Se connecter au Wi-Fi public (gare, resto) sans problème ?",
      'a': [
        {'texte': 'Vrai (C\'est pratique)', 'points': 0},
        {'texte': 'Faux (C\'est un risque)', 'points': 2},
      ],
    },
  ];

  void repondre(int points) {
    setState(() {
      score += points;
      questionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child:  Text('Diagnostic Cyber-Inclusion')),
        backgroundColor: const Color.fromARGB(255, 18, 119, 202),
        foregroundColor: Colors.white,
        titleTextStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      body: questionIndex < questions.length
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LinearProgressIndicator(
                      value: questionIndex / questions.length,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      questions[questionIndex]['q'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      selectionColor: Colors.red,
                    ),
                    const SizedBox(height: 40),
                    ...(questions[questionIndex]['a'] as List).map((rep) {
                      // On définit la couleur par défaut (bleu)
                      Color boutonCouleur = Colors.blue;

                      // Si le texte est "Vrai" ou contient "Vrai", on met en vert
                      if (rep['texte'].toString().contains("Vrai")) {
                        boutonCouleur = Colors.green.shade600;
                      }
                      // Si le texte est "Faux" ou contient "Faux", on met en rouge
                      else if (rep['texte'].toString().contains("Faux")) {
                        boutonCouleur = Colors.red.shade600;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                boutonCouleur, // Applique la couleur choisie
                            foregroundColor: Colors.white, // Texte en blanc pour le contraste
                            minimumSize: const Size(double.infinity, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () => repondre(rep['points']),
                          child: Text(
                            rep['texte'],
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            )
          : ResultatPage(score: score),
    );
  }
}

class ResultatPage extends StatelessWidget {
  final int score;
  const ResultatPage({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    String profil;
    Color couleur;
    String description;

    // Logique basée sur tes analyses seniors/jeunes
    if (score >= 6) {
      profil = "L'Éclaireur Prudent";
      couleur = Colors.green;
      description = "Vous avez acquis les bons réflexes pour vous protéger !";
    } else if (score >= 3) {
      profil = "La Cible Confiante";
      couleur = Colors.orange;
      description = "Attention à l'excès de confiance sur les réseaux publics.";
    } else {
      profil = "Le Passager Intimidé";
      couleur = Colors.red;
      description =
          "La peur ne doit pas bloquer votre sécurité. Vous allez y arriver !";
    }

    return Center(
      child: Card(
        margin: const EdgeInsets.all(30),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Votre profil :", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              Text(
                profil,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: couleur,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const QCMPage()),
                  (route) => false,
                ),
                child: const Text("Refaire le test"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
