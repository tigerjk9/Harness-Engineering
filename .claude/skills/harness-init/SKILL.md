---
name: harness-init
description: 새 프로젝트에서 하네스를 초기화합니다. 교육 앱이면 edu-harness-init을 사용하세요. 비교육 앱용 범용 초기화 스킬입니다.
---

# /harness-init

> 새 프로젝트 시작 시 **가장 먼저** 실행하는 스킬입니다.  
> 교육 앱이면 `/edu-harness-init`을 사용하세요.

## 사용 방법

```
/harness-init
```

---

## 실행 순서

### 1단계 — 필수 질문 (2개만)

```
Q1. 프로젝트 이름은? (예: TaskManager, APIGateway, DataPipeline)
Q2. 교육 앱인가요?
    Y → /edu-harness-init 실행 (교육 도메인 규칙 포함)
    N → 아래 단계 진행 (범용 하네스)
```

이것으로 질문은 끝입니다.

---

### 2단계 — CLAUDE.md 교육 섹션 제거

Q2가 N이면 CLAUDE.md에서 다음 섹션을 제거합니다:
- `## 교육 도메인 특수 규칙` 전체
- 교육 관련 `docs/` 참조 항목

---

### 3단계 — package.json 자동 감지

`package.json`이 존재하면 scripts를 읽어 CLAUDE.md 명령어 자동 채움:

| 플레이스홀더 | 소스 |
|---|---|
| `[YOUR_DEV_COMMAND]` | scripts.dev 또는 scripts.start |
| `[YOUR_TEST_COMMAND]` | scripts.test |
| `[YOUR_LINT_COMMAND]` | scripts.lint |
| `[YOUR_TYPECHECK_COMMAND]` | scripts.typecheck |
| `[YOUR_BUILD_COMMAND]` | scripts.build |

---

### 4단계 — CLAUDE.md 프로젝트명 업데이트

`[YOUR_PROJECT_NAME]` → Q1 답변으로 교체

---

### 5단계 — HARNESS_CHANGELOG.md 초기화

```markdown
| 날짜 | 파일 | 변경 내용 | 맥락 |
|------|------|-----------|------|
| [오늘 날짜] | CLAUDE.md | 초기 하네스 설정 완료 | /harness-init 실행 |
```

---

### 6단계 — harness-health.sh 첫 실행 (환경 검증)

```bash
bash .claude/hooks/harness-health.sh
```

하네스 전체 상태 대시보드를 확인합니다. VERDICT=REJECTED는 `src/` 없는 템플릿의 정상 상태입니다 (ADR-001 참조).

---

### 7단계 — 완료 보고

```
✅ harness-init 완료

프로젝트: [프로젝트명]
타입: 범용 (비교육)
자동 감지: [N]개 명령어
하네스 상태: bash .claude/hooks/harness-health.sh 결과 확인

다음 단계:
1. git add CLAUDE.md HARNESS_CHANGELOG.md
2. git commit -m "harness: [프로젝트명] 초기 하네스 설정"
3. /harness [첫 번째 기능]을 만들어줘.
```

---

## verify.sh 커스터마이징 안내

교육 앱이 아니라면 `verify.sh`의 EDU-DOMAIN 검사는 자동으로 통과됩니다  
(관련 파일이 없으면 grep 결과 없음 → 자동 통과).

별도 커스터마이징 불필요합니다.

---

## 참고

| 파일 | 용도 |
|------|------|
| `CLAUDE.md` | 하네스 헌법 |
| `AGENTS.md` | 에이전트 역할 분리 |
| `docs/verification-rubric.md` | 검증 루브릭 |
| `docs/decision-log.md` | 아키텍처 결정 기록 (ADR) |
| `docs/harness-audit.md` | 분기별 하네스 감사 |
| `.claude/skills/README.md` | 스킬 카탈로그 |
| `.claude/hooks/harness-health.sh` | 전체 상태 대시보드 |
| `.claude/hooks/harness-checkpoint.sh` | Level 2 자기 복구 |
