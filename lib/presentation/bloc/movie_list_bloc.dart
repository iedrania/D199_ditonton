import 'package:bloc/bloc.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:equatable/equatable.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  MovieListBloc(this._getNowPlayingMovies) : super(MovieListEmpty()) {
    on<FetchMovieList>((event, emit) async {
      emit(MovieListLoading());
      final result = await _getNowPlayingMovies.execute();

      result.fold(
            (failure) {
          emit(MovieListError(failure.message));
        },
            (showsData) {
          emit(MovieListLoaded(showsData));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}
