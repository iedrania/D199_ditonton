part of 'airing_shows_bloc.dart';

abstract class NowAiringShowsEvent extends Equatable {
  const NowAiringShowsEvent();

  @override
  List<Object> get props => [];
}

class FetchNowAiringShows extends NowAiringShowsEvent {}
