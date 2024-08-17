import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/save_watchlist_show.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlistShow usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = SaveWatchlistShow(mockMovieRepository);
  });

  test('should save show to the repository', () async {
    // arrange
    when(mockMovieRepository.saveWatchlistShow(testShowDetail))
        .thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testShowDetail);
    // assert
    verify(mockMovieRepository.saveWatchlistShow(testShowDetail));
    expect(result, Right('Added to Watchlist'));
  });
}
