import 'package:creativolabs/screens/searchresults/widget/main_search_result.dart';
import 'package:flutter/material.dart';
import 'package:creativolabs/core/widgets/container.dart';

class SearchResultsView extends StatelessWidget {
  final String query;

  const SearchResultsView({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      child: Column(
        children: [
          const SizedBox(height: 20),
          MainSearchResult(query: query),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
