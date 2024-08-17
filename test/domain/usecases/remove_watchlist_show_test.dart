import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_show.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistShow usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = RemoveWatchlistShow(mockMovieRepository);
  });

  test('should remove watchlist show from repository', () async {
    // arrange
    when(mockMovieRepository.removeWatchlistShow(testShowDetail))
        .thenAnswer((_) async => Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(testShowDetail);
    // assert
    verify(mockMovieRepository.removeWatchlistShow(testShowDetail));
    expect(result, Right('Removed from watchlist'));
  });
}
