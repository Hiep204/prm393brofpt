import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

// App chính của Lab 6
class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 6 - Responsive Movie Genre Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const GenreScreen(),
    );
  }
}

// Model Movie dùng để lưu thông tin phim
class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

// Danh sách phim mẫu, dùng dữ liệu tĩnh, không gọi API
const List<Movie> allMovies = [
  Movie(
    title: 'The Space Journey',
    year: 2025,
    genres: ['Action', 'Sci-Fi', 'Adventure'],
    posterUrl: 'https://picsum.photos/id/1011/500/700',
    rating: 8.8,
  ),
  Movie(
    title: 'City of Dreams',
    year: 2024,
    genres: ['Drama', 'Romance'],
    posterUrl: 'https://picsum.photos/id/1015/500/700',
    rating: 8.1,
  ),
  Movie(
    title: 'Funny School Days',
    year: 2023,
    genres: ['Comedy', 'Drama'],
    posterUrl: 'https://picsum.photos/id/1025/500/700',
    rating: 7.6,
  ),
  Movie(
    title: 'The Last Guardian',
    year: 2026,
    genres: ['Action', 'Fantasy'],
    posterUrl: 'https://picsum.photos/id/1016/500/700',
    rating: 9.0,
  ),
  Movie(
    title: 'Ocean Mystery',
    year: 2022,
    genres: ['Mystery', 'Adventure'],
    posterUrl: 'https://picsum.photos/id/1018/500/700',
    rating: 7.9,
  ),
  Movie(
    title: 'Robot Future',
    year: 2025,
    genres: ['Sci-Fi', 'Action'],
    posterUrl: 'https://picsum.photos/id/1024/500/700',
    rating: 8.4,
  ),
];

// Các thể loại phim để hiển thị chip
const List<String> availableGenres = [
  'Action',
  'Drama',
  'Comedy',
  'Romance',
  'Sci-Fi',
  'Adventure',
  'Fantasy',
  'Mystery',
];

