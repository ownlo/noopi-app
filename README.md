# 누피 앱

기존 `noopi-web`을 `flutter_inappwebview`의 시스템 WebView로 표시하는 Android/iOS 앱입니다.
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

앱의 기본 웹뷰는 `flutter_inappwebview` 6.1.5로 완전히 교체했습니다.
별도 비교 모드나 기존 웹뷰를 사용하는 경로는 없습니다.
Android에서 하이브리드 합성과
하드웨어 가속을 활성화합니다. JavaScript와 DOM 저장소를 사용하고,
기존 스플래시, 같은 origin 링크, 외부 링크, 뒤로 가기와 재시도를 유지합니다.
안정 버전 플러그인의 ProGuard 설정은 AGP 9와 호환되지 않아 Android 빌드 도구를
AGP 8.13.2 / Gradle 8.14.3 / Kotlin 2.2.20 조합으로 맞췄습니다.

실제 기기 실행에는 release 빌드를 사용합니다.

```sh
flutter run --release
flutter build apk --release
```

앱 APK: `build/app/outputs/flutter-apk/app-release.apk` (버전 `0.1.1+2015`).
release 빌드는 `android/key.properties`의 업로드 키로 서명합니다.
키가 없는 환경에서는 `android/key.properties.example`을 참고해 설정해야 하며,
debug 키로 자동 대체하지 않습니다. 스토어 배포 절차는 `docs/android-release.md`를 참고하세요.

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
- noopi-web 브랜드와 같은 보라색 바탕·흰색 N 마크의 Android/iOS 앱 아이콘
- Flutter 스플래시와 같은 네이비색(`#101426`) 네이티브 시작 화면
- 캐릭터 없이 네이비 배경 중앙에 보라색 바탕·흰색 N 앱 로고 표시
- 두께·조명·원근감이 있는 3D 로고가 등장·회전·점프 후 정면으로 돌아오는 2.4초 인트로
- 인트로와 웹 로딩이 모두 끝나면 전환, 늦게 로딩되면 정렬된 로고 유지
- OS 동작 줄이기 설정에서는 애니메이션을 생략, 25초 응답 지연 시 재시도 화면

아이콘과 네이티브 시작 화면은 `pubspec.yaml`의 생성 설정으로 관리합니다.
앱 아이콘 생성 원본은 `assets/brand/`에 보관합니다. Flutter 스플래시는 벡터로
그리므로 이미지 파일을 번들에 등록하지 않으며 캐릭터 이미지도 APK에 포함하지 않습니다.
앱 아이콘의 웹 브랜드 원본과 적응형 아이콘 구성은 `docs/app-icon-artwork.md`에 기록했습니다.

```sh
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

Android 네이티브 시작 화면과 `NormalTheme` 배경은 `#101426`으로 유지합니다.
네이티브 스플래시를 재생성하면 해당 배경도 다시 확인해야 합니다.
Android 12의 아이콘 배경도 같은 색을 사용하며 다크 모드에도 동일하게 적용합니다.
Android 12 이상에서는 Flutter 첫 화면이 준비되면 시스템 시작 화면을 즉시 제거해
별도 종료 애니메이션을 생략합니다. OS가 앱 초기화 중 보여주는 시작 화면 자체와
런처의 진입 애니메이션은 완전히 없앨 수 없습니다.

웹의 재접속 처리를 그대로 사용하며 앱 복귀 때 강제로 새로고침하지 않습니다.
별도 로그인, 게임 판정, 웹 코드 변경은 추가하지 않았습니다.

현재 로고 인트로와 검증 방식은 `docs/splash-wordmark.md`에 기록했습니다.

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

QR 스캔, Universal Links/App Links,
네이티브 공유/진동, 웹의 PWA 설치 안내 숨김은 아직 구현하지 않았습니다.
Web Share API 등 브라우저 전용 기능은 WebView에서 별도 확인이 필요합니다.
외부 QR 링크는 현재 브라우저로 열립니다.

스토어 배포 앱 ID는 `kr.noopi.noopi_app`이며, 첫 업로드 전에 확인해야 합니다.
release 서명은 업로드 키를 사용합니다. Play Console 등록정보와 정책 신고,
테스트 트랙 배포는 별도로 진행해야 합니다.

## 웹뷰 교체 검증 (2026-10-07)

`0.1.0+14`는 캐릭터를 제거하고 중앙에 보라색 바탕·흰색 N 앱 아이콘을 표시합니다.
두께와 원근감을 가진 3D 로고가 귀엽게 회전하고 튀다가 정면으로 돌아옵니다.
인트로와 웹 로딩을 함께 기다리며 동작 줄이기에서는 정적 로고를 표시합니다.

`0.1.0+12`는 원형 테이블 보드게임 이미지를 크게 표시합니다.
걷기·인사 애니메이션과 고정 대기를 제거하고 웹 로딩 완료 즉시 전환합니다.

최신 아이콘은 웹 브랜드의 N 마크로 교체한 `0.1.0+9`입니다.
정적 분석, 원형·둥근 사각형·48픽셀 미리보기와 네이티브 시작 화면 배경색을 확인했습니다.

아이콘을 누피 캐릭터로 교체한 `0.1.0+6`의 release/debug APK를 생성했습니다.
Android 적응형 아이콘의 원형·둥근 사각형 및 48픽셀 미리보기를 확인했고,
iOS 아이콘도 모든 크기로 다시 생성했습니다.

`flutter_inappwebview` 교체 후 정적 분석과 전체 테스트 13개를 통과했고,
release APK(약 51MB)를 빌드했습니다. 추가 테스트는 로딩 성공/실패, HTTP 오류,
25초 타임아웃, 방 경로 재시도와 외부 URL 차단, 링크 정책과 뒤로 가기를 검증합니다.
Android 스플래시의 0픽셀 PNG도 복구했으며 투명 원본을 4×4로 늘려
낮은 화면 밀도로 재생성할 때도 0픽셀이 되지 않게 했습니다.
실기기 프레임 비교와 iOS 빌드는 미검증입니다.

## 이전 검증 결과 (2026-10-06)

Flutter 정적 분석, 주소/링크 정책 테스트 3개와 스플래시 테스트 5개를 통과했습니다.
스플래시는 390×844, 320×568, 844×390에서 큰 글씨/동작 줄이기를 검증했고
새 놀이 장면 표시, 글자·로고 제거, 장면 애니메이션과 동작 줄이기도 검증했습니다.
Flutter로 렌더링한 PNG/GIF 미리보기는 `build/noopi-splash-preview.*`에 있습니다.
프로젝트 내부 Android SDK 설치 후 디버그 APK 빌드를 완료했습니다.
Windows의 D 드라이브 프로젝트/C 드라이브 Pub 캐시 조합에서 발생한
Kotlin 증분 캐시 오류를 피하기 위해 `kotlin.incremental=false`를 설정했습니다.
iOS 빌드와 실제 기기 WebView/게임 동작은 미검증입니다.

새 스플래시 그림은 내장 이미지 생성 도구로 만들었으며 캐릭터 참조와
생성 프롬프트는 `docs/splash-artwork.md`에 기록했습니다.
