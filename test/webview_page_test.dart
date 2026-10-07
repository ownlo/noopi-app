import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noopi_app/main.dart';
import 'package:noopi_app/noopi_splash.dart';

class TestWebViewPlatform extends InAppWebViewPlatform {
  late PlatformInAppWebViewWidgetCreationParams params;

  @override
  PlatformInAppWebViewWidget createPlatformInAppWebViewWidget(
    PlatformInAppWebViewWidgetCreationParams params,
  ) {
    this.params = params;
    return TestWebViewWidget(params);
  }
}

class TestWebViewWidget extends PlatformInAppWebViewWidget {
  TestWebViewWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) => const SizedBox.expand();

  @override
  T controllerFromPlatform<T>(PlatformInAppWebViewController controller) =>
      InAppWebViewController.fromPlatform(platform: controller) as T;

  @override
  void dispose() {}
}

class TestWebViewController extends PlatformInAppWebViewController {
  TestWebViewController()
    : super.implementation(
        const PlatformInAppWebViewControllerCreationParams(id: 1),
      );

  WebUri currentUrl = WebUri('https://noopi.kr/rooms/42');
  URLRequest? loaded;
  int backCount = 0;

  @override
  Future<WebUri?> getUrl() async => currentUrl;

  @override
  Future<void> loadUrl({
    required URLRequest urlRequest,
    WebUri? allowingReadAccessTo,
    Uri? iosAllowingReadAccessTo,
  }) async {
    loaded = urlRequest;
  }

  @override
  Future<bool> canGoBack() async => true;

  @override
  Future<void> goBack() async => backCount++;
}

void main() {
  late TestWebViewPlatform platform;
  late TestWebViewController nativeController;
  late InAppWebViewController controller;

  setUp(() {
    platform = TestWebViewPlatform();
    InAppWebViewPlatform.instance = platform;
    nativeController = TestWebViewController();
    controller = InAppWebViewController.fromPlatform(
      platform: nativeController,
    );
  });

  Future<void> mount(WidgetTester tester) async {
    await tester.pumpWidget(const NoopiApp());
    platform.params.onWebViewCreated!(controller);
  }

  testWidgets(
    'fast web readiness waits for the logo intro; subresource errors do not block it',
    (tester) async {
      await mount(tester);
      expect(find.byType(NoopiSplash), findsOneWidget);
      platform.params.onReceivedError!(
        controller,
        WebResourceRequest(
          url: WebUri('https://noopi.kr/image.png'),
          isForMainFrame: false,
        ),
        WebResourceError(
          type: WebResourceErrorType.HOST_LOOKUP,
          description: 'offline',
        ),
      );
      platform.params.onLoadStop!(controller, WebUri('https://noopi.kr'));
      await tester.pump();
      expect(find.byType(NoopiSplash), findsOneWidget);
      await tester.pump(NoopiSplash.duration);
      await tester.pump(const Duration(milliseconds: 16));
      await tester.pump();
      expect(find.byType(NoopiSplash), findsNothing);
      expect(find.text('누피에 연결하지 못했어요.'), findsNothing);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'main frame error survives load stop; retry preserves room route',
    (tester) async {
      await mount(tester);
      platform.params.onReceivedError!(
        controller,
        WebResourceRequest(
          url: nativeController.currentUrl,
          isForMainFrame: true,
        ),
        WebResourceError(
          type: WebResourceErrorType.HOST_LOOKUP,
          description: 'offline',
        ),
      );
      platform.params.onLoadStop!(controller, nativeController.currentUrl);
      await tester.pump();
      expect(find.text('누피에 연결하지 못했어요.'), findsOneWidget);
      await tester.tap(find.text('다시 시도'));
      await tester.pump();
      expect(
        nativeController.loaded?.url.toString(),
        'https://noopi.kr/rooms/42',
      );
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('initial load timeout exposes retry', (tester) async {
    await tester.pumpWidget(const NoopiApp());
    platform.params.onWebViewCreated!(controller);
    await tester.pump(const Duration(seconds: 26));
    expect(find.text('다시 시도'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('settled logo remains while the web is loading', (tester) async {
    await mount(tester);
    await tester.pump(const Duration(seconds: 7));
    await tester.pump();
    expect(find.byType(NoopiSplash), findsOneWidget);
    platform.params.onLoadStop!(controller, WebUri('https://noopi.kr'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(NoopiSplash), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('main page HTTP error is shown; retry rejects an external URL', (
    tester,
  ) async {
    await mount(tester);
    platform.params.onReceivedHttpError!(
      controller,
      WebResourceRequest(url: WebUri('https://noopi.kr'), isForMainFrame: true),
      WebResourceResponse(statusCode: 503),
    );
    await tester.pump();
    expect(find.text('누피에 연결하지 못했어요.'), findsOneWidget);
    nativeController.currentUrl = WebUri('https://other.example');
    await tester.tap(find.text('다시 시도'));
    await tester.pump();
    expect(nativeController.loaded?.url.toString(), 'https://noopi.kr');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('navigation keeps rooms inside and rejects unsupported schemes', (
    tester,
  ) async {
    await mount(tester);
    Future<NavigationActionPolicy?> navigate(
      String url, {
      bool mainFrame = true,
    }) => platform.params.shouldOverrideUrlLoading!(
      controller,
      NavigationAction(
        request: URLRequest(url: WebUri(url)),
        isForMainFrame: mainFrame,
      ),
    );
    expect(
      await navigate('https://noopi.kr/rooms/42'),
      NavigationActionPolicy.ALLOW,
    );
    expect(
      await navigate('javascript:alert(1)'),
      NavigationActionPolicy.CANCEL,
    );
    expect(
      await navigate('https://other.example/frame', mainFrame: false),
      NavigationActionPolicy.ALLOW,
    );
    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(nativeController.backCount, 1);
    await tester.pumpWidget(const SizedBox());
  });
}
