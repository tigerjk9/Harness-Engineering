# EduHarness Foundation — PRD (Product Requirements Document)

> 마지막 업데이트: 2026-04-03
> 버전: v4.0 (자동화 메커니즘 5종 완성 + revfactory/harness 비교 개선)

---

## 1. 프로젝트 개요

### 목적

교육자가 Claude Code(또는 Cursor/Windsurf)로 교육용 웹앱을 개발할 때, AI 에이전트가 처음부터 끝까지 일관된 품질로 작업할 수 있도록 돕는 **하네스(Harness) GitHub 템플릿**을 제공한다.

### 대상 사용자

- 코딩 경험이 적은 교육자
- AI 코딩 에이전트를 처음 쓰는 개발자
- 교육용 웹앱을 혼자 또는 소규모 팀으로 개발하는 사람

### 핵심 가치 제안

> "하네스에 축적된 헌법, 작업 구조, 검증 기준은 시간이 흐를수록 고도화되며,
> 개인이 거대 기관을 이길 수 있는 나만의 해자(Moat)가 됩니다."

---

## 2. 정규 레퍼런스 프레임워크

이 프로젝트는 다음 하네스 엔지니어링 원문 프레임워크를 정규(canonical) 기준으로 삼는다.

### 4대 구성 요소

| 구성 요소 | 정의 | EduHarness 구현 |
|---|---|---|
| 📜 **헌법 (Constitution)** | AI가 반드시 따라야 할 규칙과 원칙 | `CLAUDE.md`, `AGENTS.md` |
| 🏗 **작업 구조 (Work Structure)** | 무엇을 어떻게 만들지 정의하는 설계도 | `architecture.md`, `progress.md` |
| ✅ **검증 (Verification)** | 결과물 품질을 판단하는 깐깐한 기준 | `.husky/pre-commit`, 체크리스트 |
| 🔄 **실행 루프 (Execution Loop)** | 수정→검증→반복의 자동화 워크플로우 | `.claude/skills/execution-loop/` |

### 2계층 구조

```
레포지토리 하네스 (Repository Harness) — 회사 취업 규칙
  .claude/ 폴더 전체: 어떤 교육 프로젝트에도 적용 가능한 공통 원칙

  └── 애플리케이션 하네스 (Application Harness) — 팀 업무 매뉴얼
        루트 4개 파일: 이 프로젝트 전용 규칙
```

### 핵심 철학

| 철학 | 정의 | 구현 위치 |
|---|---|---|
| 안묵지→명시지 | 머릿속 "당연한 것"을 AI가 읽을 수 있는 규칙으로 변환 | `docs/customization-guide.ko.md` |
| 위임형 상사 모델 | 목표·기준 제시, 방법은 AI에게 위임 | README, harness-guide, customization-guide |
| 1인 조직화 | 하네스 축적 → 나만의 해자 → 1인이 조직 성과 능가 | README |
| 살아있는 문서 | 하네스는 출발점, 사용하면서 진화 | README |

---

## 3. 전체 파일 목록 및 역할

### 애플리케이션 하네스 (사용자가 채워야 할 파일)

| 파일 | 역할 | 원문 구성 요소 |
|---|---|---|
| `CLAUDE.md` | AI 핵심 규칙서 — 프로젝트 목적·금지 행동·완료 기준 | 헌법 |
| `AGENTS.md` | 에이전트 역할 분리 + 실행 루프 워크플로우 | 헌법 |
| `architecture.md` | 시스템 구조 템플릿 — 기술 스택·데이터 모델 | 작업 구조 |
| `progress.md` | 진행 상태 추적 — Phase·완료·다음 할 일·이슈 | 작업 구조 |

### 레포지토리 하네스 (공통 — 수정 최소화)

| 파일 | 역할 | 원문 구성 요소 |
|---|---|---|
| `.claude/skills/edu-harness/SKILL.md` | **유일한 사용자 진입점** — 계획→교육설계→구현→검증→하네스 진화 전체 오케스트레이션 | 실행 루프 |
| `.claude/skills/execution-loop/SKILL.md` | 수정→검증→반복 루프 (최대 5회, 내부 스킬) | 실행 루프 |
| `.claude/skills/objective-loop/SKILL.md` | 수치 목표 달성 + 하네스 진화 + Goodhart's Law 방어 (내부 스킬) | 실행 루프 |
| `.claude/skills/objective-loop/measure.sh` | baseline/check 모드 점수 측정 및 delta 계산 | 검증 |
| `.claude/skills/verify/SKILL.md` | 6차원 체크리스트 검증 (내부 스킬) | 검증 |
| `.claude/skills/verify/verify.sh` | 코드베이스 점수화 스크립트 — SCORE + VERDICT 출력 | 검증 |
| `.claude/skills/README.md` | 스킬 카탈로그 | 레포 하네스 |
| `.claude/settings.json` | PostToolUse 훅 (progress.md 업데이트 리마인더) | 검증 |
| `.husky/pre-commit` | [UNIVERSAL] ESLint+TypeScript+테스트 / [EDU-DOMAIN] 평가무결성+심리안전 | 검증 |

