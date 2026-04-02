---
name: edu-harness-init
description: 새 프로젝트 시작 시 하네스를 초기화합니다. 2가지 질문만 하고, 나머지는 package.json 자동 감지 + 지연 채움으로 처리합니다. clone 직후 가장 먼저 실행하세요.
---

# /edu-harness-init

> 새 프로젝트 시작 시 **가장 먼저** 실행하는 스킬입니다.
> 질문 2개만 합니다. 나머지는 자동으로 처리됩니다.

## 사용 방법

```
/edu-harness-init
```

---

## 실행 순서

### 1단계 — 필수 질문 (2개만)

```
Q1. 프로젝트 이름은? (예: EduQuiz Mini, LearnTrack Pro)
Q2. 교육 앱인가요? (Y/N)
    Y → CLAUDE.md 교육 도메인 섹션 유지
    N → CLAUDE.md에서 교육 도메인 섹션 전체 제거
```

이것으로 질문은 끝입니다. 기술 스택, 명령어, 배포 환경은 아래 단계에서 자동 처리합니다.

---

### 2단계 — package.json 자동 감지

`package.json`이 존재하면 scripts를 읽어 명령어를 자동으로 채웁니다.

```
감지 항목:
  scripts.dev      → [YOUR_DEV_COMMAND]     대체
  scripts.start    → dev가 없으면 fallback
  scripts.test     → [YOUR_TEST_COMMAND]    대체
  scripts.lint     → [YOUR_LINT_COMMAND]    대체
  scripts.typecheck 또는 scripts.type-check → [YOUR_TYPECHECK_COMMAND] 대체
  scripts.build    → [YOUR_BUILD_COMMAND]   대체

tsconfig.json 존재 여부 → TypeScript 프로젝트 여부 자동 감지
```

`package.json`이 없으면 해당 항목은 `# TODO: 프로젝트 설정 후 채워주세요` 주석으로 남깁니다. 커밋을 막지 않습니다.

---

### 3단계 — 지연 채움 (Lazy fill)

기술 스택, 핵심 기능, 대상 사용자는 **첫 `/edu-harness` 실행 시 자동 추론**합니다.

예시:
```
/edu-harness 초등학생용 객관식 퀴즈 기능을 만들어줘
→ 대상 사용자: "초등학생" 자동 감지
→ 핵심 기능: "객관식 퀴즈" 자동 감지
→ CLAUDE.md 해당 항목 자동 업데이트
```

지연 채움 대상 항목에는 임시로 이 주석을 답니다:
```
# lazy-fill: /edu-harness 첫 실행 시 자동 추론
```

---

### 4단계 — CLAUDE.md 업데이트

수집/감지된 정보로 플레이스홀더를 교체합니다:

| 플레이스홀더 | 처리 방식 |
|---|---|
| `[YOUR_PROJECT_NAME]` | Q1 답변 |
| 교육 도메인 섹션 전체 | Q2가 N이면 삭제 |
| `[YOUR_DEV_COMMAND]` | package.json 자동 감지 |
| `[YOUR_TEST_COMMAND]` | package.json 자동 감지 |
| `[YOUR_LINT_COMMAND]` | package.json 자동 감지 |
| `[YOUR_TYPECHECK_COMMAND]` | package.json 자동 감지 |
| `[YOUR_BUILD_COMMAND]` | package.json 자동 감지 |
| 대상 사용자, 핵심 기능 | 지연 채움 (lazy-fill 주석) |
| 배포 환경 | 지연 채움 (lazy-fill 주석) |

---

### 5단계 — architecture.md 업데이트

프로젝트명과 자동 감지된 기술 스택으로 채웁니다.
나머지(`[YOUR_DATABASE]` 등)는 lazy-fill 주석으로 남깁니다.

---

### 6단계 — HARNESS_CHANGELOG.md 초기화

```
| 날짜 | 파일 | 변경 내용 | 맥락 |
|------|------|-----------|------|
| [오늘 날짜] | CLAUDE.md | 초기 하네스 설정 완료 | /edu-harness-init 실행 |
```

---

### 7단계 — 완료 보고

```
✅ edu-harness-init 완료

질문: 2개
자동 감지: [감지된 항목 수]개 (package.json)
지연 채움 예정: [남은 항목 수]개 → 첫 /edu-harness 실행 시 자동 추론

채워진 항목:
- CLAUDE.md — 프로젝트명, 명령어 [N]개 교체
- architecture.md — 프로젝트명 교체
- HARNESS_CHANGELOG.md — 초기화 완료

지연 채움 예정 (lazy-fill):
- 대상 사용자, 핵심 기능, 배포 환경

다음 단계:
1. git add CLAUDE.md architecture.md HARNESS_CHANGELOG.md
2. git commit -m "harness: [프로젝트명] 초기 하네스 설정"
3. /edu-harness [첫 번째 기능]을 만들어줘.
```

---

## system-check 경고 해소

`/edu-harness-init` 완료 후 `bash .claude/hooks/system-check.sh`를 실행하면
`CLAUDE.md 플레이스홀더` 경고가 사라진 것을 확인할 수 있습니다.
lazy-fill 주석은 경고를 발생시키지 않습니다 (`[대괄호]` 패턴이 아니므로).
