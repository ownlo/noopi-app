# Android Google Play 배포

## 현재 구성

- 앱 ID: `kr.noopi.noopi_app`
- 앱 이름: 누피
- 버전: `0.1.1+2015` (`pubspec.yaml`)
- 최소 Android: API 24 (Android 7.0)
- compileSdk / targetSdk: 현재 설치된 Flutter의 기본값 36 (Android 16)
- 운영 웹 주소: `https://noopi.kr`
- release 서명: 업로드 키 (debug 키로 대체하지 않음)

2026-10-07 확인 기준 신규 모바일 앱의 Play 제출 대상 API 요건은 36 이상입니다.
Flutter SDK를 바꾸면 최종 빌드의 manifest에서 실제 SDK 값을 다시 확인하세요.

## 서명 파일 보관

이 PC에 생성한 로컬 서명 파일:

- `android/upload-keystore.jks`: RSA 2048 / SHA256withRSA, alias `upload`
- `android/key.properties`: 키 비밀번호와 keystore 경로

사용자 요청에 따라 두 파일 모두 Git으로 추적합니다. 저장소 접근자는 키와 비밀번호를
읽을 수 있으므로 저장소 접근 권한을 관리하세요. 비밀번호는 로그나 문서에 기록하지 않습니다.
두 파일을 함께 암호화된 저장소 또는 비밀번호 관리 도구에 백업하세요.
프로젝트를 복제하거나 정리하기 전에 백업을 확인하세요.
이 키는 Play에 업로드할 AAB를 서명하는 용도이며, 사용자에게 배포되는 앱 서명은
Play App Signing에서 관리합니다. Play Console에서 앱 서명 키는 Google 생성 옵션을
사용할 수 있습니다. 이후 업로드에도 같은 업로드 키를 사용하세요.

다른 PC에서는 백업한 두 파일을 복구하거나 `android/key.properties.example`을
참고해 기존 업로드 키의 정보를 설정하세요. `storeFile`의 상대 경로는
`android/`를 기준으로 해석합니다. 이미 등록한 업로드 키를 임의로 새 키로 교체하지 마세요.

## AAB 빌드

이 PC의 PowerShell:

```powershell
$env:ANDROID_HOME = "$PWD\.tools\android-sdk"
$env:JAVA_HOME = 'D:\jdk-21.0.1'
flutter build appbundle --release
```

출력: `build/app/outputs/bundle/release/app-release.aab`

### 2026-10-07 빌드 검증

- `flutter build appbundle --release` 성공, AAB 약 44.3 MiB
- release 병합 manifest: `kr.noopi.noopi_app`, `0.1.1` / versionCode `2015`, target API `36`
- `jarsigner -verify`: `jar verified`, 서명자 `CN=Noopi Upload`
- 업로드 인증서 SHA-256: `8E:51:39:52:D2:E6:C0:F2:69:4C:4C:05:61:28:6F:45:B0:65:39:67:89:D9:3D:37:BF:C8:0E:53:D1:18:83:D6`
- AAB SHA-256: `8CA89A664242AE6F97D6B48A91A872BE636EB621302A665321AFC22D1A14481D`
- AAB 안의 arm64-v8a / x86_64 `libapp.so`, `libflutter.so`: ELF PT_LOAD 정렬 65536,
  16 KB 정렬 검사 통과 (16 KB 기기 실사용 검증은 별도)
- 공개 인증서: `build/app/outputs/bundle/release/upload-certificate.pem`

빌드 도구의 향후 지원 종료 경고가 있지만 현재 빌드는 성공했습니다.
AGP 9는 현재 WebView 플러그인과 호환 문제가 있어 기존 AGP 8.13.2를 유지합니다.
실제 Play 업로드 및 Play 설치본 테스트는 아직 진행하지 않았습니다.

다음 업데이트에서는 `pubspec.yaml`의 `+2015` 부분인 versionCode를 높여야 합니다.
기존 debug 서명 APK와 업로드 키로 서명한 APK는 서명이 달라 덮어 설치할 수 없습니다.
기존 APK를 삭제하면 WebView에 저장된 참가 정보 등이 지워질 수 있습니다.
Play 설치본은 Play App Signing 키를 사용하므로 직접 배포한 APK와도 서명이 다를 수 있습니다.

## Play Console 다음 단계

1. 앱을 생성하고 스토어 등록정보와 개인정보처리방침, 데이터 보안 및 앱 콘텐츠를 작성합니다.
2. 내부 테스트 릴리스에 AAB를 업로드하고 Play App Signing을 설정합니다.
3. Play에서 설치한 앱으로 방 생성/참가, 게임, 뒤로 가기, 키보드, 네트워크 복구를 확인합니다.
4. 신규 개인 계정이면 필요한 비공개 테스트와 프로덕션 액세스 신청을 진행합니다.
5. 출시 국가와 배포 설정을 확인한 후 정식 출시 심사를 신청합니다.

## 공식 참고

- [Flutter Android 배포](https://docs.flutter.dev/deployment/android)
- [Google Play 대상 API 요건](https://support.google.com/googleplay/android-developer/answer/11926878?hl=ko)
- [Play App Signing](https://support.google.com/googleplay/android-developer/answer/9842756?hl=ko)
