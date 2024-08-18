import 'package:ditonton/presentation/bloc/airing_shows_bloc.dart';
import 'package:ditonton/presentation/widgets/show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        context.read<NowAiringShowsBloc>()
          ..add(FetchNowAiringShows()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Airing Today'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NowAiringShowsBloc, NowAiringShowsState>(
          builder: (context, state) {
            if (state is NowAiringShowsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is NowAiringShowsLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final show = state.shows[index];
                  return ShowCard(show);
                },
                itemCount: state.shows.length,
              );
            } else if (state is NowAiringShowsError) {
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
