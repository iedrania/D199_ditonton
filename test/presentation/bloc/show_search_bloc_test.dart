import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_shows.dart';
import 'package:ditonton/presentation/bloc/search_shows_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'show_search_bloc_test.mocks.dart';

@GenerateMocks([SearchShows])
void main() {
  late SearchShowsBloc searchBloc;
  late MockSearchShows mockSearch;

  setUp(() {
    mockSearch = MockSearchShows();
    searchBloc = SearchShowsBloc(mockSearch);
  });

  test('initial state should be empty', () {
    expect(searchBloc.state, SearchShowsEmpty());
  });

  final tShowModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
    'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tShowList = <Movie>[tShowModel];
  final tQuery = 'house';

  blocTest<SearchShowsBloc, SearchShowsState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearch.execute(tQuery))
          .thenAnswer((_) async => Right(tShowList));
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchShowsLoading(),
      SearchShowsHasData(tShowList),
    ],
    verify: (bloc) {
      verify(mockSearch.execute(tQuery));
    },
  );

  blocTest<SearchShowsBloc, SearchShowsState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearch.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchShowsLoading(),
      SearchShowsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearch.execute(tQuery));
    },
  );
}
