class ScreenArguments {
  final String message;
  final bool fullscreenDialog;
  final List<int> ids;

  ScreenArguments(this.message, {this.fullscreenDialog = false, this.ids = const <int>[]});
}
