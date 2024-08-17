import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_airing_shows.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_popular_shows.dart';
import 'package:ditonton/domain/usecases/get_top_rated_shows.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/show_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'show_list_notifier_test.mocks.dart';

@GenerateMocks([GetNowAiringShows, GetPopularShows, GetTopRatedShows])
void main() {
  late ShowListNotifier provider;
  late MockGetNowAiringShows mockGetNowAiringShows;
  late MockGetPopularShows mockGetPopularShows;
  late MockGetTopRatedShows mockGetTopRatedShows;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowAiringShows = MockGetNowAiringShows();
    mockGetPopularShows = MockGetPopularShows();
    mockGetTopRatedShows = MockGetTopRatedShows();
    provider = ShowListNotifier(
      getNowAiringShows: mockGetNowAiringShows,
      getPopularShows: mockGetPopularShows,
      getTopRatedShows: mockGetTopRatedShows,
    )..addListener(() {
        listenerCallCount += 1;
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

  group('now airing shows', () {
    test('initialState should be Empty', () {
      expect(provider.nowAiringState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetNowAiringShows.execute())
          .thenAnswer((_) async => Right(tShowList));
      // act
      provider.fetchNowAiringShows();
      // assert
      verify(mockGetNowAiringShows.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetNowAiringShows.execute())
          .thenAnswer((_) async => Right(tShowList));
      // act
      provider.fetchNowAiringShows();
      // assert
      expect(provider.nowAiringState, RequestState.Loading);
    });

    test('should change shows when data is gotten successfully', () async {
      // arrange
      when(mockGetNowAiringShows.execute())
          .thenAnswer((_) async => Right(tShowList));
      // act
      await provider.fetchNowAiringShows();
      // assert
      expect(provider.nowAiringState, RequestState.Loaded);
      expect(provider.nowAiringShows, tShowList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetNowAiringShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchNowAiringShows();
      // assert
      expect(provider.nowAiringState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular shows', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopularShows.execute())
          .thenAnswer((_) async => Right(tShowList));
      // act
      provider.fetchPopularShows();
      // assert
      expect(provider.popularShowsState, RequestState.Loading);
      // verify(provider.setState(RequestState.Loading));
    });

    test('should change shows data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetPopularShows.execute())
          .thenAnswer((_) async => Right(tShowList));
      // act
      await provider.fetchPopularShows();
      // assert
      expect(provider.popularShowsState, RequestState.Loaded);
      expect(provider.popularShows, tShowList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularShows();
      // assert
      expect(provider.popularShowsState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated shows', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedShows.execute())
          .thenAnswer((_) async => Right(tShowList));
      // act
      provider.fetchTopRatedShows();
      // assert
      expect(provider.topRatedShowsState, RequestState.Loading);
    });

    test('should change shows data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetTopRatedShows.execute())
          .thenAnswer((_) async => Right(tShowList));
      // act
      await provider.fetchTopRatedShows();
      // assert
      expect(provider.topRatedShowsState, RequestState.Loaded);
      expect(provider.topRatedShows, tShowList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedShows();
      // assert
      expect(provider.topRatedShowsState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
