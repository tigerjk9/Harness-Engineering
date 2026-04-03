# decision-log.md — 아키텍처 결정 기록 (ADR)

> **목적**: 프로젝트의 중요한 기술적·설계적 결정을 구조화된 형식으로 기록합니다.
> 결정의 맥락, 이유, 대안, 결과를 남겨 미래의 팀원(또는 AI 에이전트)이 "왜 이렇게 됐는가"를 이해할 수 있도록 합니다.
>
> **작성 시점**: 아키텍처 변경, 기술 스택 선택, 중요한 트레이드오프 결정 시
> **progress.md 연결**: `decisions_taken` 앵커 필드에 이 파일의 ADR ID를 참조하세요

---

## ADR 작성 형식

```markdown
## ADR-NNN: [결정 제목]

**날짜**: YYYY-MM-DD
**상태**: ACTIVE | SUPERSEDED(ADR-XXX) | DEPRECATED

### 맥락 (Context)
[이 결정이 필요했던 배경과 문제 상황]

### 결정 (Decision)
[우리가 선택한 것]

### 고려한 대안 (Alternatives Considered)
- **대안 A**: [설명] — 선택 안 한 이유: [이유]
- **대안 B**: [설명] — 선택 안 한 이유: [이유]

### 결과 (Consequences)
- **긍정적**: [이 결정으로 얻는 것]
- **부정적**: [이 결정으로 감수하는 것]
- **중립**: [변화는 있지만 좋고 나쁨 없는 것]
```

---

## Status 정의

| Status | 의미 |
|--------|------|
| **ACTIVE** | 현재 유효한 결정. 코드베이스에 반영됨 |
| **SUPERSEDED(ADR-XXX)** | ADR-XXX로 대체됨. 더 이상 유효하지 않음 |
| **DEPRECATED** | 더 이상 유효하지 않으나 대체 ADR 없이 폐기됨 |

---

## 실제 예시 ADR

## ADR-001: 하네스 설계 — verify.sh REJECTED를 src/ 없는 템플릿의 정상 상태로 정의

**날짜**: 2026-04-04
**상태**: ACTIVE

### 맥락 (Context)
EduHarness는 GitHub Template Repository로 배포됩니다. 새로 clone한 사용자는 `src/` 디렉토리가 없는 상태에서 시작합니다. verify.sh는 `src/` 없으면 Dim 2 (isCorrect 노출 검사)가 H_TOTAL++만 하고 H_PASS를 올리지 않아 HIGH < 100% → VERDICT=REJECTED가 됩니다.

### 결정 (Decision)
VERDICT=REJECTED를 "미구현 템플릿 프로젝트의 정상 상태"로 정의합니다. verify.sh를 수정해서 src/ 없을 때 APPROVED를 반환하도록 만들지 않습니다.

### 고려한 대안 (Alternatives Considered)
- **대안 A**: src/ 없으면 APPROVED 반환 — 선택 안 한 이유: 실제로 구현이 없는데 합격을 주면 하네스가 무의미해짐
- **대안 B**: src/ 없으면 SKIPPED 판정 추가 — 선택 안 한 이유: 새 VERDICT 추가는 settings.json, docs 등 여러 파일 변경 필요. 복잡성 증가 대비 이점 적음

### 결과 (Consequences)
- **긍정적**: "왜 REJECTED인가?"라는 질문이 생기면 항상 "미구현 때문"이라는 명확한 답이 있음
- **부정적**: 새 사용자가 처음 verify.sh 실행 시 REJECTED를 보고 당황할 수 있음
- **중립**: docs/example-walkthrough.md에서 이 동작을 설명함

---

## ADR-002: 하네스 설계 — CLAUDE.md를 AI 자율 수정 가능, verify.sh는 사용자 승인 필수

**날짜**: 2026-04-04
**상태**: ACTIVE

### 맥락 (Context)
AI가 코딩 작업 중 새 패턴을 발견했을 때 하네스를 즉시 업데이트하고 싶습니다. 그러나 verify.sh 채점 기준을 AI가 자율 변경하면 "목표를 달성하기 위해 채점 기준을 낮추는" Goodhart's Law 문제가 발생합니다.

### 결정 (Decision)
CLAUDE.md(규칙 문서)는 AI 자율 수정 허용. verify.sh(채점 기준)은 사용자 승인 필수.

### 고려한 대안 (Alternatives Considered)
- **대안 A**: 둘 다 AI 자율 수정 — 선택 안 한 이유: Goodhart's Law — AI가 점수를 올리기 위해 기준을 낮출 위험
- **대안 B**: 둘 다 사용자 승인 — 선택 안 한 이유: CLAUDE.md 규칙 발견이 즉각 반영되지 않으면 하네스 진화가 느려짐

### 결과 (Consequences)
- **긍정적**: 채점 기준의 무결성 유지. CLAUDE.md는 빠르게 진화
- **부정적**: verify.sh 업데이트 시 마찰 발생 (의도적 마찰)
- **중립**: harness-evolve.sh가 이 구분을 자동으로 강제함

---

## ADR 추가 방법

새 결정이 생기면:
```
1. ADR-NNN 번호 할당 (이전 번호 + 1)
2. 위 형식으로 이 파일에 추가
3. progress.md 컨텍스트 앵커의 decisions_taken 필드 업데이트
4. git commit -m "docs: ADR-NNN [결정 제목 한 줄 요약]"
```
