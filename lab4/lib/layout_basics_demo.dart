import 'package:flutter/material.dart';

class LayoutBasicsDemo extends StatelessWidget {
  const LayoutBasicsDemo({super.key});

  // Danh sách dữ liệu mẫu để hiển thị bằng ListView.builder
  final List<String> movies = const [
    'Avengers: Endgame',
    'Spider-Man',
    'Batman',
    'Iron Man',
    'Doraemon',
    'One Piece Film Red',
    'Your Name',
    'Suzume',
    'Kung Fu Panda',
    'Inside Out',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 3 - Layout Basics'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        // Column dùng để sắp xếp widget theo chiều dọc
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Movie Home Screen',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'This layout uses Column, Row, Padding, SizedBox and ListView.builder.',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            // Row dùng để sắp xếp widget theo chiều ngang
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.movie, size: 36),
                        SizedBox(height: 8),
                        Text('Movies'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.star, size: 36),
                        SizedBox(height: 8),
                        Text('Popular'),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Popular Movies',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.local_movies),
              ],
            ),

            const SizedBox(height: 12),

            // Expanded giúp ListView có chiều cao rõ ràng khi nằm trong Column
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(
                        movies[index],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('Tap to view movie detail'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
