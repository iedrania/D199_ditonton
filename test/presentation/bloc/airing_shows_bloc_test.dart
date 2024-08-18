import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_airing_shows.dart';
import 'package:ditonton/presentation/bloc/airing_shows_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'airing_shows_bloc_test.mocks.dart';

@GenerateMocks([GetNowAiringShows])
void main() {
  late NowAiringShowsBloc nowAiringShowsBloc;
  late MockGetNowAiringShows mockGetNowAiringShows;

  setUp(() {
    mockGetNowAiringShows = MockGetNowAiringShows();
    nowAiringShowsBloc = NowAiringShowsBloc(mockGetNowAiringShows);
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
    expect(nowAiringShowsBloc.state, NowAiringShowsEmpty());
  });

  group('now airing shows', () {
    blocTest<NowAiringShowsBloc, NowAiringShowsState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetNowAiringShows.execute())
            .thenAnswer((_) async => Right(tShowList));
        return nowAiringShowsBloc;
      },
      act: (bloc) => bloc.add(FetchNowAiringShows()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        NowAiringShowsLoading(),
        NowAiringShowsLoaded(tShowList),
      ],
      verify: (bloc) {
        verify(mockGetNowAiringShows.execute());
      },
    );

    blocTest<NowAiringShowsBloc, NowAiringShowsState>(
      'Should emit [Loading, Error] when get list is unsuccessful',
      build: () {
        when(mockGetNowAiringShows.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return nowAiringShowsBloc;
      },
      act: (bloc) => bloc.add(FetchNowAiringShows()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        NowAiringShowsLoading(),
        NowAiringShowsError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetNowAiringShows.execute());
      },
    );
  });
}
