---
name: quickstart
description: >
  EduHarness 첫 실행 진입점. "quickstart", "시작", "처음 시작", "어떻게 시작", "setup", "init",
  "get started", "how do I start", "처음 써요", "clone 했어", "방금 받았어"가 포함된 요청에서
  반드시 이 스킬을 사용합니다. 환경 점검 → CLAUDE.md 초기화 → 첫 검증까지 one-shot으로 처리합니다.
  다른 스킬을 먼저 고를 필요 없습니다. 항상 여기서 시작하세요.
---

# /quickstart

> EduHarness 하나뿐인 시작점.
> 복잡한 스킬 선택 불필요 — 이 스킬이 알아서 분기합니다.

---

## Step 1 — 환경 점검

```bash
bash .claude/hooks/system-check.sh --brief
```

- Node v18+, npm, git, bash 확인
- 경고가 있으면 사용자에게 보여주고 계속 진행 (중단하지 않음)
- 오류(Node 없음 등)만 중단

---

## Step 2 — 프로젝트 상태 감지

`package.json`과 `src/` 존재 여부로 자동 분기합니다.

| 상태 | 분기 |
|------|------|
| `package.json` 없음 + `src/` 없음 | → **신규 템플릿** (Step 3으로) |
| `package.json` 있음 또는 `src/` 있음 | → **기존 프로젝트** (Step 6으로) |

---

## Step 3 — 2개 질문 (신규 템플릿만)

```
Q1. 프로젝트 이름은? (예: EduQuiz Mini, LearnTrack Pro)
    What's your project name? (e.g. EduQuiz Mini, LearnTrack Pro)

Q2. 교육 앱인가요? Y/N
    Is this an education app? Y/N
    Y → CLAUDE.md 교육 도메인 섹션 유지
    N → CLAUDE.md에서 교육 도메인 섹션 전체 제거
```

질문은 이것으로 끝입니다. 기술 스택, 명령어, 배포 환경은 아래에서 자동 처리합니다.

---

## Step 4 — CLAUDE.md 자동 채움 (신규 템플릿만)

답변과 파일 감지 결과로 플레이스홀더를 교체합니다.

| 플레이스홀더 | 처리 방식 |
|---|---|
| `[YOUR_PROJECT_NAME]` | Q1 답변 |
| `[YOUR_DEV_COMMAND]` | `package.json` scripts.dev 감지, 없으면 lazy-fill |
| `[YOUR_TEST_COMMAND]` | `package.json` scripts.test 감지 |
| `[YOUR_LINT_COMMAND]` | `package.json` scripts.lint 감지 |
| `[YOUR_TYPECHECK_COMMAND]` | `package.json` scripts.typecheck 감지 |
| `[YOUR_BUILD_COMMAND]` | `package.json` scripts.build 감지 |
| 교육 도메인 섹션 | Q2=N이면 전체 제거 |
| 대상 사용자, 핵심 기능, 배포 환경 | `# lazy-fill` 주석으로 표시 (커밋 허용) |

`architecture.md`도 프로젝트명과 감지된 스택으로 업데이트합니다.

---

## Step 5 — Next.js 프로젝트 안내 (package.json 없을 때만)

`package.json`이 없으면 사용자에게 안내합니다:

```
📦 아직 Next.js 프로젝트가 없습니다.
다음 명령어로 생성하세요:

  npx create-next-app@latest . --typescript --tailwind --app

생성 후 다시 /quickstart를 실행하거나, 바로 /edu-harness로 기능 개발을 시작하세요.
```

안내만 하고 직접 실행하지 않습니다 (사용자 선택권 보장).

---

## Step 6 — 첫 검증

```bash
bash .claude/skills/verify/verify.sh
```

결과를 그대로 출력합니다.

---

## Step 7 — 결과 보고

VERDICT에 따라 다른 안내를 합니다.

### SETUP_REQUIRED
```
✅ 하네스 초기화 완료!

채워진 항목: [N]개
지연 채움 예정: [N]개 (첫 /edu-harness 실행 시 자동 추론)

다음 단계:
1. Next.js 프로젝트 생성 (위 Step 5 참고)
2. git commit -m "harness: [프로젝트명] 초기 하네스 설정"
3. /edu-harness [만들 기능]을 만들어줘
```

### APPROVED / CONDITIONAL
```
✅ 하네스 준비 완료! VERDICT=[결과]

바로 개발을 시작할 수 있습니다:
→ /edu-harness [만들 기능]을 만들어줘
```

### REJECTED
```
⚠️ 검증 실패 항목이 있습니다. VERDICT=REJECTED

실패 항목:
[CRITICAL_FAIL, HIGH 미통과 항목 나열]

먼저 이 항목을 수정하거나, /edu-harness로 기능 개발을 진행하면서 함께 수정할 수 있습니다.
```

---

## 참고

- 더 세밀한 초기화가 필요하면: `/edu-harness-init`
- 기능 개발 시작: `/edu-harness [기능명]을 만들어줘`
- 검증만 다시 실행: `bash .claude/skills/verify/verify.sh`
- 전체 상태 확인: `bash .claude/hooks/harness-health.sh`
