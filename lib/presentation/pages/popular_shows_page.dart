import 'package:ditonton/presentation/bloc/popular_shows_bloc.dart';
import 'package:ditonton/presentation/widgets/show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularShowsPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-show';

  @override
  _PopularShowsPageState createState() => _PopularShowsPageState();
}

class _PopularShowsPageState extends State<PopularShowsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<PopularShowsBloc>()
          ..add(FetchPopularShows()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularShowsBloc, PopularShowsState>(
          builder: (context, state) {
            if (state is PopularShowsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularShowsLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final show = state.shows[index];
                  return ShowCard(show);
                },
                itemCount: state.shows.length,
              );
            } else if (state is PopularShowsError) {
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
