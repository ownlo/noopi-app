import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'web_config.dart';
import 'noopi_splash.dart';

class NoopiWebViewPage extends StatefulWidget {
  const NoopiWebViewPage({super.key});

  @override
  State<NoopiWebViewPage> createState() => _NoopiWebViewPageState();
}

class _NoopiWebViewPageState extends State<NoopiWebViewPage> {
  final _config = WebConfig.fromEnvironment();
  InAppWebViewController? _controller;
  int _progress = 0;
  bool _failed = false;
  int _webViewGeneration = 0;
  bool _handlingBack = false;
  bool _initialLoading = true;
  Timer? _initialLoadTimeout;

  @override
  void initState() {
    super.initState();
    _startLoadTimeout();
  }

  void _startLoadTimeout() {
    _initialLoadTimeout?.cancel();
    _initialLoadTimeout = Timer(const Duration(seconds: 25), () {
      if (_initialLoading) _showError();
    });
  }

  @override
  void dispose() {
    _initialLoadTimeout?.cancel();
    super.dispose();
  }

  void _showError() {
    _initialLoadTimeout?.cancel();
    if (mounted) setState(() => _failed = true);
  }

  Future<NavigationActionPolicy> _navigate(NavigationAction action) async {
    if (action.isForMainFrame == false) return NavigationActionPolicy.ALLOW;
    final url = action.request.url;
    final uri = url == null ? null : Uri.tryParse(url.toString());
    if (uri == null) return NavigationActionPolicy.CANCEL;
    if (_config.isInternal(uri)) return NavigationActionPolicy.ALLOW;
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
    return NavigationActionPolicy.CANCEL;
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
    if (_initialLoading) _startLoadTimeout();
    final controller = _controller;
    if (controller == null) {
      setState(() => _webViewGeneration++);
      return;
    }
    try {
      // Keep the current room route when retrying a failed connection.
      final current = Uri.tryParse(
        (await controller.getUrl())?.toString() ?? '',
      );
      await controller.loadUrl(
        urlRequest: URLRequest(
          url: WebUri.uri(
            current != null && _config.isInternal(current)
                ? current
                : _config.initialUri,
          ),
        ),
      );
    } catch (_) {
      _showError();
    }
  }

  Future<void> _back() async {
    if (_handlingBack) return;
    _handlingBack = true;
    try {
      final controller = _controller;
      if (controller != null && await controller.canGoBack()) {
        await controller.goBack();
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
            InAppWebView(
              key: ValueKey(_webViewGeneration),
              initialUrlRequest: URLRequest(
                url: WebUri.uri(_config.initialUri),
              ),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                domStorageEnabled: true,
                useShouldOverrideUrlLoading: true,
                useHybridComposition: true,
                hardwareAcceleration: true,
                transparentBackground: false,
                // The app already paints the navy background behind the view.
                underPageBackgroundColor: const Color(0xFF101426),
              ),
              onWebViewCreated: (controller) => _controller = controller,
              shouldOverrideUrlLoading: (_, action) => _navigate(action),
              onLoadStart: (_, _) {
                if (!mounted) return;
                setState(() {
                  _progress = 0;
                  _failed = false;
                });
              },
              onProgressChanged: (_, value) {
                if (mounted && _progress != value) {
                  setState(() => _progress = value);
                }
              },
              onLoadStop: (_, _) {
                _initialLoadTimeout?.cancel();
                if (!mounted || _failed) return;
                setState(() {
                  _progress = 100;
                  _initialLoading = false;
                });
              },
              onReceivedError: (_, request, _) {
                if (request.isForMainFrame == true) _showError();
              },
              onReceivedHttpError: (_, request, response) {
                if (request.isForMainFrame == true &&
                    (response.statusCode ?? 0) >= 400) {
                  _showError();
                }
              },
            ),
            if (!_initialLoading && !_failed && _progress < 100)
              LinearProgressIndicator(
                value: _progress == 0 ? null : _progress / 100,
              ),
            Positioned.fill(
              child: IgnorePointer(
                ignoring: !_initialLoading || _failed,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  child: _initialLoading && !_failed
                      ? const NoopiSplash()
                      : const SizedBox.shrink(),
                ),
              ),
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
