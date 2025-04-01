import 'dart:html' as html;

class URL {
  Future<void> openUrlInNewTab(String url, String name) async {
    html.window.open(url, name);
  }
}
