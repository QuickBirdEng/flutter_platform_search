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
          NavigationPanelItem(
            header: true,
            label: fluent.Container(
              color: Colors.white,
              child: fluent.AutoSuggestBox<PlatformItem>(
                controller: queryTextController,
                items: search(query),
                onSelected: (text) {
                  print(text);
                },
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
                textBoxBuilder: (context, controller, fN, key) {
                  const BorderSide _kDefaultRoundedBorderSide = BorderSide(
                    style: BorderStyle.solid,
                    width: 0.8,
                  );

                  return TextBox(
                    key: key,
                    controller: controller,
                    focusNode: fN,
                    suffixMode: OverlayVisibilityMode.editing,
                    suffix: IconButton(
                      icon: fluent.Icon(Icons.close),
                      onPressed: () {
                        controller.clear();
                        fN.unfocus();
                      },
                    ),
                    placeholder: 'Type in a platform',
                    decoration: BoxDecoration(
                      border: Border(
                        top: _kDefaultRoundedBorderSide,
                        bottom: _kDefaultRoundedBorderSide,
                        left: _kDefaultRoundedBorderSide,
                        right: _kDefaultRoundedBorderSide,
                      ),
                      borderRadius: fN.hasFocus
                          ? BorderRadius.vertical(top: Radius.circular(3.0))
                          : BorderRadius.all(Radius.circular(3.0)),
                    ),
                  );
                },
              ),
            ),
          ),
          NavigationPanelSectionHeader(header: Text('')),
          NavigationPanelItem(
            icon: fluent.Icon(Icons.input),
            label: Text('Page 1'),
            onTapped: () {},
          ),
          NavigationPanelTileSeparator(),
          NavigationPanelItem(
            icon: fluent.Icon(Icons.format_align_center),
            label: Text('Page 2'),
            onTapped: () {},
          ),
          NavigationPanelTileSeparator(),
          NavigationPanelItem(
            icon: fluent.Icon(Icons.music_note),
            label: Text('Page 3'),
            onTapped: () {},
          ),
        ],
      ),
      body: Container(),
    );
  }
}
