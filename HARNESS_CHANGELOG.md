# HARNESS_CHANGELOG.md — 하네스 진화 기록

> AI가 규칙을 추가할 때마다 자동으로 여기에 기록합니다.
> 하네스가 어떻게 성장했는지 한눈에 볼 수 있습니다.
>
> 형식: YYYY-MM-DD | 수정 파일 | 추가된 규칙 | 발견 맥락

---

## 규칙 추가 이력

| 날짜 | 파일 | 추가된 규칙 | 발견 맥락 |
|------|------|------------|-----------|
| 2026-04-04 | verify.sh | Dim10 함수 길이 50줄 초과 + Dim11 중첩 4단계 초과 MEDIUM 검사 추가 (5→7개) | v7.0 — CLAUDE.md 규칙 자동화 갭 해소 |
| 2026-04-04 | system-check.sh | 앵커 섹션/harness-audit.md/Evaluator 역할 존재 검사 3개 추가 (15→18항목) | v7.0 — v6.0 컴포넌트 커버리지 갭 해소 |
| 2026-04-04 | harness-health.sh | 하네스 전체 상태 대시보드 신규 생성 (verify/system-check/checkpoint/loop/delta/changelog/anchor) | v7.0 — 관찰성 강화 |
| 2026-04-04 | execution-loop/SKILL.md | 단계 0 스프린트 계약 사전 확인 강제화 + contract_status 필드 포맷 추가 | v7.0 — Anthropic $9 vs $200 연구 강화 |
| 2026-04-04 | docs/decision-log.md | ADR 구조화 템플릿 신규 생성 + ADR-001/002 실제 예시 포함 | v7.0 — 의사결정 추적 체계화 |
| 2026-04-04 | CLAUDE.md | 참고 문서 테이블에 decision-log.md + harness-audit.md 추가 | v7.0 |
| 2026-04-04 | progress.md | 컨텍스트 앵커 섹션(4필드) + 실제 작성 예시 추가 | 오토 리서치 v6.0 — Anchored Context Transfer |
| 2026-04-04 | CLAUDE.md | 앵커 작성 의무 + 단일 기능 세션 경계 + 6단계 세션 의식 + 도구 위험 분류 테이블 추가 | 오토 리서치 v6.0 — OWASP Agentic + IMPACT Framework |
| 2026-04-04 | execution-loop/SKILL.md | Parse/Tool/Logic 오류 3분류 + 계층적 복구 전략(L1~L4) + 증상 매핑 표 추가 | 오토 리서치 v6.0 — arXiv 2603.06847 |
| 2026-04-04 | AGENTS.md | Evaluator(Generator-Evaluator 패턴) + Harness Auditor 역할 추가, 작업 흐름에 Evaluator 삽입 | 오토 리서치 v6.0 — Goodhart's Law 방어 |
| 2026-04-04 | verify/SKILL.md | Step 0.5 헌법적 자기비판 단계 추가 (불변성/any/try-catch/800줄/변이 체크리스트) | 오토 리서치 v6.0 — Constitutional AI at Harness Level |
| 2026-04-04 | verify.sh | --self-critique 플래그 추가 — grep 기반 자기비판 MEDIUM 항목 3종 | 오토 리서치 v6.0 — Constitutional AI at Harness Level |
| 2026-04-04 | docs/harness-audit.md | 분기별 하네스 감사 체크리스트 신규 생성 — With/Without 효과 측정 + Stress-test 섹션 포함 | 오토 리서치 v6.0 — Goodhart's Law 방어 |
| 2026-04-04 | edu-harness/SKILL.md | 단계 0.5 feature_list.json 불변성 확인 + _workspace 아티팩트 규칙에 passes:true 표시 의무 추가 | 오토 리서치 v6.0 — 불변성 원칙 강화 |
| 2026-04-04 | verify.sh | TypeScript any/async try-catch 누락/직접변이 패턴 MEDIUM 검사 3종 추가 | 하네스 엔지니어링 고도화 (2026 best practices) |
| 2026-04-04 | system-check.sh | HARNESS_CHANGELOG/AGENTS.md/docs/verification-rubric/git 사용자 검사 추가 | 하네스 엔지니어링 고도화 |
| 2026-04-04 | harness-checkpoint.sh | Level 2 자기복구 — git stash 체크포인트/롤백 스크립트 신규 생성 | 2026 harness self-repair hierarchy |
| 2026-04-04 | harness-evolve.sh | AGENTS.md 변경도 HARNESS_CHANGELOG 자동 추적 | 하네스 엔지니어링 고도화 |
| 2026-04-04 | settings.json | PreCommit 훅 추가 + UserPromptSubmit에 delta/checkpoint 상태 표시 | 하네스 엔지니어링 고도화 |
| 2026-04-04 | CLAUDE.md | 자기 복구 계층(Level 1/2) + harness-checkpoint.sh 가이드 추가 | 하네스 엔지니어링 고도화 분석 |
| 2026-04-04 | measure.sh | 3연속 delta=0 탐지 + 탐색 공간 고착 자동 경고 강화 | objective-loop 고착 방지 |
| 2026-04-04 | harness-init/SKILL.md | 비교육용 범용 harness-init 스킬 신규 생성 | system-check 참조 스킬 실체화 |
| 2026-04-04 | CLAUDE.md | AI 에이전트가 오류를 만났을 때 사용하는 2단 | manual harness-evolve |

---

## 이 파일 사용법

AI가 `/edu-harness` 스킬의 **HARNESS UPDATE** 단계에서 자동으로 기록합니다.
직접 편집하거나 삭제해도 됩니다.

규칙이 쌓일수록 이 파일이 **하네스의 성장 연대기**가 됩니다.
다음 프로젝트 시작 시 이 파일을 보면 어떤 패턴을 반복적으로 발견했는지 알 수 있습니다.
