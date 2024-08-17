import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/top_rated_shows_notifier.dart';
import 'package:ditonton/presentation/widgets/show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopRatedShowsPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-show';

  @override
  _TopRatedShowsPageState createState() => _TopRatedShowsPageState();
}

class _TopRatedShowsPageState extends State<TopRatedShowsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TopRatedShowsNotifier>(context, listen: false)
            .fetchTopRatedShows());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TopRatedShowsNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final show = data.shows[index];
                  return ShowCard(show);
                },
                itemCount: data.shows.length,
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
}
