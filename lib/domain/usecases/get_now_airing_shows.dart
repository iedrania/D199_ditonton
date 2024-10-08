import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/common/failure.dart';

class GetNowAiringShows {
  final MovieRepository repository;

  GetNowAiringShows(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getNowAiringShows();
  }
}
