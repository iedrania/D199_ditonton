import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';

class GetTopRatedShows {
  final MovieRepository repository;

  GetTopRatedShows(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getTopRatedShows();
  }
}
