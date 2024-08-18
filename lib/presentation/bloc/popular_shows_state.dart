part of 'popular_shows_bloc.dart';

abstract class PopularShowsState extends Equatable {
  const PopularShowsState();

  @override
  List<Object?> get props => [];
}

class PopularShowsEmpty extends PopularShowsState {}

class PopularShowsLoading extends PopularShowsState {}

class PopularShowsError extends PopularShowsState {
  final String message;

  PopularShowsError(this.message);

  @override
  List<Object?> get props => [message];
}

class PopularShowsLoaded extends PopularShowsState {
  final List<Movie> shows;

  PopularShowsLoaded(this.shows);

  @override
  List<Object?> get props => [shows];
}
