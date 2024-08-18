part of 'watchlist_show_bloc.dart';

abstract class WatchlistShowsState extends Equatable {
  const WatchlistShowsState();

  @override
  List<Object?> get props => [];
}

class WatchlistShowsEmpty extends WatchlistShowsState {}

class WatchlistShowsLoading extends WatchlistShowsState {}

class WatchlistShowsError extends WatchlistShowsState {
  final String message;

  WatchlistShowsError(this.message);

  @override
  List<Object?> get props => [message];
}

class WatchlistShowsLoaded extends WatchlistShowsState {
  final List<Movie> shows;

  WatchlistShowsLoaded(this.shows);

  @override
  List<Object?> get props => [shows];
}
