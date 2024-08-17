import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_shows.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchShows usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = SearchShows(mockMovieRepository);
  });

  final tShows = <Movie>[];
  final tQuery = 'House';

  test('should get list of shows from the repository', () async {
    // arrange
    when(mockMovieRepository.searchShows(tQuery))
        .thenAnswer((_) async => Right(tShows));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(tShows));
  });
}
