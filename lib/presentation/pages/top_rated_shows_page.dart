import 'package:ditonton/presentation/bloc/top_rated_shows_bloc.dart';
import 'package:ditonton/presentation/widgets/show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        context.read<TopRatedShowsBloc>()
          ..add(FetchTopRatedShows()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedShowsBloc, TopRatedShowsState>(
          builder: (context, state) {
            if (state is TopRatedShowsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedShowsLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final show = state.shows[index];
                  return ShowCard(show);
                },
                itemCount: state.shows.length,
              );
            } else if (state is TopRatedShowsError) {
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
}
