import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_airing_shows.dart';
import 'package:flutter/foundation.dart';

class AiringShowsNotifier extends ChangeNotifier {
  final GetNowAiringShows getAiringShows;

  AiringShowsNotifier(this.getAiringShows);

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Movie> _shows = [];
  List<Movie> get shows => _shows;

  String _message = '';
  String get message => _message;

  Future<void> fetchAiringShows() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getAiringShows.execute();

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
