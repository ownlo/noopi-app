# 인사 영상 제작안

> 사용자가 영상 제작을 취소하고 원형 테이블 정적 이미지를 선택했습니다. 현재 구현은 [splash-round-table.md](splash-round-table.md)를 참조하세요.

기존 PNG 부위 회전 방식의 인사를 실제 영상으로 교체합니다.
참조 외형은 `assets/brand/noopi.png`, `woopi.png`, `dangbi.png`입니다.

## 제작 사양

- Veo 3.1 Image to Video, 6초, 1080p, 16:9, 무음.
- 고정 카메라, 네이비 `#101426` 배경, 접지 그림자.
- 0–2.8초: 왼쪽의 우피·누피와 오른쪽의 당비가 자연스럽게 걸어 중앙에 모임.
- 2.8–3.3초: 발을 멈추고 관객 쪽으로 몸과 시선을 돌림.
- 3.3–5.2초: 한쪽 손을 들고 두 번 인사. 눈 깜박임과 귀의 후속 움직임 포함.
- 5.2–6초: 손을 내리고 편안한 자세로 정지.

## 적용 및 검수 조건

생성 결과에서 캐릭터 외형, 발 미끄러짐, 팔다리 연결, 화면 밖 잘림과 인사 완료를 확인합니다.
검수 후 영상을 앱 내부 자산으로 포함하고 실제 재생 완료 이벤트와 웹 로딩 완료를 함께 기다립니다.
동작 줄이기에는 정지 장면을 표시합니다. 재생 초기화/재생 오류에는 무한 대기를 피하도록 대체 화면을 표시합니다.
현재 문서는 제작안이며, 아직 새 영상 생성이나 앱 교체가 완료된 상태가 아닙니다.

## 실행 상태

사용자의 명시적 승인 후 `assets/splash/video/first-frame.png`를 연결된 Weave 계정에 업로드했습니다.
Veo 3.1 Image to Video(Standard, 6초, 1080p, 무음)를 요청했지만 서비스가
`Video models are only available on paid plans` 오류를 반환했습니다.
영상 실행 ID나 결과물은 생성되지 않았으며, 새 영상의 앱 적용 및 APK 빌드는 진행하지 않았습니다.

## 영상 프롬프트

A single continuous 6-second high-quality 3D character animation using the supplied first frame. Locked-off camera, same seamless solid dark navy #101426 stage throughout, no camera movement or cuts. Preserve all three characters exactly and keep every full body and both feet in frame. 0.0–2.8 seconds: the blue puppy on the left and purple cat to its right take several small natural steps to the right; the ivory bunny on the right takes several small natural steps to the left. They meet near the middle, with puppy on the left, cat in the center, bunny on the right, leaving comfortable gaps. Real weight shifts, planted feet during each support phase, bending knees, coordinated opposite arm swing, subtle torso rotation and soft secondary ear movement. No sliding, hovering, skating or motion by translating stiff bodies. 2.8–3.3 seconds: they settle on both feet and turn their faces and torsos to look directly at the viewer. 3.3–5.2 seconds: they smile warmly and each raises one paw naturally from the shoulder and elbow and waves hello twice. Their entire bodies stay connected and volume-consistent, with subtle breathing and natural blinking. 5.2–6.0 seconds: lower paws, settle into a relaxed friendly front-facing group pose and hold for a clean ending. No dialogue, no speech or singing, no sound effects, no text, no logos, no props. Maintain original purple cat's mischievous half-lidded expression, puppy's cheerful face and bunny's pink cheeks. Smooth grounded motion with polished animation timing, not a puppet or a sequence of static pictures. Background edges remain uniform navy without spotlights or color shifts.
