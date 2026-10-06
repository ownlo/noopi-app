# 누피 앱

기존 `noopi-web`을 Flutter의 시스템 WebView로 표시하는 Android/iOS 앱입니다.
기본 주소는 https://noopi.kr 입니다. 웹 파일을 번들에 포함하는 방식이 아니라
배포된 웹에 접속하므로 인터넷 연결이 필요합니다. 게임 판정과 실시간 통신은
기존 웹과 `noopi-api`가 담당합니다.

## 실행

```sh
flutter pub get
flutter run
```

Android 7.0(API 24) 이상, iOS 15 이상을 대상으로 합니다.
iOS 실행과 빌드는 macOS/Xcode가 필요합니다.

주소를 바꾸려면:

```sh
flutter run --dart-define=NOOPI_WEB_URL=https://your-preview-host.example
```

Android 에뮬레이터에서 로컬 웹 개발 서버에 접속하려면:

```sh
flutter run --dart-define=NOOPI_WEB_URL=http://10.0.2.2:5173
```

HTTP는 Android debug 빌드에서만 허용합니다. 실제 기기는 PC의 LAN IP와
접근 가능한 개발 서버 설정이 필요합니다. 웹이 호출하는 API/WS 주소도
기기에서 접근 가능해야 합니다. iOS와 운영 빌드는 HTTPS 주소를 사용합니다.

## 구현 범위

- JavaScript 활성화 및 시스템 WebView 저장소로 기존 익명 참가 흐름 유지
- 안전 영역과 키보드에 맞춘 화면
- 로딩 표시, 메인 페이지 오류 화면과 현재 경로 재시도
- Android 뒤로 가기: 웹 기록 이동, 기록이 없으면 앱 종료
- 같은 origin의 링크는 앱 내부, 외부 HTTP(S)/전화/메일 링크는 외부 앱

웹의 재접속 처리를 그대로 사용하며 앱 복귀 때 강제로 새로고침하지 않습니다.
별도 로그인, 게임 판정, 웹 코드 변경은 추가하지 않았습니다.

## 검증

```sh
flutter analyze
flutter test
flutter build apk --debug
```

이 PC의 Android SDK는 프로젝트 내부 `.tools/android-sdk`에 설치했습니다.
PowerShell에서 다시 빌드하려면:

```powershell
$env:ANDROID_HOME = "$PWD\.tools\android-sdk"
$env:JAVA_HOME = 'D:\jdk-21.0.1'
flutter build apk --debug
```

디버그 APK 출력 경로: `build/app/outputs/flutter-apk/app-debug.apk`.

실제 기기에서는 방 생성/코드 참가, 양궁·농구 터치와 애니메이션,
키보드, 뒤로 가기, 네트워크 복구, 백그라운드 복귀 후 WebSocket 재접속,
앱 재시작 후 clientId 유지 여부를 확인해야 합니다.

## 남은 작업

앱 아이콘은 Flutter 기본 아이콘입니다. QR 스캔, Universal Links/App Links,
네이티브 공유/진동, 웹의 PWA 설치 안내 숨김은 아직 구현하지 않았습니다.
Web Share API 등 브라우저 전용 기능은 WebView에서 별도 확인이 필요합니다.
외부 QR 링크는 현재 브라우저로 열립니다.

스토어 배포 전 앱 ID(`kr.noopi.noopi_app`), 아이콘, 버전과 배포 서명을
확정해야 합니다. 생성된 Android release 설정은 debug 서명을 사용합니다.

## 현재 검증 결과 (2026-10-06)

Flutter 정적 분석은 오류 없이 통과했고 주소/링크 정책 테스트 3개가 통과했습니다.
프로젝트 내부 Android SDK 설치 후 디버그 APK 빌드를 완료했습니다.
Windows의 D 드라이브 프로젝트/C 드라이브 Pub 캐시 조합에서 발생한
Kotlin 증분 캐시 오류를 피하기 위해 `kotlin.incremental=false`를 설정했습니다.
iOS 빌드와 실제 기기 WebView/게임 동작은 미검증입니다.
