# harness-audit.md — 분기별 하네스 감사 체크리스트

> 담당: **Harness Auditor** (AGENTS.md 참조)
> 실행 주기: 분기 1회 또는 대규모 모델 업그레이드 후
> 목적: 하네스 컴포넌트가 여전히 유효한지 검증 — 불필요해진 규칙 식별, 누락된 패턴 발견

---

## 1. 핵심 질문: "현재 모델이 하네스 없이도 할 수 있는가?"

각 하네스 컴포넌트에 대해 아래 테스트를 실행합니다.

| 컴포넌트 | 하네스 없이 테스트 | 통과 기준 | 결론 |
|----------|-------------------|-----------|------|
| TypeScript `any` 금지 (verify.sh Dim7) | `any` 없이 코드 작성 요청 | 자발적으로 `any` 미사용 | ✅ 유지 / ❌ 불필요 |
| async try-catch 검사 (verify.sh Dim8) | async 함수 작성 요청 | 자발적으로 try-catch 추가 | ✅ 유지 / ❌ 불필요 |
| 불변성 패턴 검사 (verify.sh Dim9) | 배열 조작 코드 요청 | spread 연산자 자발 사용 | ✅ 유지 / ❌ 불필요 |
| Context Anxiety 방어 (CLAUDE.md) | 컨텍스트 70%에서 중단 테스트 | 자발적으로 progress.md 업데이트 | ✅ 유지 / ❌ 불필요 |
| 단일 기능 세션 경계 (CLAUDE.md) | 여러 기능 동시 요청 | 스스로 단일 기능으로 범위 제한 | ✅ 유지 / ❌ 불필요 |
| 앵커 작성 의무 (CLAUDE.md) | 세션 전환 시나리오 | 자발적으로 앵커 업데이트 | ✅ 유지 / ❌ 불필요 |

**결론 기준**:
- ✅ 유지: 모델이 하네스 없이도 잘 하는 경우 → 하네스는 보험 (유지)
- ❌ 불필요: 규칙이 없어도 모델이 완벽히 따르는 경우 → 하네스 제거 고려 (단, 신중히)
- ⚠️ 강화 필요: 하네스가 있어도 모델이 따르지 않는 경우 → 규칙 강화 또는 자동화 필요

---

## 2. Stress-test: verify.sh grep 패턴 유효성 확인

verify.sh의 각 grep 패턴이 현재 모델 코드 스타일을 실제로 탐지하는지 확인합니다.

```bash
# 테스트용 위반 코드 임시 생성 후 verify.sh 실행
echo "const x: any = 5" > /tmp/test_any.ts
bash .claude/skills/verify/verify.sh /tmp
# → MEDIUM 점수가 낮아져야 함 (any 탐지 성공 확인)
rm /tmp/test_any.ts

# 불변성 위반 테스트
echo "arr.push(1)" > /tmp/test_mutate.ts
bash .claude/skills/verify/verify.sh /tmp
# → MEDIUM 점수가 낮아져야 함 (mutate 탐지 성공 확인)
rm /tmp/test_mutate.ts
```

**패턴 강도 평가**:
- False Negative (탐지 실패): 위반이 있는데 점수가 안 낮아짐 → 패턴 강화 필요
- False Positive (오탐): 정상 코드인데 점수가 낮아짐 → 패턴 정밀화 필요
- 정상: 위반 시 점수 감소, 수정 후 점수 복구

---

## 3. With/Without 효과 측정

하네스가 실제로 코드 품질에 기여하는지 측정합니다.

```bash
# 방법: measure.sh baseline → 구현 → check → delta 기록

# Step 1: 하네스 있는 상태에서 기능 구현 후 점수 기록
bash .claude/skills/verify/verify.sh
# SCORE=N1 기록

# Step 2: 같은 기능을 CLAUDE.md 규칙 주석 처리 후 구현
# (주의: 실제 코드베이스에서 하지 말 것 — 별도 브랜치 사용)
git checkout -b harness-audit-test
# CLAUDE.md 규칙 섹션 임시 제거 후 재구현
bash .claude/skills/verify/verify.sh
# SCORE=N2 기록

# Step 3: delta = N1 - N2
# delta > 0: 하네스가 품질 향상에 기여
# delta = 0: 하네스 불필요 (모델이 이미 규칙을 따름)
# delta < 0: 하네스가 오히려 방해 (규칙 재검토 필요)

git checkout main
git branch -d harness-audit-test
```

**기록 형식** (docs/harness-audit-results.md에 추가):
```
| 날짜 | 테스트 기능 | 하네스 있음(N1) | 하네스 없음(N2) | delta | 결론 |
|------|------------|----------------|----------------|-------|------|
| YYYY-MM-DD | [기능명] | [N1] | [N2] | [N1-N2] | 유지/약화/강화 |
```

---

## 4. 감사 보고서 형식

감사 완료 후 HARNESS_CHANGELOG.md에 기록:

```
| YYYY-MM-DD | harness-audit.md | 분기 감사 완료 — [제거 N개 / 유지 M개 / 강화 K개] | 분기별 하네스 감사 |
```

---

## 5. 담당자 및 주기

| 항목 | 내용 |
|------|------|
| **담당** | Harness Auditor (AGENTS.md 참조) |
| **주기** | 분기 1회 (1월 / 4월 / 7월 / 10월 첫째 주) |
| **소요 시간** | 약 30~60분 (세션 1회 분량) |
| **트리거** | 대규모 모델 업그레이드 후에도 즉시 실행 |
| **출력** | HARNESS_CHANGELOG.md 기록 + docs/harness-audit-results.md 업데이트 |

---

## 6. 감사 결과 액션

| 결론 | 액션 |
|------|------|
| 하네스 컴포넌트 불필요 확인 | CLAUDE.md 또는 verify.sh에서 해당 규칙 제거 + HARNESS_CHANGELOG 기록 |
| 패턴 강화 필요 | verify.sh grep 패턴 업데이트 (사용자 승인 후) |
| 새 패턴 발견 | harness-evolve.sh 실행하여 CLAUDE.md에 추가 |
| 모든 컴포넌트 유효 | 현 상태 유지 기록 |
