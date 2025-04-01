import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'dart:typed_data';

class WebPdfViewer extends StatefulWidget {
  final Uint8List? pdfBytes;
  final double maxWidth;
  final String fileName;

  const WebPdfViewer({
    super.key,
    required this.pdfBytes,
    this.maxWidth = 700,
    this.fileName = "document.pdf",
  });

  @override
  WebPdfViewerState createState() => WebPdfViewerState();
}

class WebPdfViewerState extends State<WebPdfViewer> {
  late String _viewId;
  bool _hasError = false;
  String _errorMessage = '';
  late Uint8List _currentPdfBytes;
  String? _blobUrl;

  @override
  void initState() {
    super.initState();
    _currentPdfBytes = widget.pdfBytes!;
    _viewId = 'pdf-viewer-${DateTime.now().millisecondsSinceEpoch}';
    _loadPdfViewer();
  }

  @override
  void didUpdateWidget(WebPdfViewer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if PDF bytes have changed
    if (!_areByteListsEqual(widget.pdfBytes!, _currentPdfBytes)) {
      _currentPdfBytes = widget.pdfBytes!;

      // Clean up old resources
      if (_blobUrl != null) {
        html.Url.revokeObjectUrl(_blobUrl!);
      }

      // Generate a new viewId to force the view to be recreated
      setState(() {
        _viewId = 'pdf-viewer-${DateTime.now().millisecondsSinceEpoch}';
        _loadPdfViewer();
      });
    }
  }

  // Helper method to compare Uint8List objects
  bool _areByteListsEqual(Uint8List a, Uint8List b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _loadPdfViewer() {
    try {
      final blob = html.Blob([_currentPdfBytes], 'application/pdf');
      _blobUrl = html.Url.createObjectUrlFromBlob(blob);

      ui_web.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
        final container =
            html.DivElement()
              ..style.width = '100%'
              ..style.height = '100%'
              ..style.overflow = 'hidden'
              ..style.margin = '0'
              ..style.padding = '0';

        final iframe =
            html.IFrameElement()
              ..style.width = '100%'
              ..style.height = '100%'
              ..style.border = 'none'
              ..style.margin = '0'
              ..style.padding = '0'
              ..style.overflow = 'hidden'
              ..allowFullscreen = false
              ..src = '$_blobUrl#toolbar=0&navpanes=0&scrollbar=0';

        container.append(iframe);
        return container;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    if (_blobUrl != null) {
      html.Url.revokeObjectUrl(_blobUrl!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Center(
        child: Text(
          'PDF Preview Error: $_errorMessage',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    return Stack(
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: widget.maxWidth),
          height: 600,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
          child: HtmlElementView(viewType: _viewId),
        ),
      ],
    );
  }
}
