import 'package:bloc/bloc.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_shows.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_shows_event.dart';
part 'top_rated_shows_state.dart';

class TopRatedShowsBloc extends Bloc<TopRatedShowsEvent, TopRatedShowsState> {
  final GetTopRatedShows _getTopRatedShows;

  TopRatedShowsBloc(this._getTopRatedShows) : super(TopRatedShowsEmpty()) {
    on<FetchTopRatedShows>((event, emit) async {
      emit(TopRatedShowsLoading());
      final result = await _getTopRatedShows.execute();

      result.fold(
            (failure) {
          emit(TopRatedShowsError(failure.message));
        },
            (showsData) {
          emit(TopRatedShowsLoaded(showsData));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}
