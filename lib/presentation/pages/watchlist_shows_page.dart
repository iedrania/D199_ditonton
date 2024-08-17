import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/provider/watchlist_show_notifier.dart';
import 'package:ditonton/presentation/widgets/show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistShowsPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-show';

  @override
  _WatchlistShowsPageState createState() => _WatchlistShowsPageState();
}

class _WatchlistShowsPageState extends State<WatchlistShowsPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<WatchlistShowNotifier>(context, listen: false)
            .fetchWatchlistShows());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    Provider.of<WatchlistShowNotifier>(context, listen: false)
        .fetchWatchlistShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Series Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<WatchlistShowNotifier>(
          builder: (context, data, child) {
            if (data.watchlistState == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.watchlistState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final show = data.watchlistShows[index];
                  return ShowCard(show);
                },
                itemCount: data.watchlistShows.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
