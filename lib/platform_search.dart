import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

Future<T?> showPlatformSearch<T>({
  required BuildContext context,
  required AbstractPlatformSearchDelegate<T> delegate,
  String? query = '',
}) {
  delegate.query = query ?? delegate.query;
  delegate._currentBody = _SearchBody.suggestions;
  return Navigator.of(context).push(_SearchPageRoute<T>(
    delegate: delegate,
  ));
}

abstract class AbstractPlatformSearchDelegate<T> {
  AbstractPlatformSearchDelegate({
    this.searchFieldLabel,
    this.searchFieldStyle,
    this.keyboardType,
  }) : assert(searchFieldStyle == null);

  Widget buildSuggestions(BuildContext context);
  Widget buildResults(BuildContext context);
  Widget buildScaffold(Widget? body, BuildContext context);

  String get query => queryTextController.text;
  set query(String value) {
    queryTextController.text = value;
  }

  void showResults(BuildContext context) {
    focusNode?.unfocus();
    _currentBody = _SearchBody.results;
  }

  void showSuggestions(BuildContext context) {
    assert(focusNode != null,
        '_focusNode must be set by route before showSuggestions is called.');
    focusNode!.requestFocus();
    _currentBody = _SearchBody.suggestions;
  }

  void close(BuildContext context, T result) {
    _currentBody = null;
    focusNode?.unfocus();
    Navigator.of(context)
      ..popUntil((Route<dynamic> route) => route == _route)
      ..pop(result);
  }

  final String? searchFieldLabel;
  final TextStyle? searchFieldStyle;
  final TextInputType? keyboardType;
  Animation<double> get transitionAnimation => _proxyAnimation;
  FocusNode? focusNode;

  final TextEditingController queryTextController = TextEditingController();

  final ProxyAnimation _proxyAnimation =
      ProxyAnimation(kAlwaysDismissedAnimation);

  final ValueNotifier<_SearchBody?> _currentBodyNotifier =
      ValueNotifier<_SearchBody?>(null);

  _SearchBody? get _currentBody => _currentBodyNotifier.value;
  set _currentBody(_SearchBody? value) {
    _currentBodyNotifier.value = value;
  }

  _SearchPageRoute<T>? _route;
}

enum _SearchBody {
  suggestions,
  results,
}

class _SearchPageRoute<T> extends PageRoute<T> {
  _SearchPageRoute({
    required this.delegate,
  }) {
    assert(
      delegate._route == null,
      'The ${delegate.runtimeType} instance is currently used by another active '
      'search. Please close that search by calling close() on the PlatformSearchDelegate '
      'before opening another search with the same delegate instance.',
    );
    delegate._route = this;
  }

  final AbstractPlatformSearchDelegate<T> delegate;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => false;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  Animation<double> createAnimation() {
    final Animation<double> animation = super.createAnimation();
    delegate._proxyAnimation.parent = animation;
    return animation;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return PlatformSearchWidget<T>(
      delegate: delegate,
      animation: animation,
    );
  }

  @override
  void didComplete(T? result) {
    super.didComplete(result);
    assert(delegate._route == this);
    delegate._route = null;
    delegate._currentBody = null;
  }
}

class PlatformSearchWidget<T> extends StatefulWidget {
  const PlatformSearchWidget({
    required this.delegate,
    this.animation,
  });

  final AbstractPlatformSearchDelegate<T> delegate;
  final Animation<double>? animation;

  @override
  State<StatefulWidget> createState() => _PlatformSearchWidgetState<T>();
}

class _PlatformSearchWidgetState<T> extends State<PlatformSearchWidget<T>> {
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.delegate.queryTextController.addListener(_onQueryChanged);
    widget.animation?.addStatusListener(_onAnimationStatusChanged);
    widget.delegate._currentBodyNotifier.addListener(_onSearchBodyChanged);
    focusNode.addListener(_onFocusChanged);
    widget.delegate.focusNode = focusNode;
  }

  @override
  void dispose() {
    super.dispose();
    widget.delegate.queryTextController.removeListener(_onQueryChanged);
    widget.animation?.removeStatusListener(_onAnimationStatusChanged);
    widget.delegate._currentBodyNotifier.removeListener(_onSearchBodyChanged);
    widget.delegate.focusNode = null;
    focusNode.dispose();
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status != AnimationStatus.completed) {
      return;
    }
    widget.animation?.removeStatusListener(_onAnimationStatusChanged);
    if (widget.delegate._currentBody == _SearchBody.suggestions) {
      focusNode.requestFocus();
    }
  }

  @override
  void didUpdateWidget(PlatformSearchWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.delegate != oldWidget.delegate) {
      oldWidget.delegate.queryTextController.removeListener(_onQueryChanged);
      widget.delegate.queryTextController.addListener(_onQueryChanged);
      oldWidget.delegate._currentBodyNotifier
          .removeListener(_onSearchBodyChanged);
      widget.delegate._currentBodyNotifier.addListener(_onSearchBodyChanged);
      oldWidget.delegate.focusNode = null;
      widget.delegate.focusNode = focusNode;
    }
  }

  void _onFocusChanged() {
    if (focusNode.hasFocus &&
        widget.delegate._currentBody != _SearchBody.suggestions) {
      widget.delegate.showSuggestions(context);
    }
  }

  void _onQueryChanged() {
    setState(() {});
  }

  void _onSearchBodyChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget? body;
    switch (widget.delegate._currentBody) {
      case _SearchBody.suggestions:
        body = KeyedSubtree(
          key: const ValueKey<_SearchBody>(_SearchBody.suggestions),
          child: widget.delegate.buildSuggestions(context),
        );
        break;
      case _SearchBody.results:
        body = KeyedSubtree(
          key: const ValueKey<_SearchBody>(_SearchBody.results),
          child: widget.delegate.buildResults(context),
        );
        break;
      case null:
        break;
    }

    return widget.delegate.buildScaffold(body, context);
  }
}