// Màn hình chính của Lab 6
class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  // Lưu nội dung người dùng nhập vào ô search
  String searchQuery = '';

  // Lưu danh sách genre đang được chọn
  final Set<String> selectedGenres = {};

  // Lưu kiểu sắp xếp hiện tại
  String selectedSort = 'A-Z';

  final List<String> sortOptions = ['A-Z', 'Z-A', 'Year', 'Rating'];

  // Hàm bật/tắt genre chip
  void _toggleGenre(String genre) {
    setState(() {
      if (selectedGenres.contains(genre)) {
        selectedGenres.remove(genre);
      } else {
        selectedGenres.add(genre);
      }
    });
  }

  // Hàm xóa bộ lọc
  void _clearFilters() {
    setState(() {
      searchQuery = '';
      selectedGenres.clear();
      selectedSort = 'A-Z';
    });
  }

  // Lọc và sắp xếp danh sách phim
  List<Movie> get visibleMovies {
    List<Movie> result = allMovies.where((movie) {
      final titleMatch = movie.title.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      final genreMatch =
          selectedGenres.isEmpty ||
          movie.genres.any((genre) => selectedGenres.contains(genre));

      return titleMatch && genreMatch;
    }).toList();

    if (selectedSort == 'A-Z') {
      result.sort((a, b) => a.title.compareTo(b.title));
    } else if (selectedSort == 'Z-A') {
      result.sort((a, b) => b.title.compareTo(a.title));
    } else if (selectedSort == 'Year') {
      result.sort((a, b) => b.year.compareTo(a.year));
    } else if (selectedSort == 'Rating') {
      result.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery dùng để đọc kích thước màn hình hiện tại
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isWideScreen = screenWidth >= 800;

    return Scaffold(
      body: SafeArea(
        // SafeArea giúp tránh bị che bởi tai thỏ, camera, status bar
        child: Padding(
          padding: EdgeInsets.all(isWideScreen ? 24 : 16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroHeading(isWideScreen),

              const SizedBox(height: 16),

              _buildSearchBar(),

              const SizedBox(height: 16),

              _buildGenreSection(),

              const SizedBox(height: 16),

              _buildSortBar(),

              const SizedBox(height: 16),

              Expanded(
                // LayoutBuilder đọc được không gian còn lại của phần movie list
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final bool useGrid = constraints.maxWidth >= 800;
                    final movies = visibleMovies;

                    if (movies.isEmpty) {
                      return const Center(
                        child: Text(
                          'No movies found',
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    }

                    if (useGrid) {
                      // Màn hình rộng: hiển thị dạng 2 cột
                      return GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 3.1,
                        children: movies.map((movie) {
                          return MovieCard(movie: movie);
                        }).toList(),
                      );
                    }

                    // Màn hình nhỏ: hiển thị dạng list 1 cột
                    return ListView.builder(
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: MovieCard(movie: movies[index]),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Lab 6.1 - Responsive Hero & Heading Section
  Widget _buildHeroHeading(bool isWideScreen) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isWideScreen ? 28 : 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade300],
        ),
      ),

      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find a Movie',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isWideScreen ? 38 : 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Search, filter by genre, and sort your favorite movies.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: isWideScreen ? 18 : 15,
                  ),
                ),
              ],
            ),
          ),

          if (isWideScreen)
            const Icon(Icons.movie_filter, color: Colors.white, size: 90),
        ],
      ),
    );
  }

  // Lab 6.2 - Search Bar
  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Search movie title...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Lab 6.2 - Genre Chips dùng Wrap để tự xuống dòng
  Widget _buildGenreSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Genres',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(width: 8),

            // Badge hiển thị số genre đã chọn
            if (selectedGenres.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${selectedGenres.length} selected',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
          ],
        ),

        const SizedBox(height: 10),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableGenres.map((genre) {
            final bool isSelected = selectedGenres.contains(genre);

            return FilterChip(
              label: Text(genre),
              selected: isSelected,
              onSelected: (_) => _toggleGenre(genre),
              selectedColor: Colors.deepPurple.shade100,
              checkmarkColor: Colors.deepPurple,
            );
          }).toList(),
        ),
      ],
    );
  }

  // Lab 6.2 - Sort Dropdown + Clear filters
  Widget _buildSortBar() {
    return Row(
      children: [
        const Text(
          'Sort by:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),

        const SizedBox(width: 12),

        DropdownButton<String>(
          value: selectedSort,
          items: sortOptions.map((option) {
            return DropdownMenuItem<String>(value: option, child: Text(option));
          }).toList(),
          onChanged: (value) {
            if (value == null) return;

            setState(() {
              selectedSort = value;
            });
          },
        ),

        const Spacer(),

        TextButton.icon(
          onPressed: _clearFilters,
          icon: const Icon(Icons.clear),
          label: const Text('Clear filters'),
        ),
      ],
    );
  }
}

// Card hiển thị từng bộ phim
class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // LayoutBuilder trong card để chỉnh poster theo kích thước item
      builder: (context, constraints) {
        final bool largeCard = constraints.maxWidth >= 450;
        final double posterWidth = largeCard ? 120 : 95;

        return Card(
          elevation: 3,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),

          child: SizedBox(
            height: largeCard ? 170 : 150,

            child: Row(
              children: [
                Image.network(
                  movie.posterUrl,
                  width: posterWidth,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: posterWidth,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.broken_image),
                    );
                  },
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: largeCard ? 20 : 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          'Year: ${movie.year}',
                          style: const TextStyle(fontSize: 14),
                        ),

                        const SizedBox(height: 6),

                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 18,
                              color: Colors.orange,
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

                        const SizedBox(height: 8),

                        Expanded(
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: movie.genres.map((genre) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  genre,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            }).toList(),
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
      },
    );
  }
}
