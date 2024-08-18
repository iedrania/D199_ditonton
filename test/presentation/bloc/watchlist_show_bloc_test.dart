import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_watchlist_shows.dart';
import 'package:ditonton/presentation/bloc/watchlist_show_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_show_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistShows])
void main() {
  late WatchlistShowsBloc watchlistShowsBloc;
  late MockGetWatchlistShows mockGetWatchlistShows;

  setUp(() {
    mockGetWatchlistShows = MockGetWatchlistShows();
    watchlistShowsBloc = WatchlistShowsBloc(mockGetWatchlistShows);
  });

  final tShow = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tShowList = <Movie>[tShow];

  test('initial state should be empty', () {
    expect(watchlistShowsBloc.state, WatchlistShowsEmpty());
  });

  group('watchlist shows', () {
    blocTest<WatchlistShowsBloc, WatchlistShowsState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetWatchlistShows.execute())
            .thenAnswer((_) async => Right(tShowList));
        return watchlistShowsBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistShows()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        WatchlistShowsLoading(),
        WatchlistShowsLoaded(tShowList),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistShows.execute());
      },
    );

    blocTest<WatchlistShowsBloc, WatchlistShowsState>(
      'Should emit [Loading, Error] when get list is unsuccessful',
      build: () {
        when(mockGetWatchlistShows.execute())
            .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
        return watchlistShowsBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistShows()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        WatchlistShowsLoading(),
        WatchlistShowsError("Can't get data"),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistShows.execute());
      },
    );
  });
}
