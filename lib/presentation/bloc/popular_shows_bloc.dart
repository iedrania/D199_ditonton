import 'package:bloc/bloc.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_shows.dart';
import 'package:equatable/equatable.dart';

part 'popular_shows_event.dart';
part 'popular_shows_state.dart';

class PopularShowsBloc extends Bloc<PopularShowsEvent, PopularShowsState> {
  final GetPopularShows _getPopularShows;

  PopularShowsBloc(this._getPopularShows) : super(PopularShowsEmpty()) {
    on<FetchPopularShows>((event, emit) async {
      emit(PopularShowsLoading());
      final result = await _getPopularShows.execute();

      result.fold(
            (failure) {
          emit(PopularShowsError(failure.message));
        },
            (showsData) {
          emit(PopularShowsLoaded(showsData));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}
