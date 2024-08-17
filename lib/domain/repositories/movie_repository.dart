import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/common/failure.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies();
  Future<Either<Failure, List<Movie>>> getPopularMovies();
  Future<Either<Failure, List<Movie>>> getTopRatedMovies();
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id);
  Future<Either<Failure, List<Movie>>> getMovieRecommendations(int id);
  Future<Either<Failure, List<Movie>>> searchMovies(String query);
  Future<Either<Failure, String>> saveWatchlist(MovieDetail movie);
  Future<Either<Failure, String>> removeWatchlist(MovieDetail movie);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<Movie>>> getWatchlistMovies();
  Future<Either<Failure, List<Movie>>> getNowAiringShows();
  Future<Either<Failure, List<Movie>>> getPopularShows();
  Future<Either<Failure, List<Movie>>> getTopRatedShows();
  Future<Either<Failure, MovieDetail>> getShowDetail(int id);
  Future<Either<Failure, List<Movie>>> getShowRecommendations(int id);
  Future<Either<Failure, List<Movie>>> searchShows(String query);
  Future<Either<Failure, String>> saveWatchlistShow(MovieDetail movie);
  Future<Either<Failure, String>> removeWatchlistShow(MovieDetail movie);
  Future<bool> isAddedToWatchlistShow(int id);
  Future<Either<Failure, List<Movie>>> getWatchlistShows();
}
