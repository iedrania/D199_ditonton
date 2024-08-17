import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/movie_model.dart';
import 'package:ditonton/data/models/show_detail_model.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieRepositoryImpl repository;
  late MockMovieRemoteDataSource mockRemoteDataSource;
  late MockMovieLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockMovieRemoteDataSource();
    mockLocalDataSource = MockMovieLocalDataSource();
    repository = MovieRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tShowModel = MovieModel(
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

  final tShow = Movie(
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

  final tShowModelList = <MovieModel>[tShowModel];
  final tShowList = <Movie>[tShow];

  group('Now Airing Shows', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getNowAiringShows())
          .thenAnswer((_) async => tShowModelList);
      // act
      final result = await repository.getNowAiringShows();
      // assert
      verify(mockRemoteDataSource.getNowAiringShows());
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tShowList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getNowAiringShows())
          .thenThrow(ServerException());
      // act
      final result = await repository.getNowAiringShows();
      // assert
      verify(mockRemoteDataSource.getNowAiringShows());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getNowAiringShows())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getNowAiringShows();
      // assert
      verify(mockRemoteDataSource.getNowAiringShows());
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Popular Shows', () {
    test('should return show list when call to data source is success',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularShows())
          .thenAnswer((_) async => tShowModelList);
      // act
      final result = await repository.getPopularShows();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tShowList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularShows())
          .thenThrow(ServerException());
      // act
      final result = await repository.getPopularShows();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularShows())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getPopularShows();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Top Rated Shows', () {
    test('should return show list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedShows())
          .thenAnswer((_) async => tShowModelList);
      // act
      final result = await repository.getTopRatedShows();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tShowList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedShows())
          .thenThrow(ServerException());
      // act
      final result = await repository.getTopRatedShows();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedShows())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTopRatedShows();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Get Show Detail', () {
    final tId = 1;
    final tShowResponse = ShowDetailResponse(
      adult: false,
      backdropPath: 'backdropPath',
      genres: [GenreModel(id: 1, name: 'Action')],
      homepage: "https://google.com",
      id: 1,
      originalLanguage: 'en',
      originalName: 'originalName',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      firstAirDate: 'firstAirDate',
      numberOfEpisodes: 120,
      status: 'Status',
      tagline: 'Tagline',
      name: 'name',
      voteAverage: 1,
      voteCount: 1,
    );

    test(
        'should return Show data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getShowDetail(tId))
          .thenAnswer((_) async => tShowResponse);
      // act
      final result = await repository.getShowDetail(tId);
      // assert
      verify(mockRemoteDataSource.getShowDetail(tId));
      expect(result, equals(Right(testShowDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getShowDetail(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getShowDetail(tId);
      // assert
      verify(mockRemoteDataSource.getShowDetail(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getShowDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getShowDetail(tId);
      // assert
      verify(mockRemoteDataSource.getShowDetail(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Show Recommendations', () {
    final tShowList = <MovieModel>[];
    final tId = 1;

    test('should return data (show list) when the call is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getShowRecommendations(tId))
          .thenAnswer((_) async => tShowList);
      // act
      final result = await repository.getShowRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getShowRecommendations(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tShowList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getShowRecommendations(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getShowRecommendations(tId);
      // assertbuild runner
      verify(mockRemoteDataSource.getShowRecommendations(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getShowRecommendations(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getShowRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getShowRecommendations(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Search Shows', () {
    final tQuery = 'house';

    test('should return show list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchShows(tQuery))
          .thenAnswer((_) async => tShowModelList);
      // act
      final result = await repository.searchShows(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tShowList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchShows(tQuery))
          .thenThrow(ServerException());
      // act
      final result = await repository.searchShows(tQuery);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.searchShows(tQuery))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.searchShows(tQuery);
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlistShow(testShowTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlistShow(testShowDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlistShow(testShowTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlistShow(testShowDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlistShow(testShowTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlistShow(testShowDetail);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlistShow(testShowTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlistShow(testShowDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.getShowById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlistShow(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist shows', () {
    test('should return list of Shows', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistShows())
          .thenAnswer((_) async => [testShowTable]);
      // act
      final result = await repository.getWatchlistShows();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistShow]);
    });
  });
}
