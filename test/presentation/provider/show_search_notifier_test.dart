import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_shows.dart';
import 'package:ditonton/presentation/provider/show_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'show_search_notifier_test.mocks.dart';

@GenerateMocks([SearchShows])
void main() {
  late ShowSearchNotifier provider;
  late MockSearchShows mockSearchShows;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchShows = MockSearchShows();
    provider = ShowSearchNotifier(searchShows: mockSearchShows)
      ..addListener(() {
        listenerCallCount += 1;
      });
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
  final tQuery = 'spiderman';

  group('search shows', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockSearchShows.execute(tQuery))
          .thenAnswer((_) async => Right(tShowList));
      // act
      provider.fetchShowSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully',
        () async {
      // arrange
      when(mockSearchShows.execute(tQuery))
          .thenAnswer((_) async => Right(tShowList));
      // act
      await provider.fetchShowSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loaded);
      expect(provider.searchResult, tShowList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchShows.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchShowSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