### 문서

| 파일 | 역할 |
|---|---|
| `docs/example-walkthrough.md` | **⭐ 실전 워크스루** — EduQuiz Mini 가상 프로젝트로 파이프라인 6단계 전체 시연 |
| `docs/customization-guide.ko.md` | 하네스 구축 시작 가이드 — 파이프라인 6단계 + 위임형 상사 모델 |
| `docs/harness-guide.ko.md` | 하네스 상세 사용 가이드 (한국어) — 2계층 구조, 위임형 상사 포함 |
| `docs/harness-guide.en.md` | 하네스 상세 사용 가이드 (영어) |
| `docs/education-principles.md` | 교육학 원칙 레퍼런스 — 형성/총괄, Bloom's, UDL, 심리 안전 |
| `docs/wcag-checklist.md` | WCAG 2.1 AA 체크리스트 |
| `docs/verification-rubric.md` | 6차원 검증 루브릭 상세 + Goodhart's Law 방어 |

---

## 4. 교육 도메인 특수 요구사항

### 형성평가 vs 총괄평가 (가장 중요)

| 항목 | 형성평가 | 총괄평가 |
|---|---|---|
| 목적 | 학습 과정 피드백 | 학습 결과 측정 |
| 재시도 | 무제한 | 불가 |
| 즉각 피드백 | 필수 | 제출 후 일괄 |
| API 정답 노출 | 허용 | **절대 금지** |
| 성적 반영 | 낮은 가중치 | 정식 반영 |

### 평가 무결성

- 총괄평가 API 응답에 `isCorrect` 절대 포함 금지
- 채점은 서버에서만 수행
- 시드 기반 문항 랜덤화 (재현 가능)
- GradeAuditLog — 성적 변경 시 불변 감사 로그

### 학습 안전 환경 (Psychological Safety)

```
❌ 금지: "틀렸습니다.", "오답입니다. 0점."
✅ 권장: "아직 아니에요. 다시 생각해볼까요?", "이번엔 맞지 않았어요. 힌트를 볼까요?"
```

### 미성년자 데이터 보호

- 만 14세 미만: 보호자 동의 플로우 필수
- 최소 수집 원칙
- 학습 목적 외 데이터 활용 금지

---

## 5. 개발 이력

### v1.0 (2026-03-28) — 초기 구축

**구현 내용:**
- CLAUDE.md (교육 도메인 규칙 포함)
- AGENTS.md (Planner/Coder/Reviewer/Tester/Pedagogy Reviewer)
- architecture.md (교육 도메인 엔티티 포함)
- progress.md
- 스킬 3개: edu-component, accessibility, progress-update
- 스킬 2개 추가: assessment-design, learning-flow
- docs: education-principles.md, harness-guide.ko/en.md, wcag-checklist.md
- .husky/pre-commit, .claude/settings.json
- README.md, README.en.md

**프레임워크:** 4대 기둥 (Context/Constraint/Verification/Feedback)

---

### v2.0 (2026-03-29) — 원문 프레임워크 정렬

**배경:** 사용자가 하네스 엔지니어링 원문을 제공하여 프레임워크 불일치 발견

**갭 분석 결과:**

| 원문 개념 | v1.0 | v2.0 |
|---|---|---|
| 실행 루프 | ❌ 없음 | ✅ `.claude/skills/execution-loop/SKILL.md` |
| 2계층 구조 | ❌ 혼재 | ✅ 전체 문서에 반영 |
| 1인 조직화 철학 | ❌ 없음 | ✅ README.md / README.en.md |
| 위임형 상사 모델 | ❌ 없음 | ✅ README, customization-guide, harness-guide |
| 안묵지→명시지 프로세스 | 🟡 [괄호] 뿐 | ✅ `docs/customization-guide.ko.md` 5단계 |
| 원문 4대 구성 요소 용어 | ❌ 우리 용어만 | ✅ 원문 용어 + 기술 기둥 매핑 테이블 |

**신규 파일:**
- `docs/customization-guide.ko.md` — 하네스 구축 시작 가이드
- `.claude/skills/execution-loop/SKILL.md` — 실행 루프 스킬

