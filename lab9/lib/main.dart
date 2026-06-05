import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'storage/json_storage_service.dart';

void main() {
  runApp(const Lab9App());
}

class Lab9App extends StatelessWidget {
  const Lab9App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 9 - Local JSON Storage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const Lab9HomeScreen(),
    );
  }
}

class Lab9HomeScreen extends StatelessWidget {
  const Lab9HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lab 9 - Local JSON Storage'),
          centerTitle: true,
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: '9.1 Assets'),
              Tab(text: '9.2 Save/Load'),
              Tab(text: '9.3 CRUD'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [AssetJsonScreen(), SaveLoadJsonScreen(), CrudJsonScreen()],
        ),
      ),
    );
  }
}

class MovieItem {
  final int id;
  final String title;
  final int year;
  final String genre;
  final double rating;
  final String description;

  const MovieItem({
    required this.id,
    required this.title,
    required this.year,
    required this.genre,
    required this.rating,
    required this.description,
  });

  factory MovieItem.fromJson(Map<String, dynamic> json) {
    return MovieItem(
      id: json['id'] as int,
      title: json['title'] as String,
      year: json['year'] as int,
      genre: json['genre'] as String,
      rating: (json['rating'] as num).toDouble(),
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'genre': genre,
      'rating': rating,
      'description': description,
    };
  }

  MovieItem copyWith({
    int? id,
    String? title,
    int? year,
    String? genre,
    double? rating,
    String? description,
  }) {
    return MovieItem(
      id: id ?? this.id,
      title: title ?? this.title,
      year: year ?? this.year,
      genre: genre ?? this.genre,
      rating: rating ?? this.rating,
      description: description ?? this.description,
    );
  }
}

final List<MovieItem> defaultLocalMovies = [
  const MovieItem(
    id: 1,
    title: 'The Space Journey',
    year: 2025,
    genre: 'Sci-Fi',
    rating: 8.8,
    description: 'A group of astronauts travel beyond the solar system.',
  ),
  const MovieItem(
    id: 2,
    title: 'City of Dreams',
    year: 2024,
    genre: 'Drama',
    rating: 8.1,
    description: 'Two strangers meet in a modern city and follow their dreams.',
  ),
  const MovieItem(
    id: 3,
    title: 'Funny School Days',
    year: 2023,
    genre: 'Comedy',
    rating: 7.6,
    description: 'A funny story about friendship and school life.',
  ),
];

List<Map<String, dynamic>> defaultMovieJson() {
  return defaultLocalMovies.map((movie) => movie.toJson()).toList();
}

/* ============================================================
   LAB 9.1 - READ JSON FROM ASSETS
   ============================================================ */

class AssetJsonScreen extends StatefulWidget {
  const AssetJsonScreen({super.key});

  @override
  State<AssetJsonScreen> createState() => _AssetJsonScreenState();
}

class _AssetJsonScreenState extends State<AssetJsonScreen> {
  late Future<List<MovieItem>> moviesFuture;

  @override
  void initState() {
    super.initState();
    moviesFuture = loadMoviesFromAssets();
  }

  Future<List<MovieItem>> loadMoviesFromAssets() async {
    final jsonString = await rootBundle.loadString('assets/data/movies.json');
    final decodedData = jsonDecode(jsonString);

    if (decodedData is List) {
      return decodedData.map((item) {
        return MovieItem.fromJson(Map<String, dynamic>.from(item as Map));
      }).toList();
    }

    return [];
  }

