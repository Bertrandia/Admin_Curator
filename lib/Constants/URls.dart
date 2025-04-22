import 'dart:html' as html;

class URL {
  void openUrlInNewTab(String url, String name) {
    html.window.open(url, name);
  }
}
