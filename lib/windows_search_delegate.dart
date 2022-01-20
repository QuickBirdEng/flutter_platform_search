import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widgets.dart';
import 'package:flutter_search_bar/main.dart';
import 'package:flutter_search_bar/platform_search.dart';

final _kPlatformNames = [...platforms.map((element) => element.name)]; // map cuz AutoSuggestBox works with Strings

final _autoSuggestBoxKey = GlobalKey(); // use the key to keep the state of the AutoSuggestBox

class WindowsSearchDelegate extends AbstractPlatformSearchDelegate {
  final List<PlatformItem> Function(String text) search;

  WindowsSearchDelegate(this.search);

  @override
  Widget buildResults(BuildContext context) => throw UnimplementedError();

  @override
  Widget buildSuggestions(BuildContext context) => throw UnimplementedError();

  @override
  Widget buildScaffold(Widget? body, BuildContext context) {
    return fluent.ScaffoldPage(
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          children: [
            fluent.AutoSuggestBox<String>(
              key: _autoSuggestBoxKey,
              placeholder: 'Search',
              onSelected: (item) => print(item),
              controller: queryTextController,
              items: _kPlatformNames,
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
