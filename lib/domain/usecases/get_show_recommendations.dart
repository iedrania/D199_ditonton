import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/common/failure.dart';

class GetShowRecommendations {
  final MovieRepository repository;

  GetShowRecommendations(this.repository);

  Future<Either<Failure, List<Movie>>> execute(id) {
    return repository.getShowRecommendations(id);
  }
}