  Future<void> reloadAssets() async {
    setState(() {
      moviesFuture = loadMoviesFromAssets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MovieItem>>(
      future: moviesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final movies = snapshot.data ?? [];

        return RefreshIndicator(
          onRefresh: reloadAssets,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Lab 9.1 - Read JSON From Assets',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                'Data is loaded from assets/data/movies.json using rootBundle.loadString().',
              ),

              const SizedBox(height: 16),

              ...movies.map((movie) {
                return MovieCard(
                  movie: movie,
                  subtitle: 'Year: ${movie.year} • Genre: ${movie.genre}',
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

/* ============================================================
   LAB 9.2 - SAVE & LOAD JSON FROM DEVICE STORAGE
   ============================================================ */

class SaveLoadJsonScreen extends StatefulWidget {
  const SaveLoadJsonScreen({super.key});

  @override
  State<SaveLoadJsonScreen> createState() => _SaveLoadJsonScreenState();
}

class _SaveLoadJsonScreenState extends State<SaveLoadJsonScreen> {
  final JsonStorageService storageService = JsonStorageService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController genreController = TextEditingController();

  final String fileName = 'lab9_saved_movies.json';

  bool isLoading = true;
  List<MovieItem> movies = [];

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  @override
  void dispose() {
    titleController.dispose();
    genreController.dispose();
    super.dispose();
  }

  Future<void> loadMovies() async {
    final rawData = await storageService.readList(fileName, defaultMovieJson());

    setState(() {
      movies = rawData.map((item) {
        return MovieItem.fromJson(item);
      }).toList();

      isLoading = false;
    });
  }

  int nextId() {
    if (movies.isEmpty) {
      return 1;
    }

    int maxId = 0;

    for (final movie in movies) {
      if (movie.id > maxId) {
        maxId = movie.id;
      }
    }

    return maxId + 1;
  }

  Future<void> saveMovies({bool showMessage = true}) async {
    final data = movies.map((movie) => movie.toJson()).toList();

    await storageService.writeList(fileName, data);

    if (showMessage && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('JSON saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> addMovie() async {
    final title = titleController.text.trim();
    final genre = genreController.text.trim();

    if (title.isEmpty || genre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter title and genre'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newMovie = MovieItem(
      id: nextId(),
      title: title,
      year: DateTime.now().year,
      genre: genre,
      rating: 8.0,
      description: 'Added by user and saved into local JSON file.',
    );

    setState(() {
      movies.add(newMovie);
      titleController.clear();
      genreController.clear();
    });

    await saveMovies(showMessage: false);
  }

  Future<void> resetData() async {
    setState(() {
      movies = List<MovieItem>.from(defaultLocalMovies);
    });

    await saveMovies();

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Data reset to default')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Lab 9.2 - Save & Load JSON',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        const Text(
          'Data is loaded from app storage and saved back to a local JSON file.',
        ),

        const SizedBox(height: 16),

        TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Movie title',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.movie),
          ),
        ),

        const SizedBox(height: 12),

        TextField(
          controller: genreController,
          decoration: const InputDecoration(
            labelText: 'Genre',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.category),
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: addMovie,
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: OutlinedButton.icon(
                onPressed: saveMovies,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        TextButton.icon(
          onPressed: resetData,
          icon: const Icon(Icons.restart_alt),
          label: const Text('Reset default data'),
        ),

        const Divider(height: 32),

        Text(
          'Saved Items: ${movies.length}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        ...movies.map((movie) {
          return MovieCard(
            movie: movie,
            subtitle: 'Year: ${movie.year} • Genre: ${movie.genre}',
          );
        }),
      ],
    );
  }
}

/* ============================================================
   LAB 9.3 - JSON CRUD MINI DATABASE + SEARCH
   ============================================================ */

class CrudJsonScreen extends StatefulWidget {
  const CrudJsonScreen({super.key});

  @override
  State<CrudJsonScreen> createState() => _CrudJsonScreenState();
}

class _CrudJsonScreenState extends State<CrudJsonScreen> {
  final JsonStorageService storageService = JsonStorageService();
  final TextEditingController searchController = TextEditingController();

  final String fileName = 'lab9_crud_database.json';

  bool isLoading = true;
  String searchQuery = '';
  List<MovieItem> movies = [];

  @override
  void initState() {
    super.initState();
    loadDatabase();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadDatabase() async {
    final rawData = await storageService.readList(fileName, defaultMovieJson());

    setState(() {
      movies = rawData.map((item) {
        return MovieItem.fromJson(item);
      }).toList();

      isLoading = false;
    });
  }

  Future<void> saveDatabase() async {
    final data = movies.map((movie) => movie.toJson()).toList();
    await storageService.writeList(fileName, data);
  }

  int nextId() {
    if (movies.isEmpty) {
      return 1;
    }

    int maxId = 0;

    for (final movie in movies) {
      if (movie.id > maxId) {
        maxId = movie.id;
      }
    }

    return maxId + 1;
  }

  List<MovieItem> get filteredMovies {
    final keyword = searchQuery.toLowerCase().trim();

    if (keyword.isEmpty) {
      return movies;
    }

    return movies.where((movie) {
      return movie.title.toLowerCase().contains(keyword) ||
          movie.genre.toLowerCase().contains(keyword) ||
          movie.description.toLowerCase().contains(keyword);
    }).toList();
  }

  Future<void> addOrEditMovie({MovieItem? movie}) async {
    final result = await showMovieDialog(context, movie: movie);

    if (result == null) {
      return;
    }

    setState(() {
      if (movie == null) {
        movies.add(result.copyWith(id: nextId()));
      } else {
        final index = movies.indexWhere((item) => item.id == movie.id);

        if (index != -1) {
          movies[index] = result.copyWith(id: movie.id);
        }
      }
    });

    await saveDatabase();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(movie == null ? 'Item added' : 'Item updated'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> deleteMovie(MovieItem movie) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm delete'),
          content: Text('Do you want to delete "${movie.title}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    setState(() {
      movies.removeWhere((item) => item.id == movie.id);
    });

    await saveDatabase();

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Item deleted')));
    }
  }

  Future<void> resetDatabase() async {
    setState(() {
      movies = List<MovieItem>.from(defaultLocalMovies);
      searchController.clear();
      searchQuery = '';
    });

    await saveDatabase();
  }

  @override
  Widget build(BuildContext context) {
    final visibleMovies = filteredMovies;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lab 9.3 - JSON CRUD Database',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Add, edit, delete and search items. Every change is saved automatically.',
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Search by title, genre or description',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchQuery.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                searchController.clear();
                                searchQuery = '';
                              });
                            },
                          ),
                    border: const OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Text(
                      'Results: ${visibleMovies.length}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: resetDatabase,
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('Reset'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: visibleMovies.isEmpty
                ? const Center(child: Text('No items found'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: visibleMovies.length,
                    itemBuilder: (context, index) {
                      final movie = visibleMovies[index];

                      return MovieCard(
                        movie: movie,
                        subtitle:
                            'Year: ${movie.year} • Genre: ${movie.genre} • Rating: ${movie.rating}',
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Edit',
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                addOrEditMovie(movie: movie);
                              },
                            ),
                            IconButton(
                              tooltip: 'Delete',
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                deleteMovie(movie);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          addOrEditMovie();
        },
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
    );
  }
}

/* ============================================================
   REUSABLE UI
   ============================================================ */

class MovieCard extends StatelessWidget {
  final MovieItem movie;
  final String subtitle;
  final Widget? trailing;

  const MovieCard({
    super.key,
    required this.movie,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(child: Text(movie.id.toString())),
        title: Text(
          movie.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: trailing,
      ),
    );
  }
}

Future<MovieItem?> showMovieDialog(
  BuildContext context, {
  MovieItem? movie,
}) async {
  final titleController = TextEditingController(text: movie?.title ?? '');
  final yearController = TextEditingController(
    text: movie?.year.toString() ?? DateTime.now().year.toString(),
  );
  final genreController = TextEditingController(text: movie?.genre ?? '');
  final ratingController = TextEditingController(
    text: movie?.rating.toString() ?? '8.0',
  );
  final descriptionController = TextEditingController(
    text: movie?.description ?? '',
  );

  final result = await showDialog<MovieItem>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(movie == null ? 'Add Movie' : 'Edit Movie'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: yearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Year',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: genreController,
                decoration: const InputDecoration(
                  labelText: 'Genre',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: ratingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Rating',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),

          FilledButton(
            onPressed: () {
              final title = titleController.text.trim();
              final genre = genreController.text.trim();
              final description = descriptionController.text.trim();
              final year = int.tryParse(yearController.text.trim());
              final rating = double.tryParse(ratingController.text.trim());

              if (title.isEmpty ||
                  genre.isEmpty ||
                  description.isEmpty ||
                  year == null ||
                  rating == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill all fields correctly'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final editedMovie = MovieItem(
                id: movie?.id ?? 0,
                title: title,
                year: year,
                genre: genre,
                rating: rating,
                description: description,
              );

              Navigator.pop(context, editedMovie);
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );

  titleController.dispose();
  yearController.dispose();
  genreController.dispose();
  ratingController.dispose();
  descriptionController.dispose();

  return result;
}
