# HARNESS_CHANGELOG.md — 하네스 진화 기록

> AI가 규칙을 추가할 때마다 자동으로 여기에 기록합니다.
> 하네스가 어떻게 성장했는지 한눈에 볼 수 있습니다.
>
> 형식: YYYY-MM-DD | 수정 파일 | 추가된 규칙 | 발견 맥락

---

## 규칙 추가 이력

| 날짜 | 파일 | 추가된 규칙 | 발견 맥락 |
|------|------|------------|-----------|
| 2026-04-04 | verify.sh | TypeScript any/async try-catch 누락/직접변이 패턴 MEDIUM 검사 3종 추가 | 하네스 엔지니어링 고도화 (2026 best practices) |
| 2026-04-04 | system-check.sh | HARNESS_CHANGELOG/AGENTS.md/docs/verification-rubric/git 사용자 검사 추가 | 하네스 엔지니어링 고도화 |
| 2026-04-04 | harness-checkpoint.sh | Level 2 자기복구 — git stash 체크포인트/롤백 스크립트 신규 생성 | 2026 harness self-repair hierarchy |
| 2026-04-04 | harness-evolve.sh | AGENTS.md 변경도 HARNESS_CHANGELOG 자동 추적 | 하네스 엔지니어링 고도화 |
| 2026-04-04 | settings.json | PreCommit 훅 추가 + UserPromptSubmit에 delta/checkpoint 상태 표시 | 하네스 엔지니어링 고도화 |
| 2026-04-04 | CLAUDE.md | 자기 복구 계층(Level 1/2) + harness-checkpoint.sh 가이드 추가 | 하네스 엔지니어링 고도화 분석 |
| 2026-04-04 | measure.sh | 3연속 delta=0 탐지 + 탐색 공간 고착 자동 경고 강화 | objective-loop 고착 방지 |
| 2026-04-04 | harness-init/SKILL.md | 비교육용 범용 harness-init 스킬 신규 생성 | system-check 참조 스킬 실체화 |

---

## 이 파일 사용법

AI가 `/edu-harness` 스킬의 **HARNESS UPDATE** 단계에서 자동으로 기록합니다.
직접 편집하거나 삭제해도 됩니다.

규칙이 쌓일수록 이 파일이 **하네스의 성장 연대기**가 됩니다.
다음 프로젝트 시작 시 이 파일을 보면 어떤 패턴을 반복적으로 발견했는지 알 수 있습니다.
