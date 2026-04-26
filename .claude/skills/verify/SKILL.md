---
name: verify
description: >
  기능 구현이 완료되거나 '/verify 기능명'이 입력되면 반드시 이 스킬을 사용할 것.
  'verify', 'check', 'validate', 'run verification', 'is this passing?', 'check quality'가 포함된 요청도 해당.
  6개 차원(기술/평가무결성/심리안전/접근성/데이터보호/성능)에서 교육 앱 코드를 검증한다.
  isCorrect API 노출, 형성/총괄 혼용, 부정적 피드백 메시지 감지에 특화.
---

# verify 스킬

```
/verify [기능명]을 검증해줘.
```

---

## 실행 순서

### Step 0.5 — 헌법적 자기비판 (구현 직후 실행)

> Constitutional AI at Harness Level: 구현 완료 직후, verify.sh 실행 전에 CLAUDE.md 원칙 목록을 대조해 자가 점검합니다.

**자기비판 체크리스트** (모두 통과해야 Step 1 진행):

```
□ 불변성: 객체·배열 직접 수정(push/splice/sort) 없음
□ TypeScript any: `: any` 또는 `as any` 사용 없음
□ try-catch 완비: async 함수마다 try-catch 존재
□ 파일 800줄 이하: 변경한 모든 파일이 800줄 미만
□ 직접 변이 없음: 원본 객체/배열 mutate 없이 spread로 새 객체 생성
```

체크리스트 항목 1개라도 실패 시 → 코드 수정 후 Step 0.5 재실행 (Step 1 진행 불가)

### Step 0 — 양쪽 동시 읽기 (필수)

API route 파일과 프론트 훅 파일을 **동시에** 열어 shape 교차 확인.
→ 상세 패턴: `.claude/skills/verify/references/integrity.md`

### Step 1 — 스크립트 실행

```bash
bash .claude/skills/verify/verify.sh
```

SCORE·VERDICT 확인. REJECTED이면 Step 2로 원인 파악.

### Step 2 — 차원별 상세 검사

| 차원 | 참조 파일 |
|------|-----------|
| 1 기술 · 2 평가무결성 | `.claude/skills/verify/references/integrity.md` |
| 3 심리안전 · 4 접근성 | `.claude/skills/verify/references/safety.md` |
| 5 데이터보호 · 6 성능 | `.claude/skills/verify/references/protection.md` |

### Step 3 — 검증 보고서

```
검증 결과: [기능명]

차원 1. 기술       [✅/❌/⚠️]
차원 2. 평가무결성 [✅/❌/⚠️]  ← CRITICAL
차원 3. 심리안전   [✅/❌/⚠️]
차원 4. 접근성     [✅/❌/⚠️]
차원 5. 데이터보호 [✅/❌/⚠️]  ← CRITICAL
차원 6. 성능       [✅/❌/⚠️]

최종: APPROVED / CONDITIONAL / REJECTED

🔴 CRITICAL: [없음 / 항목]
🟡 HIGH:     [없음 / 항목]
기술 부채:   [없음 / 항목]
```

| VERDICT | 다음 행동 |
|---------|-----------|
| APPROVED | 완료 |
| CONDITIONAL | 기술 부채 등록 후 진행 가능 |
| REJECTED | `/execution-loop` 수정 루프 진입 |
