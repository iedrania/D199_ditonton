import 'package:bloc/bloc.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_shows.dart';
import 'package:equatable/equatable.dart';

part 'search_shows_event.dart';
part 'search_shows_state.dart';

class SearchShowsBloc extends Bloc<SearchShowsEvent, SearchShowsState> {
  final SearchShows _searchShows;

  SearchShowsBloc(this._searchShows) : super(SearchShowsEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(SearchShowsLoading());
      final result = await _searchShows.execute(query);

      result.fold(
            (failure) {
          emit(SearchShowsError(failure.message));
        },
            (data) {
          emit(SearchShowsHasData(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}
