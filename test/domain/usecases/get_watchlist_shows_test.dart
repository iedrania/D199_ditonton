import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_watchlist_shows.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistShows usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetWatchlistShows(mockMovieRepository);
  });

  test('should get list of shows from the repository', () async {
    // arrange
    when(mockMovieRepository.getWatchlistShows())
        .thenAnswer((_) async => Right(testShowList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testShowList));
  });
}
