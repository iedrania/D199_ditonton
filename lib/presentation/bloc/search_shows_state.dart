part of 'search_shows_bloc.dart';

abstract class SearchShowsState extends Equatable {
  const SearchShowsState();

  @override
  List<Object> get props => [];
}

class SearchShowsEmpty extends SearchShowsState {}

class SearchShowsLoading extends SearchShowsState {}

class SearchShowsError extends SearchShowsState {
  final String message;

  SearchShowsError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchShowsHasData extends SearchShowsState {
  final List<Movie> result;

  SearchShowsHasData(this.result);

  @override
  List<Object> get props => [result];
}
