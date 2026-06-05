import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/movie.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// HomeScreen dùng StatefulWidget vì có search bar thay đổi dữ liệu hiển thị
class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    // Hủy controller khi màn hình không dùng nữa
    searchController.dispose();
    super.dispose();
  }

  // Lọc danh sách phim theo từ khóa tìm kiếm
  List<Movie> get filteredMovies {
    final keyword = searchController.text.toLowerCase();

    if (keyword.isEmpty) {
      return sampleMovies;
    }

    return sampleMovies.where((movie) {
      return movie.title.toLowerCase().contains(keyword);
    }).toList();
  }

  // Hàm điều hướng sang màn hình chi tiết phim
  void _openMovieDetail(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MovieDetailScreen(movie: movie)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movies = filteredMovies;

    return Scaffold(
      appBar: AppBar(title: const Text('Movie App'), centerTitle: true),

      body: Column(
        children: [
          // Khu vực tiêu đề và search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Popular Movies',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Choose a movie to view details',
                  style: TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 16),

                // Search bar dùng để tìm kiếm phim
                TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'Search movies...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Expanded giúp ListView có chiều cao rõ ràng trong Column
          Expanded(
            child: movies.isEmpty
                ? const Center(child: Text('No movies found'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];

                      return MovieCard(
                        movie: movie,
                        onTap: () => _openMovieDetail(movie),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Widget MovieCard dùng để hiển thị từng phim ở Home Screen
class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieCard({super.key, required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      child: InkWell(
        onTap: onTap,

        child: Row(
          children: [
            // Hero dùng để tạo hiệu ứng chuyển ảnh từ Home sang Detail
            Hero(
              tag: 'movie-${movie.id}',
              child: Image.network(
                movie.posterUrl,
                width: 110,
                height: 150,
                fit: BoxFit.cover,

                // Nếu ảnh lỗi thì hiện icon lỗi
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 110,
                    height: 150,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.broken_image, size: 40),
                  );
                },
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          movie.rating.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      movie.genres.join(' • '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Tap to view details',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
