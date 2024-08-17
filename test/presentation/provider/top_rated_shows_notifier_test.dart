import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_shows.dart';
import 'package:ditonton/presentation/provider/top_rated_shows_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_shows_notifier_test.mocks.dart';

@GenerateMocks([GetTopRatedShows])
void main() {
  late MockGetTopRatedShows mockGetTopRatedShows;
  late TopRatedShowsNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTopRatedShows = MockGetTopRatedShows();
    notifier = TopRatedShowsNotifier(getTopRatedShows: mockGetTopRatedShows)
      ..addListener(() {
        listenerCallCount++;
      });
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

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetTopRatedShows.execute())
        .thenAnswer((_) async => Right(tShowList));
    // act
    notifier.fetchTopRatedShows();
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change shows data when data is gotten successfully', () async {
    // arrange
    when(mockGetTopRatedShows.execute())
        .thenAnswer((_) async => Right(tShowList));
    // act
    await notifier.fetchTopRatedShows();
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.shows, tShowList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetTopRatedShows.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchTopRatedShows();
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
