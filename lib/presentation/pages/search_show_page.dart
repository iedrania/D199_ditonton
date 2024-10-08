import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/search_shows_bloc.dart';
import 'package:ditonton/presentation/widgets/show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchShowPage extends StatelessWidget {
  static const ROUTE_NAME = '/search-show';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<SearchShowsBloc>().add(OnQueryChanged(query));
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<SearchShowsBloc, SearchShowsState>(
              builder: (context, state) {
                if (state is SearchShowsLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SearchShowsHasData) {
                  final result = state.result;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final show = result[index];
                        return ShowCard(show);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else if (state is SearchShowsError) {
                  return Expanded(
                    child: Center(
                      child: Text(state.message),
                    ),
                  );
                } else {
                  return Expanded(
                    child: Container(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
