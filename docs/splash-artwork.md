# 누피 스플래시 일러스트

생성 방식: 내장 image_gen, 투명 배경.
참조: 누피(보라 고양이), 우피(파란 강아지), 당비(흰 토끼)의 기존 캐릭터 자산.
결과: assets/brand/play-together.png

## 화면 인터랙션 (0.1.0+10)

일러스트 원본은 유지하고 화면 연출을 교체했습니다. 궤도와 로딩 점을 없애고,
터치 위치에 따라 장면을 원근 기울기와 패럴랙스로 이동시킵니다. 손을 떼면
스프링으로 제자리로 복귀하며, 탭은 짧은 떠오름·작은 파동·햅틱으로 응답합니다.
동작 줄이기에서는 등장·반복 움직임·탭·드래그 애니메이션을 멈춥니다.
웹이 준비되면 220ms로 전환하며, 터치하거나 애니메이션이 끝날 때까지 기다리지 않습니다.
미리보기: build/noopi-splash-preview.png / build/noopi-splash-preview.gif.

## 생성 프롬프트

Use case: stylized-concept. Asset type: a brand-new premium mobile app splash illustration, one coherent scene on a genuinely transparent background. These three reference images are CHARACTER IDENTITY references only, not a composition to reproduce. Image 1 is NOOPI, a plush deep violet mischievous cat with pointed ears and purple rim light. Image 2 is WOOPI, a plush bright blue puppy with floppy ears and a little forelock. Image 3 is DANGBI, a plush ivory-white rabbit with asymmetric upright ears, pink cheeks and pink nose. Preserve their distinctive faces, colors and soft plush 3D material closely. Primary request: draw a completely NEW scene where these three friends are visibly PLAYING TOGETHER, interacting with each other, with brand-new full-body poses. A joyful shared dice game: the white rabbit in the middle has just tossed one large rounded lavender dice into the center; the violet cat on the right leans forward playfully reaching a paw toward the dice; the blue puppy on the left excitedly raises a paw toward its friends while laughing. Their gazes and gestures converge on the same dice, and bodies lean inward, creating a believable connected playful group, NOT three separate portraits or a pasted collage. The die has simple round pips only. All three characters visible, cute small rounded bodies, natural paws and proportions, expressive happy faces, tiny soft contact shadows, a few subtle small pastel game pieces near their paws. Premium modern polished 3D studio illustration, tactile plush fur with subtle detail, restrained violet and icy blue edge lighting, soft cinematic lighting, uncluttered composition and beautiful silhouette. Composition: roughly square compact group with all ears, paws and bodies entirely inside the frame, generous transparent padding at all four edges so it fits any phone splash. No typography, no letters, no numbers, no brand logo, no watermark, no UI, no loading indicators, no borders, no background scenery, no extra characters, no clothing, no tiled layout. Generate the actual shared playful scene, not an app screenshot. Actual alpha transparency.
