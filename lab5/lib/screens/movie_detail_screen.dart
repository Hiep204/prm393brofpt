import 'package:flutter/material.dart';

import '../models/movie.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

// Dùng StatefulWidget vì có Favorite toggle và Rate state
class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool isFavorite = false;
  int userRate = 0;

  // Hàm xử lý Favorite
  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite ? 'Added to favorite list' : 'Removed from favorite list',
        ),
      ),
    );
  }

  // Hàm xử lý Rate
  void _rateMovie() {
    setState(() {
      if (userRate < 5) {
        userRate++;
      } else {
        userRate = 1;
      }
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Your rating: $userRate/5')));
  }

  // Hàm xử lý Share
  void _shareMovie() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing "${widget.movie.title}"...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),

      // SingleChildScrollView giúp màn hình Detail cuộn được
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // Hero Banner gồm ảnh + gradient
            _buildHeroBanner(movie),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // Title + rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          movie.title,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              movie.rating.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Genres hiển thị bằng Wrap + Chip
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: movie.genres.map((genre) {
                      return Chip(
                        label: Text(genre),
                        avatar: const Icon(Icons.local_movies, size: 18),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ActionButton(
                        icon: isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        label: 'Favorite',
                        color: isFavorite ? Colors.red : Colors.grey,
                        onTap: _toggleFavorite,
                      ),

                      _ActionButton(
                        icon: Icons.star_rate,
                        label: userRate == 0 ? 'Rate' : '$userRate/5',
                        color: Colors.orange,
                        onTap: _rateMovie,
                      ),

                      _ActionButton(
                        icon: Icons.share,
                        label: 'Share',
                        color: Colors.blue,
                        onTap: _shareMovie,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Overview',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    movie.overview,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Trailers',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  // Trailer list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: movie.trailers.length,
                    itemBuilder: (context, index) {
                      final trailer = movie.trailers[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(child: Text('${index + 1}')),
                          title: Text(
                            trailer.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Duration: ${trailer.duration}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.play_circle_fill),
                            color: Colors.deepPurple,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Playing ${trailer.title}...'),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hero banner dùng Stack để chồng ảnh, gradient và chữ lên nhau
  Widget _buildHeroBanner(Movie movie) {
    return SizedBox(
      height: 360,
      width: double.infinity,

      child: Stack(
        fit: StackFit.expand,

        children: [
          Hero(
            tag: 'movie-${movie.id}',
            child: Image.network(
              movie.posterUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 80),
                  ),
                );
              },
            ),
          ),

          // Gradient làm phần chữ dễ nhìn hơn trên ảnh
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
              ),
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Text(
              movie.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget riêng cho các nút Favorite, Rate, Share
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(icon),
          color: color,
          iconSize: 32,
        ),

        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
