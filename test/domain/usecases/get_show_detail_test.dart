import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_show_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetShowDetail usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetShowDetail(mockMovieRepository);
  });

  final tId = 1;

  test('should get show detail from the repository', () async {
    // arrange
    when(mockMovieRepository.getShowDetail(tId))
        .thenAnswer((_) async => Right(testShowDetail));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(testShowDetail));
  });
}
