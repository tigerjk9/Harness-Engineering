---
name: harness
description: 범용 하네스 워크플로우. 한 명령으로 계획→구현→검증→하네스 진화 전체 사이클 실행. 교육 도메인이 아닌 모든 프로젝트에 사용.
---

# harness 스킬

> "한 번의 명령으로 전체 워크플로우를."

단일 진입점. 내부적으로 Planner → Coder → verify → execution-loop → harness 업데이트를 오케스트레이션합니다.

교육 앱이라면 → `/edu-harness`을 사용하세요.

---

## 단계 0 — SYSTEM CHECK (자동, 매 실행 시)

```bash
bash .claude/hooks/system-check.sh
```

FAIL 항목이 있으면 해결 후 진행. WARN 항목은 계속 가능.
system-check.sh는 Node/npm, tsconfig.json, lint/test 스크립트, git hooks 등
verify --full이 올바르게 작동하는 데 필요한 환경을 사전 검증합니다.

---

## 사용 방법

```
/harness [기능 설명]

예:
/harness 사용자 로그인 기능을 만들어줘.
/harness 파일 업로드 API를 만들어줘.
/harness 대시보드 페이지를 만들어줘.
```

이전 방식 (deprecated):
```
[harness 스킬 사용] 사용자 로그인 기능을 만들어줘.
```

현재 방식:
```
/harness 사용자 로그인 기능을 만들어줘.
```

---

## 실행 흐름

```
/harness 기능 설명
         │
┌────────▼────────┐
│   1. PLAN       │  [Planner] 계획 수립
│                 │  3단계 이상이면 사용자 승인 필수
└────────┬────────┘
         │ 승인
┌────────▼────────┐
│   2. BUILD      │  [Coder] 구현 + 단위 테스트
└────────┬────────┘
         │
┌────────▼────────┐
│   3. VERIFY     │  bash .claude/skills/verify/verify.sh
│                 │  → SCORE + VERDICT 확인
└────────┬────────┘
         │
    ┌────▼────┐
    │APPROVED?│
    └──┬──┬───┘
       │  │ REJECTED/CONDITIONAL
       │  └──────────────────────┐
       │               ┌─────────▼───────┐
       │               │   4. FIX LOOP   │  /execution-loop 또는
       │               │                 │  /objective-loop
       │               └─────────┬───────┘
       │                         │ 합격
       └─────────────────────────┘
                       │
              ┌────────▼────────┐
              │  5. HARNESS     │  패턴 발견 → CLAUDE.md 반영
              │     UPDATE      │  git commit "harness-evolve: ..."
              └────────┬────────┘
                       │
              ┌────────▼────────┐
              │  6. DONE        │  progress.md 업데이트
              └─────────────────┘
```

---

## 단계 1 — PLAN

```
[Planner] [기능명]을 구현하기 위한 계획을 세워줘.
progress.md와 architecture.md를 먼저 읽어 기존 구조에 맞게 계획해줘.
3단계 이상이면 내 승인을 먼저 받아줘.
```

Planner 출력물:
- 영향받는 파일 목록
- 단계별 작업 내용
- 위험 요소 및 완화 방법

---

## 단계 1.5 — SPRINT CONTRACT (사용자 승인 필수)

> Anthropic 연구: 단일 에이전트($9)와 하네스($200)의 결정적 차이는 "완료의 의미를 사전에 합의했는가"였다.

PLAN 승인 직후, BUILD 시작 전에 반드시 실행:

```
이번 스프린트의 합격 기준을 명시해줘.

출력 형식:
스프린트 계약: [기능명]

완료 조건 (이것들이 모두 작동해야 "완료"):
- [ ] [구체적이고 테스트 가능한 조건 1]
- [ ] [구체적이고 테스트 가능한 조건 2]
- [ ] [구체적이고 테스트 가능한 조건 3]

비완료 조건 (이번 스프린트 범위 밖):
- [다음 스프린트로 미루는 항목]

Evaluator(verify 단계)는 위 조건만으로 채점합니다.
```

사용자가 이 계약을 승인한 후에만 BUILD 진행.

**왜 필요한가?** "완료"가 모호하면 AI는 작동하지 않는 기능도 완료로 선언한다.
계약이 명확할수록 verify 단계에서 실제 실패를 잡아낼 수 있다.

---

## 단계 2 — BUILD

```
[Coder] Planner의 계획에 따라 [기능명]을 구현해줘.
CLAUDE.md의 모든 규칙을 준수하고,
새 함수·컴포넌트마다 단위 테스트를 함께 작성해줘.
```

Coder 의무사항:
- `src/` 폴더 내 구현
- TypeScript 필수, `any` 금지
- 새 코드마다 `.test.ts` 생성
- console.log 없음

---

## 단계 3 — VERIFY

```bash
bash .claude/skills/verify/verify.sh

# 출력 예시
CRITICAL_FAIL=0 HIGH=3/3 MEDIUM=1/2 SCORE=82 VERDICT=CONDITIONAL
```

| VERDICT | 다음 행동 |
|---------|-----------|
| APPROVED | 단계 5로 바로 이동 |
| CONDITIONAL | 기술 부채 기록 후 단계 5 가능 |
| REJECTED | 단계 4 (FIX LOOP) 진입 |

---

## 단계 4 — FIX LOOP (REJECTED 시만)

```
/execution-loop verify 실패 항목을 수정해줘.
APPROVED 또는 CONDITIONAL이 될 때까지 반복해줘.
```

수치 목표가 있다면:
```
/objective-loop verify SCORE를 현재 [N] → 80 이상으로 올려줘.
```

---

## 단계 5 — HARNESS UPDATE (자동 실행 필수)

**이 단계를 건너뛰면 하네스가 진화하지 않습니다.**
기능 완료 후 반드시 아래 순서로 즉시 실행합니다.

### 패턴 발견 → CLAUDE.md 즉시 수정

이번 작업에서 반복된 문제나 효과적인 패턴이 있으면:

1. **CLAUDE.md를 직접 편집**해서 규칙 추가 (사용자 승인 불필요)
   ```
   # 추가 위치: CLAUDE.md > 코딩 규칙 > 해당 섹션
   - [발견된 규칙을 명확한 지시문으로]
   ```

2. **HARNESS_CHANGELOG.md에 기록**
   ```bash
   # 파일이 없으면 생성, 있으면 맨 위 테이블에 행 추가
   echo "| $(date +%Y-%m-%d) | CLAUDE.md | [추가된 규칙 한 줄] | [발견 맥락] |" >> HARNESS_CHANGELOG.md
   ```

3. **git commit**
   ```bash
   git add CLAUDE.md HARNESS_CHANGELOG.md progress.md
   git commit -m "harness-evolve: [발견한 규칙 한 줄 요약]"
   ```

> **원칙:** 코드 변경 = AI 자율 결정. rubric(verify.sh) 변경 = 사람 승인.
> CLAUDE.md 규칙 추가는 AI가 자율 결정합니다.

---

## 단계 6 — DONE

progress.md 업데이트 후 완료 선언.

---

## 규모별 가이드

```
1~2줄 수정, 오타 교정     → harness 스킬 불필요. 바로 수정.
단일 컴포넌트 / 단일 API  → /harness 직접 호출
3개 이상 파일 연동 기능   → Planner 승인 필수
수치 목표 달성 필요       → /objective-loop 병행
```

---

## 내부 스킬

| 스킬 | 단독 호출 |
|------|-----------|
| execution-loop | `/execution-loop ...` |
| verify | `bash .claude/skills/verify/verify.sh` |
| objective-loop | `/objective-loop ...` |
