import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/show_detail_page.dart';
import 'package:ditonton/presentation/provider/show_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'show_detail_page_test.mocks.dart';

@GenerateMocks([ShowDetailNotifier])
void main() {
  late MockShowDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockShowDetailNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<ShowDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when show not added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.showState).thenReturn(RequestState.Loaded);
    when(mockNotifier.show).thenReturn(testShowDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.showRecommendations).thenReturn(<Movie>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(ShowDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when show is added to wathclist',
      (WidgetTester tester) async {
    when(mockNotifier.showState).thenReturn(RequestState.Loaded);
    when(mockNotifier.show).thenReturn(testShowDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.showRecommendations).thenReturn(<Movie>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(true);

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(ShowDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.showState).thenReturn(RequestState.Loaded);
    when(mockNotifier.show).thenReturn(testShowDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.showRecommendations).thenReturn(<Movie>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('Added to Watchlist');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(ShowDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(mockNotifier.showState).thenReturn(RequestState.Loaded);
    when(mockNotifier.show).thenReturn(testShowDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.showRecommendations).thenReturn(<Movie>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('Failed');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(ShowDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
