import '../models/movie.dart';

// Dữ liệu mẫu tĩnh, không dùng API
const List<Movie> sampleMovies = [
  Movie(
    id: '1',
    title: 'The Space Journey',
    posterUrl: 'https://picsum.photos/id/1011/600/900',
    rating: 8.8,
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    overview:
        'A young astronaut joins a dangerous mission to explore a mysterious planet beyond the solar system. During the journey, the crew must face fear, loneliness, and the meaning of human survival.',
    trailers: [
      Trailer(title: 'Official Trailer', duration: '2:30'),
      Trailer(title: 'Behind the Scenes', duration: '4:10'),
      Trailer(title: 'Final Trailer', duration: '1:55'),
    ],
  ),
  Movie(
    id: '2',
    title: 'City of Dreams',
    posterUrl: 'https://picsum.photos/id/1015/600/900',
    rating: 8.2,
    genres: ['Romance', 'Drama'],
    overview:
        'In a busy modern city, two strangers meet by chance and slowly discover that their dreams, struggles, and hopes are deeply connected.',
    trailers: [
      Trailer(title: 'Main Trailer', duration: '2:05'),
      Trailer(title: 'Character Preview', duration: '1:40'),
      Trailer(title: 'Music Video', duration: '3:20'),
    ],
  ),
  Movie(
    id: '3',
    title: 'The Last Guardian',
    posterUrl: 'https://picsum.photos/id/1016/600/900',
    rating: 9.0,
    genres: ['Action', 'Fantasy', 'Adventure'],
    overview:
        'A legendary warrior returns to protect the last kingdom from an ancient evil. With courage and sacrifice, he must decide the fate of his people.',
    trailers: [
      Trailer(title: 'Teaser Trailer', duration: '1:30'),
      Trailer(title: 'Action Trailer', duration: '2:45'),
      Trailer(title: 'Director Interview', duration: '5:15'),
    ],
  ),
  Movie(
    id: '4',
    title: 'Ocean Mystery',
    posterUrl: 'https://picsum.photos/id/1018/600/900',
    rating: 7.9,
    genres: ['Mystery', 'Adventure'],
    overview:
        'A group of researchers travel across the ocean to investigate a strange signal coming from a forgotten island.',
    trailers: [
      Trailer(title: 'Official Trailer', duration: '2:18'),
      Trailer(title: 'Island Preview', duration: '1:52'),
    ],
  ),
];
