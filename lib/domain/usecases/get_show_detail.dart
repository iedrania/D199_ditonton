import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/common/failure.dart';

class GetShowDetail {
  final MovieRepository repository;

  GetShowDetail(this.repository);

  Future<Either<Failure, MovieDetail>> execute(int id) {
    return repository.getShowDetail(id);
  }
}
