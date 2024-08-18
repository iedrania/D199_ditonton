part of 'search_shows_bloc.dart';

abstract class SearchShowsEvent extends Equatable {
  const SearchShowsEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChanged extends SearchShowsEvent {
  final String query;

  OnQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}