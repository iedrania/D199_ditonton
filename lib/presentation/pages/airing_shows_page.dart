import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/airing_shows_notifier.dart';
import 'package:ditonton/presentation/widgets/show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AiringShowsPage extends StatefulWidget {
  static const ROUTE_NAME = '/airing-show';

  @override
  _AiringShowsPageState createState() => _AiringShowsPageState();
}

class _AiringShowsPageState extends State<AiringShowsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<AiringShowsNotifier>(context, listen: false)
            .fetchAiringShows());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Airing Today'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<AiringShowsNotifier>(
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
