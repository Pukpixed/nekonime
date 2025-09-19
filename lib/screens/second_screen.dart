import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nekonime/services/firestore.dart';
import 'package:nekonime/widgets/anime_card.dart';
import 'package:nekonime/colors.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController episodeController = TextEditingController();
  final TextEditingController seasonController = TextEditingController();
  final TextEditingController scoreController = TextEditingController();

  // ✅ Dialog Add/Edit Anime
  void openAnimeBox(String? animeId) async {
    if (animeId != null) {
      final anime = await firestoreService.getAnimeById(animeId);
      nameController.text = anime?['name'] ?? '';
      episodeController.text = (anime?['episode'] ?? 0).toString();
      seasonController.text = (anime?['season'] ?? 0).toString();
      scoreController.text = (anime?['score'] ?? 0).toString();
    } else {
      nameController.clear();
      episodeController.clear();
      seasonController.clear();
      scoreController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(animeId == null ? "Add Anime" : "Edit Anime"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Name
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(12),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.pets, color: AppColors.pastelPurple),
                    labelText: 'Anime Name',
                    labelStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.pastelPurple,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.pastelPurple.withOpacity(0.9),
                        width: 3,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Episode
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(12),
                child: TextField(
                  controller: episodeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.tv, color: AppColors.tvBlue),
                    labelText: 'Episode',
                    labelStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.tvBlue, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.tvBlue.withOpacity(0.9),
                        width: 3,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Season
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(12),
                child: TextField(
                  controller: seasonController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      Icons.collections_bookmark,
                      color: AppColors.pastelPink,
                    ),
                    labelText: 'Season',
                    labelStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.pastelPink,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.pastelPink.withOpacity(0.9),
                        width: 3,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Score
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(12),
                child: TextField(
                  controller: scoreController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(
                      Icons.star_rate,
                      color: Colors.amber,
                    ),
                    labelText: 'Score (0–5)',
                    labelStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.amber,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.amber, width: 3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final String name = nameController.text;
              final int episode = int.tryParse(episodeController.text) ?? 0;
              final int season = int.tryParse(seasonController.text) ?? 0;
              final double score = double.tryParse(scoreController.text) ?? 0.0;

              if (score < 0 || score > 5) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Score must be 0–5")),
                );
                return;
              }

              if (animeId != null) {
                firestoreService.updateAnime(
                  animeId,
                  name,
                  episode,
                  season,
                  score,
                );
              } else {
                firestoreService.addAnime(name, episode, season, score);
              }

              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    episodeController.dispose();
    seasonController.dispose();
    scoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.backgroundBlue, AppColors.pastelPink],
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: const Text(
                "Anime Journal",
                style: TextStyle(
                  fontSize: 28, // ✅ ทำให้ข้อความใหญ่ขึ้น
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                  letterSpacing: 1.2,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(Icons.pets, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text("NekoNime 🐾")));
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () {
                    setState(() {}); // refresh
                  },
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestoreService.getAnimes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No anime found",
                        style: TextStyle(fontSize: 20, color: Colors.redAccent),
                      ),
                    );
                  }

                  List<DocumentSnapshot> animeList = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: animeList.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot anime = animeList[index];
                      String animeId = anime.id;

                      Map<String, dynamic> data =
                          anime.data() as Map<String, dynamic>;

                      return AnimeCard(
                        id: animeId,
                        name: data['name'],
                        episode: data['episode'],
                        season: data['season'],
                        score: data['score'],
                        onEdit: () => openAnimeBox(animeId),
                        onDelete: () => firestoreService.deleteAnime(animeId),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.pastelPink,
        onPressed: () => openAnimeBox(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
