part of 'popular_movies_bloc.dart';

abstract class PopularMoviesState extends Equatable {
  const PopularMoviesState();

  @override
  List<Object?> get props => [];
}

class PopularMoviesEmpty extends PopularMoviesState {}

class PopularMoviesLoading extends PopularMoviesState {}

class PopularMoviesError extends PopularMoviesState {
  final String message;

  PopularMoviesError(this.message);

  @override
  List<Object?> get props => [message];
}

class PopularMoviesLoaded extends PopularMoviesState {
  final List<Movie> movies;

  PopularMoviesLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}
