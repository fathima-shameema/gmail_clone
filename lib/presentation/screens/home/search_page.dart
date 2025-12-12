import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_clone/bloc/search_bloc/search_bloc.dart';
import 'package:gmail_clone/presentation/widgets/search_results_tile.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: controller,
          onChanged:
              (v) => context.read<SearchBloc>().add(SearchQueryChanged(v)),
          onSubmitted:
              (v) => context.read<SearchBloc>().add(SearchSubmitted(v)),
          decoration: const InputDecoration(
            hintText: 'Search mail',
            border: InputBorder.none,
          ),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state.status == SearchStatus.initial) {
            return const Center(child: Text("Search mail"));
          }

          if (state.status == SearchStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.results.isEmpty) {
            return const Center(child: Text("No results"));
          }

          return ListView.builder(
            itemCount: state.results.length,
            itemBuilder: (context, index) {
              return SearchResultTile(
                mail: state.results[index],
                query: state.query,
              );
            },
          );
        },
      ),
    );
  }
}
