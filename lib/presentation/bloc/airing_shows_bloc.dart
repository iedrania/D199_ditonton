import 'package:bloc/bloc.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_airing_shows.dart';
import 'package:equatable/equatable.dart';

part 'airing_shows_event.dart';
part 'airing_shows_state.dart';

class NowAiringShowsBloc extends Bloc<NowAiringShowsEvent, NowAiringShowsState> {
  final GetNowAiringShows _getNowAiringShows;

  NowAiringShowsBloc(this._getNowAiringShows) : super(NowAiringShowsEmpty()) {
    on<FetchNowAiringShows>((event, emit) async {
      emit(NowAiringShowsLoading());
      final result = await _getNowAiringShows.execute();

      result.fold(
            (failure) {
          emit(NowAiringShowsError(failure.message));
        },
            (showsData) {
          emit(NowAiringShowsLoaded(showsData));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}
