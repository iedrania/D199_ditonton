import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';

class GetPopularShows {
  final MovieRepository repository;

  GetPopularShows(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getPopularShows();
  }
}
