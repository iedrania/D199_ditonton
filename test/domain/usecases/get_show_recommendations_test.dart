import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_show_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetShowRecommendations usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetShowRecommendations(mockMovieRepository);
  });

  final tId = 1;
  final tShows = <Movie>[];

  test('should get list of show recommendations from the repository',
      () async {
    // arrange
    when(mockMovieRepository.getShowRecommendations(tId))
        .thenAnswer((_) async => Right(tShows));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(tShows));
  });
}
