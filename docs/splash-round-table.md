# 원형 테이블 보드게임 스플래시

현재 스플래시는 `assets/splash/round-table.png` 한 장을 표시합니다.
누피·우피·당비가 원형 테이블에 앉아 게임 말, 카드, 주사위로 즐겁게 노는 장면입니다.
네이티브 시작 화면과 같은 `#101426` 배경 위에 투명 PNG를 표시하며,
휴대폰에서는 좌우 8px 여백으로 크게 배치합니다. 가로 화면에서는 높이에 맞춰 전체 장면을 유지합니다.

캐릭터 애니메이션, 터치 반응, 페이드 전환과 5.2초 대기를 제거했습니다.
웹 로딩이 완료되면 즉시 웹 화면으로 전환하며 기존 오류/25초 타임아웃/재시도는 유지합니다.
이전 인사 아틀라스와 영상 제작안은 사용하지 않으며 아틀라스를 앱 자산 목록에서도 제외했습니다.

정적 분석과 테스트 12개를 통과했습니다. 390×844, 320×568, 844×390 배치와
웹 로딩 즉시 전환·오류·타임아웃·재시도를 검증했습니다.
Flutter에서 렌더링한 화면은 `build/noopi-round-table-preview.png`입니다.

## 생성 기록

내장 image_gen 도구로 생성했습니다. 투명 배경을 사용하며 원본 알파를 유지했습니다.
캐릭터 참조: `assets/brand/noopi.png`, `woopi.png`, `dangbi.png`.

### 프롬프트

Create a beautiful premium 3D plush-character illustration for a mobile app splash screen. Square composition, genuinely TRANSPARENT background. Use the three supplied images as strict character identity references: NOOPI deep violet cat with half-lidded lavender eyes and mischievous smile; WOOPI bright blue puppy with floppy ears, tuft and joyful open mouth; DANGBI ivory bunny with asymmetric ears, pink cheeks and cheerful smile. Exactly these THREE characters are SITTING on small chairs around ONE ROUND TABLE, having a wonderful lively board-game night together. Noopi seated at back center, Woopi seated at the left turned inward in three-quarter view, Dangbi seated at the right turned inward in three-quarter view. All three expressive faces are clearly visible, large, recognizable and friendly, looking at one another and at the game with laughter and playful excitement. Noopi proudly moves a colorful pawn; Woopi holds a few small cards excitedly; Dangbi laughs with paws near the tabletop. A clearly circular honey-colored wooden table seen as a wide ellipse from a gently elevated front camera, with a colorful original board game, tiny chunky colored pawns, two dice, and a small stack of cards. Cohesive physically plausible bodies, paws, chairs and table, no separate floating limbs. The complete ensemble is very large and tightly composed: fills 92% of image width and 88% of height, but all ears and the entire round table and chair feet fit inside with a narrow transparent margin. Beautiful soft velvety fur, premium animation-film lighting, warm inviting face illumination with subtle violet rim light suitable for a navy #101426 app background. Strong visual focus on the characters and shared game. No text, no letters, no logo, no watermark, no scenery, no room, no backdrop, no opaque floor, no glow cloud. A clean isolated transparent cutout of the whole round-table board-game scene. Do not make a collage, sprite sheet or character turnaround. Keep recognizable faces from references.
