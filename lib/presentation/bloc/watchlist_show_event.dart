part of 'watchlist_show_bloc.dart';

abstract class WatchlistShowsEvent extends Equatable {
  const WatchlistShowsEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistShows extends WatchlistShowsEvent {}