**수정 파일:**
- README.md, README.en.md — 원문 철학 + 2계층 구조 + 4대 구성 요소 반영
- AGENTS.md — 실행 루프 섹션 + 종료 조건 추가
- docs/harness-guide.ko.md — 2계층 구조, 위임형 상사 모델 추가
- CLAUDE.md — 계층 안내 주석 추가

---

### v3.0 (2026-03-29) — 5-스킬 재편 + 실행 가능 스크립트

**배경:** 8개 스킬이 사용자 인지 부하로 작용. "텍스트만 있는 하네스" 약점 발견.

**핵심 변경:**

| 항목 | 이전 (v2.0) | 이후 (v3.0) |
|---|---|---|
| 스킬 수 | 8개 (모두 동등) | 5개 (2 진입점 + 3 내부) |
| 실행 방식 | 텍스트 지침만 | bash 스크립트 (verify.sh, measure.sh) |
| 점수 측정 | 수동 | `measure.sh baseline/check` 자동 |
| 학습 자료 | 없음 | example-walkthrough.md (SCORE 20→95 시연) |
| 범용 분리 | 없음 | [UNIVERSAL] / [EDU-DOMAIN] 태그 |

**신규 파일 (5개):**
- `.claude/skills/edu-harness/SKILL.md` — 유일한 사용자 진입점
- `.claude/skills/verify/verify.sh` — 결정론적 점수화 스크립트
- `.claude/skills/objective-loop/measure.sh` — delta 측정 스크립트
- `.claude/skills/README.md` — 스킬 카탈로그
- `docs/example-walkthrough.md` — EduQuiz Mini 실전 워크스루

**삭제 (5개):** assessment-design, learning-flow, edu-component, accessibility, progress-update (내용은 edu-harness/SKILL.md에 흡수)

**수정 (6개):** verify/SKILL.md, objective-loop/SKILL.md, CLAUDE.md, .husky/pre-commit, README.md, AGENTS.md

---

### v4.0 (2026-04-03) — 자동화 메커니즘 5종 완성 + 비교 우위 확보

**배경:** revfactory/harness 벤치마크 비교 분석 → 성능·사용성 양면 개선 랄프 루프 실행

**벤치마크 결과:**

| 차원 | revfactory/harness | EduHarness v3.x | EduHarness v4.0 |
|------|:-----------------:|:--------------:|:--------------:|
| 성능 | 65/100 | 72/100 | **85/100** |
| 직관적 사용성 | 78/100 | 74/100 | **85/100** |

**자동화 메커니즘 5종 완성:**

| 파일 | 변경 | 효과 |
|------|------|------|
| `verify.sh v2.1` | 파일 목록 1회 수집 + `--full` 모드 추가 | ~40% 속도 향상, lint/tsc/test 통합 |
| `pre-commit` | 6→9 체크 (verify --full, 파일 크기, harness-evolve) | CONDITIONAL 커밋 허용, REJECTED 차단 |
| `settings.json` | PostToolUse VERDICT 실시간 표시 | Write/Edit마다 `SCORE=N VERDICT=X` 즉시 확인 |
| `.claude/hooks/system-check.sh` | 신규 — 11개 항목 환경 진단 | 세션 시작 시 자동 실행 |
| `.claude/hooks/harness-evolve.sh` | 신규 — CLAUDE.md staged 시 CHANGELOG 자동 기록 | 하네스 자기진화 이력 자동 추적 |

**UX 개선:**

- `edu-harness-init` 재설계: 10질문 → **2질문 + package.json 자동 감지 + lazy-fill**
- `/harness` 스텁 삭제 → `/edu-harness` 단일 진입점으로 통일
- `harness-init` → `edu-harness-init` 이름 통일
- README "바로 써보기" 6개 copy-paste 예시 추가
- AGENTS.md 모델 라우팅 컬럼 추가 (opus/sonnet 역할 분리)

---

### v3.1 (2026-03-29) — MD 파일 구조화 + GitHub 배포

**배경:** 헌법 파일(CLAUDE.md, AGENTS.md)이 AI가 매 작업마다 읽기에 불필요한 노이즈 포함. README.md도 철학적 서술 비중 과다.

**핵심 변경:**

| 파일 | 이전 | 이후 | 감소 |
|------|------|------|------|
| `CLAUDE.md` | 201줄 | 129줄 | -36% |
| `AGENTS.md` | 279줄 | 130줄 | -53% |
| `README.md` | 233줄 | 123줄 | -47% |

**제거 항목 (AI 성능에 영향 없음):**
- CLAUDE.md: 코딩 규칙 코드 예시 블록, 교육 규칙 서술 단락
- AGENTS.md: 역할별 활성화 예시 코드블록, 실행 루프·Objective Loop 설명 (SKILL.md와 완전 중복)
- README.md: 철학적 서술 단락, 중복 예시

