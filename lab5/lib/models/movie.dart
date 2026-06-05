// Model Trailer dùng để lưu thông tin trailer của phim
class Trailer {
  final String title;
  final String duration;

  const Trailer({required this.title, required this.duration});
}

// Model Movie dùng để lưu thông tin một bộ phim
class Movie {
  final String id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating;
  final List<Trailer> trailers;

  const Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.trailers,
  });
}
