import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_show_detail.dart';
import 'package:ditonton/domain/usecases/get_show_recommendations.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_show.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_show.dart';
import 'package:ditonton/domain/usecases/save_watchlist_show.dart';
import 'package:ditonton/presentation/provider/show_detail_notifier.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'show_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetShowDetail,
  GetShowRecommendations,
  GetWatchListStatusShow,
  SaveWatchlistShow,
  RemoveWatchlistShow,
])
void main() {
  late ShowDetailNotifier provider;
  late MockGetShowDetail mockGetShowDetail;
  late MockGetShowRecommendations mockGetShowRecommendations;
  late MockGetWatchListStatusShow mockGetWatchlistStatusShow;
  late MockSaveWatchlistShow mockSaveWatchlistShow;
  late MockRemoveWatchlistShow mockRemoveWatchlistShow;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetShowDetail = MockGetShowDetail();
    mockGetShowRecommendations = MockGetShowRecommendations();
    mockGetWatchlistStatusShow = MockGetWatchListStatusShow();
    mockSaveWatchlistShow = MockSaveWatchlistShow();
    mockRemoveWatchlistShow = MockRemoveWatchlistShow();
    provider = ShowDetailNotifier(
      getShowDetail: mockGetShowDetail,
      getShowRecommendations: mockGetShowRecommendations,
      getWatchListStatus: mockGetWatchlistStatusShow,
      saveWatchlist: mockSaveWatchlistShow,
      removeWatchlist: mockRemoveWatchlistShow,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tId = 1;

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
  final tShows = <Movie>[tShow];

  void _arrangeUsecase() {
    when(mockGetShowDetail.execute(tId))
        .thenAnswer((_) async => Right(testShowDetail));
    when(mockGetShowRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tShows));
  }

  group('Get Show Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchShowDetail(tId);
      // assert
      verify(mockGetShowDetail.execute(tId));
      verify(mockGetShowRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      provider.fetchShowDetail(tId);
      // assert
      expect(provider.showState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change show when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchShowDetail(tId);
      // assert
      expect(provider.showState, RequestState.Loaded);
      expect(provider.show, testShowDetail);
      expect(listenerCallCount, 3);
    });

    test('should change recommendation shows when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchShowDetail(tId);
      // assert
      expect(provider.showState, RequestState.Loaded);
      expect(provider.showRecommendations, tShows);
    });
  });

  group('Get Show Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchShowDetail(tId);
      // assert
      verify(mockGetShowRecommendations.execute(tId));
      expect(provider.showRecommendations, tShows);
    });

    test('should update recommendation state when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchShowDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.Loaded);
      expect(provider.showRecommendations, tShows);
    });

    test('should update error message when request in successful', () async {
      // arrange
      when(mockGetShowDetail.execute(tId))
          .thenAnswer((_) async => Right(testShowDetail));
      when(mockGetShowRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await provider.fetchShowDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.Error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchlistStatusShow.execute(1)).thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistStatus(1);
      // assert
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveWatchlistShow.execute(testShowDetail))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetWatchlistStatusShow.execute(testShowDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(testShowDetail);
      // assert
      verify(mockSaveWatchlistShow.execute(testShowDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveWatchlistShow.execute(testShowDetail))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetWatchlistStatusShow.execute(testShowDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.removeFromWatchlist(testShowDetail);
      // assert
      verify(mockRemoveWatchlistShow.execute(testShowDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(mockSaveWatchlistShow.execute(testShowDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchlistStatusShow.execute(testShowDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(testShowDetail);
      // assert
      verify(mockGetWatchlistStatusShow.execute(testShowDetail.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveWatchlistShow.execute(testShowDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatusShow.execute(testShowDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.addWatchlist(testShowDetail);
      // assert
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetShowDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetShowRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tShows));
      // act
      await provider.fetchShowDetail(tId);
      // assert
      expect(provider.showState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
