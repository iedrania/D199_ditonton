import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_watchlist_shows.dart';
import 'package:flutter/foundation.dart';

class WatchlistShowNotifier extends ChangeNotifier {
  var _watchlistShows = <Movie>[];
  List<Movie> get watchlistShows => _watchlistShows;

  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  WatchlistShowNotifier({required this.getWatchlistShows});

  final GetWatchlistShows getWatchlistShows;

  Future<void> fetchWatchlistShows() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistShows.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (showsData) {
        _watchlistState = RequestState.Loaded;
        _watchlistShows = showsData;
        notifyListeners();
      },
    );
  }
}
