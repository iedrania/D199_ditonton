import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_airing_shows.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_popular_shows.dart';
import 'package:ditonton/domain/usecases/get_top_rated_shows.dart';
import 'package:flutter/material.dart';

class ShowListNotifier extends ChangeNotifier {
  var _nowAiringShows = <Movie>[];
  List<Movie> get nowAiringShows => _nowAiringShows;

  RequestState _nowAiringState = RequestState.Empty;
  RequestState get nowAiringState => _nowAiringState;

  var _popularShows = <Movie>[];
  List<Movie> get popularShows => _popularShows;

  RequestState _popularShowsState = RequestState.Empty;
  RequestState get popularShowsState => _popularShowsState;

  var _topRatedShows = <Movie>[];
  List<Movie> get topRatedShows => _topRatedShows;

  RequestState _topRatedShowsState = RequestState.Empty;
  RequestState get topRatedShowsState => _topRatedShowsState;

  String _message = '';
  String get message => _message;

  ShowListNotifier({
    required this.getNowAiringShows,
    required this.getPopularShows,
    required this.getTopRatedShows,
  });

  final GetNowAiringShows getNowAiringShows;
  final GetPopularShows getPopularShows;
  final GetTopRatedShows getTopRatedShows;

  Future<void> fetchNowAiringShows() async {
    _nowAiringState = RequestState.Loading;
    notifyListeners();

    final result = await getNowAiringShows.execute();
    result.fold(
          (failure) {
        _nowAiringState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (showsData) {
        _nowAiringState = RequestState.Loaded;
        _nowAiringShows = showsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularShows() async {
    _popularShowsState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularShows.execute();
    result.fold(
          (failure) {
        _popularShowsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (showsData) {
        _popularShowsState = RequestState.Loaded;
        _popularShows = showsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedShows() async {
    _topRatedShowsState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedShows.execute();
    result.fold(
          (failure) {
        _topRatedShowsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (showsData) {
        _topRatedShowsState = RequestState.Loaded;
        _topRatedShows = showsData;
        notifyListeners();
      },
    );
  }
}
