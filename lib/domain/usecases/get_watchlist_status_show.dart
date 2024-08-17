import 'package:ditonton/domain/repositories/movie_repository.dart';

class GetWatchListStatusShow {
  final MovieRepository repository;

  GetWatchListStatusShow(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlistShow(id);
  }
}
