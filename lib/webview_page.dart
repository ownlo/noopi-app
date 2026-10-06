import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'web_config.dart';

class NoopiWebViewPage extends StatefulWidget {
  const NoopiWebViewPage({super.key});

  @override
  State<NoopiWebViewPage> createState() => _NoopiWebViewPageState();
}

class _NoopiWebViewPageState extends State<NoopiWebViewPage> {
  final _config = WebConfig.fromEnvironment();
  late final WebViewController _controller;
  int _progress = 0;
  bool _failed = false;
  bool _ready = false;
  bool _handlingBack = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    try {
      await _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      await _controller.setBackgroundColor(const Color(0xFF101426));
      await _controller.setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: _navigate,
          onPageStarted: (_) {
            if (mounted) {
              setState(() {
                _progress = 0;
                _failed = false;
              });
            }
          },
          onProgress: (value) {
            if (mounted) setState(() => _progress = value);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _progress = 100);
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame == true) _showError();
          },
        ),
      );
      _ready = true;
      await _controller.loadRequest(_config.initialUri);
    } catch (_) {
      _showError();
    }
  }

  void _showError() {
    if (mounted) setState(() => _failed = true);
  }

  Future<NavigationDecision> _navigate(NavigationRequest request) async {
    if (!request.isMainFrame) return NavigationDecision.navigate;
    final uri = Uri.tryParse(request.url);
    if (uri == null) return NavigationDecision.prevent;
    if (_config.isInternal(uri)) return NavigationDecision.navigate;
    if (WebConfig.isWebUri(uri) ||
        uri.scheme == 'mailto' ||
        uri.scheme == 'tel') {
      try {
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          _showLinkError();
        }
      } catch (_) {
        _showLinkError();
      }
    }
    return NavigationDecision.prevent;
  }

  void _showLinkError() {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('링크를 열지 못했어요. 다시 시도해 주세요.')));
  }

  Future<void> _retry() async {
    setState(() {
      _failed = false;
      _progress = 0;
    });
    if (!_ready) {
      await _initialize();
      return;
    }
    try {
      // Keep the current room route when retrying a failed connection.
      final current = Uri.tryParse(await _controller.currentUrl() ?? '');
      await _controller.loadRequest(
        current != null && _config.isInternal(current)
            ? current
            : _config.initialUri,
      );
    } catch (_) {
      _showError();
    }
  }

  Future<void> _back() async {
    if (_handlingBack) return;
    _handlingBack = true;
    try {
      if (await _controller.canGoBack()) {
        await _controller.goBack();
      } else {
        await SystemNavigator.pop();
      }
    } catch (_) {
      _showError();
    } finally {
      _handlingBack = false;
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop) unawaited(_back());
    },
    child: Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (!_failed && _progress < 100)
              LinearProgressIndicator(
                value: _progress == 0 ? null : _progress / 100,
              ),
            if (_failed)
              Positioned.fill(
                child: ColoredBox(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.wifi_off_rounded, size: 48),
                          const SizedBox(height: 20),
                          const Text('누피에 연결하지 못했어요.'),
                          const SizedBox(height: 8),
                          const Text('인터넷 연결을 확인하고 다시 시도해 주세요.'),
                          const SizedBox(height: 24),
                          FilledButton(
                            onPressed: _retry,
                            child: const Text('다시 시도'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
