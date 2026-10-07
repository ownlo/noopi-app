# 누피 3D 앱 로고 인트로

스플래시에서 캐릭터와 원형 테이블 장면을 제거하고 네이비 배경(#101426)
중앙에 보라색 바탕·흰색 N 앱 로고만 표시합니다. `assets/brand/app-icon.svg`의
색상과 N 경로를 사용해 Flutter Canvas로 그립니다. 원근 투영과 두께를 가진
아이콘 측면·돌출된 N·그라데이션 조명·접지 그림자로 입체감을 표현합니다.

- 0–0.65초: 기울어진 3D 앱 로고가 작게 등장하고 살짝 커졌다가 돌아옵니다.
- 0.5–2.15초: 좌우로 입체 회전하면서 점프하고 말랑하게 눌렸다 늘어납니다.
- 2.15–2.4초: 원래 크기의 앱 로고가 중앙 정면으로 돌아와 잠시 멈춥니다.
- 인트로를 한 번 재생한 뒤 웹이 준비되면 전환합니다. 로딩 중이면 정렬된 로고를 유지합니다.
- 동작 줄이기 설정에서는 완성된 로고를 바로 표시하고 웹 준비 시 전환합니다.
- 네트워크 오류와 25초 타임아웃은 기존 재시도 화면을 표시합니다.

`lib/noopi_splash.dart`에서 애니메이션과 벡터 경로를 관리합니다.
`lib/webview_page.dart`는 웹 로딩 완료와 인트로 완료를 함께 확인합니다.
모든 캐릭터 이미지의 Flutter 번들 등록을 제거했습니다. 이전 원본 자료는 보관합니다.

앱 버전은 `0.1.1+2015`입니다. 이전 ARM64 분할 APK의 버전 코드가 2014였으므로
기본 APK도 2015를 사용해 해당 버전 위에 업데이트할 수 있게 합니다.

검증 및 미리보기:

```sh
flutter analyze
flutter test
flutter test tool/render_wordmark_preview_test.dart
```

미리보기 출력은 `build/noopi-app-logo-preview.gif`,
`build/noopi-app-logo-motion.png`, `build/noopi-app-logo-settled.png`입니다.