**유지 항목:** 모든 실질 규칙, 출력 형식, 제약사항, 워크플로우 다이어그램

**추가:**
- `.gitignore`: `.bkit/`, `docs/.pdca-status.json`, `docs/.pdca-snapshots/`, `.claude/settings.local.json` 제외 (플러그인 자동 생성 파일)
- GitHub 배포: `tigerjk9/Harness-Engineering` 커밋+푸쉬 완료

---

## 6. 기술적 결정 사항

| 날짜 | 결정 | 이유 |
|---|---|---|
| 2026-03-28 | GitHub Template Repository 방식 선택 | 원문에서 명시적으로 GitHub 권장; "Use this template" 버튼으로 쉬운 복사 |
| 2026-03-28 | 교육 도메인 특수 규칙을 CLAUDE.md에 직접 포함 | AI 에이전트가 자동 로드하므로 별도 참조 불필요 |
| 2026-03-28 | Bloom's taxonomy + UDL + GradeAuditLog + QuestionVersion 포함 | 교육 웹앱과 일반 웹앱의 핵심 차별점 |
| 2026-03-29 | 원문 4대 구성 요소를 정규 프레임워크로 채택 | 사용자 제공 원문이 canonical; 기술 기둥은 구현 관점으로 병기 |
| 2026-03-29 | 실행 루프 최대 5회 제한 | 무한 루프 방지, 5회 후 사용자 판단 개입 |
| 2026-03-29 | 8스킬 → 5스킬 재편 | 사용자는 2개만 기억; 나머지는 내부 오케스트레이션 |
| 2026-03-29 | verify.sh + measure.sh bash 스크립트 | AI 해석 비결정론 제거 — 같은 코드 = 같은 점수 |
| 2026-03-29 | objective-loop = 탐색 문제 + Goodhart's Law 방어 | rubric이 목표가 되는 순간의 퇴화 방지; rubric 변경은 사람 승인 필수 |
| 2026-03-29 | 헌법 파일 경량화 — 코드 예시·서술 단락 제거 | AI가 매 작업마다 읽는 파일은 규칙만; 예시는 교육 효과 없이 컨텍스트만 소비 |
| 2026-03-29 | AGENTS.md에서 스킬 중복 섹션 제거 | 실행 루프·Objective Loop 설명은 SKILL.md가 단일 진실 소스; AGENTS.md는 역할 정의만 담당 |
| 2026-04-03 | verify.sh quick/full 2-mode 분리 | settings.json hook은 quick(빠름)으로, pre-commit + /edu-harness는 full(정확)으로 — 속도와 정확성 모두 확보 |
| 2026-04-03 | harness-init 10질문 → 2질문 + lazy-fill | 프론트-로딩 안티패턴 제거; 기술 스택·사용자 설명은 첫 /edu-harness 실행 시 자동 추론 |
| 2026-04-03 | /harness 스텁 삭제, /edu-harness 단일 진입점 | 명명 혼동 제거; edu- 접두사로 교육 도메인 특화 명확화 |
| 2026-04-03 | system-check.sh 환경 진단 도구 추가 | 세션 시작 전 런타임·하네스 파일·npm 스크립트 11개 항목 자동 검증 |

---

## 7. 미완료 / 다음 단계

### 즉시 필요

- [x] GitHub 원격 리포지토리 생성 (`tigerjk9/Harness-Engineering`)
- [x] Template Repository 설정 완료 (2026-04-03)
- [x] 커밋 + 푸쉬 완료

### 추후 고려

- [ ] docs/customization-guide.en.md (영어 버전)
- [ ] WCAG 2.2 업데이트 (WCAG 2.1 → 2.2, 9개 신규 기준)
- [ ] UDL 3.0 업데이트 (정체성·소속감 원칙)
- [ ] .github/workflows/ci.yml (GitHub Actions CI/CD)
- [ ] .github/ISSUE_TEMPLATE/ (이슈 템플릿)
- [ ] LICENSE 파일 추가 (MIT)
- [ ] CONTRIBUTING.md 추가
- [ ] package.json + lint-staged 설정
- [x] verify.sh에 파일 크기(>800줄) 검사 추가 — MEDIUM Dim 1b로 구현 완료
- [ ] example-walkthrough.en.md (영어 버전)

---

## 8. 검증 기준

이 템플릿이 성공적인지 판단하는 기준:

1. clone 후 5분 이내에 애플리케이션 하네스 구축 가능
2. AI 에이전트가 형성평가에 재시도 금지 로직을 적용하지 않음
3. 총괄평가 API 응답에 정답이 포함되지 않음
4. 실행 루프가 5회 이내에 합격 기준 충족
5. 처음 사용자가 README만 읽고 시작 가능
