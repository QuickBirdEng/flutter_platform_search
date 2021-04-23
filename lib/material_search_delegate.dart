import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_search_bar/main.dart';
import 'package:flutter_search_bar/platform_search.dart';

class MaterialSearchDelegate extends AbstractPlatformSearchDelegate {
  final List<PlatformItem> Function(String text) search;
  MaterialSearchDelegate(this.search);

  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  Widget buildResults(BuildContext context) {
    final List<PlatformItem> result = search(query);
    return PlatformItemsWidget(result);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<PlatformItem> result = search(query);
    return PlatformItemsWidget(result);
  }

  @override
  Widget buildScaffold(Widget? body, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: buildLeading(context),
        title: TextField(
          controller: queryTextController,
          focusNode: focusNode,
          textInputAction: TextInputAction.search,
          onSubmitted: (String _) {
            showResults(context);
          },
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: searchFieldLabel,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            labelStyle: TextStyle(color: Colors.white),
            focusColor: Colors.white,
          ),
        ),
        actions: buildActions(context),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: body,
      ),
    );
  }
}
