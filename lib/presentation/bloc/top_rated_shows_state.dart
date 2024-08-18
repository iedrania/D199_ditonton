part of 'top_rated_shows_bloc.dart';

abstract class TopRatedShowsState extends Equatable {
  const TopRatedShowsState();

  @override
  List<Object?> get props => [];
}

class TopRatedShowsEmpty extends TopRatedShowsState {}

class TopRatedShowsLoading extends TopRatedShowsState {}

class TopRatedShowsError extends TopRatedShowsState {
  final String message;

  TopRatedShowsError(this.message);

  @override
  List<Object?> get props => [message];
}

class TopRatedShowsLoaded extends TopRatedShowsState {
  final List<Movie> shows;

  TopRatedShowsLoaded(this.shows);

  @override
  List<Object?> get props => [shows];
}
