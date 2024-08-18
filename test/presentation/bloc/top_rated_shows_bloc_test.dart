import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_shows.dart';
import 'package:ditonton/presentation/bloc/top_rated_shows_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_shows_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedShows])
void main() {
  late TopRatedShowsBloc topRatedShowsBloc;
  late MockGetTopRatedShows mockGetTopRatedShows;

  setUp(() {
    mockGetTopRatedShows = MockGetTopRatedShows();
    topRatedShowsBloc = TopRatedShowsBloc(mockGetTopRatedShows);
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
    expect(topRatedShowsBloc.state, TopRatedShowsEmpty());
  });

  group('top rated shows', () {
    blocTest<TopRatedShowsBloc, TopRatedShowsState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedShows.execute())
            .thenAnswer((_) async => Right(tShowList));
        return topRatedShowsBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedShows()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TopRatedShowsLoading(),
        TopRatedShowsLoaded(tShowList),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedShows.execute());
      },
    );

    blocTest<TopRatedShowsBloc, TopRatedShowsState>(
      'Should emit [Loading, Error] when get list is unsuccessful',
      build: () {
        when(mockGetTopRatedShows.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return topRatedShowsBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedShows()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TopRatedShowsLoading(),
        TopRatedShowsError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedShows.execute());
      },
    );
  });
}
