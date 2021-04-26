import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_search_bar/main.dart';
import 'package:flutter_search_bar/platform_search.dart';

class WindowsSearchDelegate extends AbstractPlatformSearchDelegate {
  final List<PlatformItem> Function(String text) search;
  WindowsSearchDelegate(this.search);

  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Item $index'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Item $index'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget buildScaffold(Widget? body, BuildContext context) {
    const BorderSide _kDefaultRoundedBorderSide = BorderSide(
      style: BorderStyle.solid,
      width: 0.8,
    );
    return fluent.Scaffold(
      left: NavigationPanel(
        currentIndex: 2,
        menu: NavigationPanelMenuItem(
          icon: IconButton(
            icon: fluent.Icon(Icons.menu),
            onPressed: () {},
          ),
        ),
        items: [
          NavigationPanelSectionHeader(
              header: fluent.AutoSuggestBox<PlatformItem>(
            onSelected: (PlatformItem item) => print(item.name),
            controller: queryTextController,
            sorter: (String text, List items) => search.call(text),
            items: platforms,
            noResultsFound: (context) => ListTile(
              title: DefaultTextStyle(
                style: TextStyle(
                    fontWeight: FontWeight.normal, color: Colors.black),
                child: Text('No results found'),
              ),
            ),
            itemBuilder: (context, item) {
              return PlatformItemWidget(
                item,
                small: true,
              );
            },
            textBoxBuilder: (context, controller, fn, key) => TextBox(
              key: key,
              controller: controller,
              focusNode: fn,
              suffixMode: OverlayVisibilityMode.always,
              suffix: fluent.Row(
                children: [
                  controller.text.isNotEmpty
                      ? IconButton(
                          icon: fluent.Icon(Icons.close),
                          onPressed: () {
                            controller.clear();
                            fn.unfocus();
                          },
                        )
                      : fluent.SizedBox.shrink(),
                  IconButton(
                    icon: fluent.Icon(Icons.search),
                    onPressed: () {},
                  ),
                ],
              ),
              placeholder: searchFieldLabel,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: _kDefaultRoundedBorderSide,
                  bottom: _kDefaultRoundedBorderSide,
                  left: _kDefaultRoundedBorderSide,
                  right: _kDefaultRoundedBorderSide,
                ),
                borderRadius: fn.hasFocus
                    ? BorderRadius.vertical(top: Radius.circular(3.0))
                    : BorderRadius.all(Radius.circular(3.0)),
              ),
            ),
          )),
        ],
      ),
      body: Container(),
    );
  }
}
