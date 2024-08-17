import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_shows.dart';
import 'package:flutter/foundation.dart';

class PopularShowsNotifier extends ChangeNotifier {
  final GetPopularShows getPopularShows;

  PopularShowsNotifier(this.getPopularShows);

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Movie> _shows = [];
  List<Movie> get shows => _shows;

  String _message = '';
  String get message => _message;

  Future<void> fetchPopularShows() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getPopularShows.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (showsData) {
        _shows = showsData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
