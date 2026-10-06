import 'package:flutter_test/flutter_test.dart';
import 'package:noopi_app/web_config.dart';

void main() {
  test('room links stay inside, other origins leave the WebView', () {
    final config = WebConfig('https://noopi.kr');
    expect(
      config.isInternal(Uri.parse('https://noopi.kr/rooms/42?code=ABC')),
      isTrue,
    );
    for (final url in [
      'https://noopi.kr.example.com',
      'https://other.kr',
      'http://noopi.kr',
      'https://noopi.kr:8443',
      'https://user@noopi.kr',
      'javascript:alert(1)',
    ]) {
      expect(config.isInternal(Uri.parse(url)), isFalse, reason: url);
    }
  });

  test('development server origin includes its port', () {
    final config = WebConfig('http://10.0.2.2:5173');
    expect(config.isInternal(Uri.parse('http://10.0.2.2:5173/join')), isTrue);
    expect(config.isInternal(Uri.parse('http://10.0.2.2:8080')), isFalse);
  });

  test('invalid startup addresses are rejected', () {
    for (final url in [
      'noopi.kr',
      'file:///index.html',
      'https://user@noopi.kr',
    ]) {
      expect(() => WebConfig(url), throwsArgumentError);
    }
  });
}
