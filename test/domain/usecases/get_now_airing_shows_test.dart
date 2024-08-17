import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_airing_shows.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowAiringShows usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetNowAiringShows(mockMovieRepository);
  });

  final tShows = <Movie>[];

  test('should get list of shows from the repository', () async {
    // arrange
    when(mockMovieRepository.getNowAiringShows())
        .thenAnswer((_) async => Right(tShows));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tShows));
  });
}
