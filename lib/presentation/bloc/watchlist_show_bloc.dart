import 'package:bloc/bloc.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_watchlist_shows.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_show_event.dart';
part 'watchlist_show_state.dart';

class WatchlistShowsBloc extends Bloc<WatchlistShowsEvent, WatchlistShowsState> {
  final GetWatchlistShows _getWatchlistShows;

  WatchlistShowsBloc(this._getWatchlistShows) : super(WatchlistShowsEmpty()) {
    on<FetchWatchlistShows>((event, emit) async {
      emit(WatchlistShowsLoading());
      final result = await _getWatchlistShows.execute();

      result.fold(
            (failure) {
          emit(WatchlistShowsError(failure.message));
        },
            (showsData) {
          emit(WatchlistShowsLoaded(showsData));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}
