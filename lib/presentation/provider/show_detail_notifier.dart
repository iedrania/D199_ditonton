import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_show_detail.dart';
import 'package:ditonton/domain/usecases/get_show_recommendations.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_show.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_show.dart';
import 'package:ditonton/domain/usecases/save_watchlist_show.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ShowDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetShowDetail getShowDetail;
  final GetShowRecommendations getShowRecommendations;
  final GetWatchListStatusShow getWatchListStatus;
  final SaveWatchlistShow saveWatchlist;
  final RemoveWatchlistShow removeWatchlist;

  ShowDetailNotifier({
    required this.getShowDetail,
    required this.getShowRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  });

  late MovieDetail _show;
  MovieDetail get show => _show;

  RequestState _showState = RequestState.Empty;
  RequestState get showState => _showState;

  List<Movie> _showRecommendations = [];
  List<Movie> get showRecommendations => _showRecommendations;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  Future<void> fetchShowDetail(int id) async {
    _showState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getShowDetail.execute(id);
    final recommendationResult = await getShowRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _showState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (show) {
        _recommendationState = RequestState.Loading;
        _show = show;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.Error;
            _message = failure.message;
          },
          (shows) {
            _recommendationState = RequestState.Loaded;
            _showRecommendations = shows;
          },
        );
        _showState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlist(MovieDetail show) async {
    final result = await saveWatchlist.execute(show);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(show.id);
  }

  Future<void> removeFromWatchlist(MovieDetail show) async {
    final result = await removeWatchlist.execute(show);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(show.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }
}
