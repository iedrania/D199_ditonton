import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testShow = Movie(
  adult: false,
  backdropPath: 'backdropPath',
  genreIds: [1],
  id: 1,
  originalTitle: 'originalName',
  overview: 'overview',
  popularity: 1,
  posterPath: 'posterPath',
  releaseDate: 'firstAirDate',
  title: 'name',
  video: null,
  voteAverage: 1,
  voteCount: 1,
);

final testShowList = [testShow];

final testShowDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalName',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'firstAirDate',
  runtime: 120,
  title: 'name',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistShow = Movie.watchlist(
  id: 1,
  title: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testShowTable = MovieTable(
  id: 1,
  title: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testShowMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'name',
};
