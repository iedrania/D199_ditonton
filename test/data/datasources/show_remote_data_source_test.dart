import 'dart:convert';
import 'dart:io';

import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/models/movie_response.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/show_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late MovieRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = MovieRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Now Airing Shows', () {
    final tShowList = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/airing_today.json')))
        .movieList;

    test('should return list of Movie Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/airing_today?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/airing_today.json'), 200, headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
              }));
      // act
      final result = await dataSource.getNowAiringShows();
      // assert
      expect(result, equals(tShowList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/airing_today?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getNowAiringShows();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular Shows', () {
    final tShowList =
        MovieResponse.fromJson(json.decode(readJson('dummy_data/popular.json')))
            .movieList;

    test('should return list of shows when response is success (200)',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/popular.json'), 200, headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
              }));
      // act
      final result = await dataSource.getPopularShows();
      // assert
      expect(result, tShowList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getPopularShows();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated Shows', () {
    final tShowList = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/top_rated.json')))
        .movieList;

    test('should return list of shows when response code is 200 ', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/top_rated.json'), 200, headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
              }));
      // act
      final result = await dataSource.getTopRatedShows();
      // assert
      expect(result, tShowList);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTopRatedShows();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get show detail', () {
    final tId = 1;
    final tShowDetail = ShowDetailResponse.fromJson(
        json.decode(readJson('dummy_data/show_detail.json')));

    test('should return show detail when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/show_detail.json'), 200, headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
              }));
      // act
      final result = await dataSource.getShowDetail(tId);
      // assert
      expect(result, equals(tShowDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getShowDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get show recommendations', () {
    final tShowList = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/show_recommendations.json')))
        .movieList;
    final tId = 1;

    test('should return list of Movie Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/show_recommendations.json'), 200, headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      }));
      // act
      final result = await dataSource.getShowRecommendations(tId);
      // assert
      expect(result, equals(tShowList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getShowRecommendations(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search shows', () {
    final tSearchResult = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/search_house_show.json')))
        .movieList;
    final tQuery = 'House';

    test('should return list of shows when response code is 200', () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/search_house_show.json'), 200, headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      }));
      // act
      final result = await dataSource.searchShows(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.searchShows(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
