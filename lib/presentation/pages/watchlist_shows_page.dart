import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/watchlist_show_bloc.dart';
import 'package:ditonton/presentation/widgets/show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        context.read<WatchlistShowsBloc>()
          ..add(FetchWatchlistShows()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<WatchlistShowsBloc>()
      ..add(FetchWatchlistShows());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Series Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistShowsBloc, WatchlistShowsState>(
          builder: (context, state) {
            if (state is WatchlistShowsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistShowsLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final show = state.shows[index];
                  return ShowCard(show);
                },
                itemCount: state.shows.length,
              );
            } else if (state is WatchlistShowsError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Text('');
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
