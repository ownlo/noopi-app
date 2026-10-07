# 누피 N 마크 앱 아이콘

noopi-web 좌상단 브랜드의 보라색 바탕과 흰색 N 마크 스타일로 통일했습니다.
새 이미지를 생성하지 않고 웹 프로젝트의 기존 브랜드 자산을 재사용합니다.

- 일반 Android/iOS 원본: assets/brand/app-icon.png. 출처: noopi-web/public/icons/noopi-master-1024.png.
- 벡터 원본: assets/brand/app-icon.svg. 출처: noopi-web/public/icons/noopi-icon.svg.
- Android 적응형 전경: assets/brand/app-icon-foreground.png. 기존 SVG의 N 경로와 획, -4도 회전을 유지해 투명 PNG로 렌더링합니다.
- 적응형 아이콘 배경: #6540E8. 전경 inset: 8%. 네이티브 시작 화면은 Flutter 로딩 화면과 같은 #101426을 사용합니다.
- 원형·둥근 사각형·48픽셀 미리보기: build/noopi-app-icon-preview.png.

재생성:

```sh
flutter test tool/render_brand_icon_test.dart
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

네이티브 시작 화면 재생성 후 Android NormalTheme과 iOS LaunchScreen의 배경색도 #101426인지 확인합니다.