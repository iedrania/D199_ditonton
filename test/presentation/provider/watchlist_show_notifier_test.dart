import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_watchlist_shows.dart';
import 'package:ditonton/presentation/provider/watchlist_show_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_show_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistShows])
void main() {
  late WatchlistShowNotifier provider;
  late MockGetWatchlistShows mockGetWatchlistShows;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetWatchlistShows = MockGetWatchlistShows();
    provider = WatchlistShowNotifier(
      getWatchlistShows: mockGetWatchlistShows,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  test('should change shows data when data is gotten successfully', () async {
    // arrange
    when(mockGetWatchlistShows.execute())
        .thenAnswer((_) async => Right([testWatchlistShow]));
    // act
    await provider.fetchWatchlistShows();
    // assert
    expect(provider.watchlistState, RequestState.Loaded);
    expect(provider.watchlistShows, [testWatchlistShow]);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetWatchlistShows.execute())
        .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
    // act
    await provider.fetchWatchlistShows();
    // assert
    expect(provider.watchlistState, RequestState.Error);
    expect(provider.message, "Can't get data");
    expect(listenerCallCount, 2);
  });
}
