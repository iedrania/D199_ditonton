import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/common/failure.dart';

class GetWatchlistShows {
  final MovieRepository _repository;

  GetWatchlistShows(this._repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return _repository.getWatchlistShows();
  }
}
