part of 'airing_shows_bloc.dart';

abstract class NowAiringShowsState extends Equatable {
  const NowAiringShowsState();

  @override
  List<Object?> get props => [];
}

class NowAiringShowsEmpty extends NowAiringShowsState {}

class NowAiringShowsLoading extends NowAiringShowsState {}

class NowAiringShowsError extends NowAiringShowsState {
  final String message;

  NowAiringShowsError(this.message);

  @override
  List<Object?> get props => [message];
}

class NowAiringShowsLoaded extends NowAiringShowsState {
  final List<Movie> shows;

  NowAiringShowsLoaded(this.shows);

  @override
  List<Object?> get props => [shows];
}
