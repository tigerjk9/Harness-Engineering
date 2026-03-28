---
name: verify
description: 구현된 기능을 6개 차원(기술/평가 무결성/심리 안전/접근성/데이터 보호/성능)에서 체계적으로 검증합니다. docs/verification-rubric.md 기준을 따릅니다.
---

# verify 스킬

모든 검증 판단 기준은 `docs/verification-rubric.md`를 따릅니다.
이 스킬은 6개 차원을 순서대로 검증하고, 심각도별 통과/실패를 보고합니다.

## 사용 방법

```
/verify [기능명 또는 파일명]을 검증해줘.
예: /verify 퀴즈 응시 기능을 검증해줘.
예: /verify src/app/quiz/[id]/page.tsx를 검증해줘.
```

---

## 검증 실행 순서

### 사전 작업

1. 검증 대상 파일 목록 확인
2. 관련 API 라우트 파일 확인
3. 관련 DB 스키마 확인
4. 관련 UI 컴포넌트 확인

---

### 차원 1 — 기술 검증

```bash
# 린트
npm run lint 2>&1 | tail -5

# 타입 체크
npx tsc --noEmit 2>&1 | tail -10

# 테스트
npm test -- --passWithNoTests 2>&1 | tail -10
```

코드 리뷰 추가 확인:
- 변경된 함수/컴포넌트에 테스트 파일 존재?
- 파일 800줄 이하?
- console.log 없음?

---

### 차원 2 — 평가 무결성 (교육 핵심)

**이 차원은 교육 앱에서 가장 중요합니다. 한 항목이라도 CRITICAL 실패 시 전체 REJECTED.**

```bash
# CRITICAL: isCorrect API 노출 검사
grep -rn "isCorrect.*:.*true\|\"isCorrect\"" src/ --include="*.ts" --include="*.tsx" \
  | grep -v "\.test\." | grep -v "__tests__" | grep -v "node_modules"

# CRITICAL: correctAnswerId API 노출 검사
grep -rn "correctAnswerId\|correctAnswer" src/ --include="*.ts" --include="*.tsx" \
  | grep -v "\.test\." | grep -v "__tests__" | grep -v "node_modules"
```

코드 리뷰 확인:
- `quiz.type` 필드가 `"FORMATIVE"` 또는 `"SUMMATIVE"`로 명시됨?
- 형성평가: `maxAttempts: null`, `showAnswerAfter: "IMMEDIATELY"` 확인
- 총괄평가: `maxAttempts: 1`, `showAnswerAfter: "NEVER"` 또는 `"ON_SUBMIT"` 확인
- 재시도 버튼이 형성평가 UI에 존재?
- 시드 기반 랜덤화 (`shuffleWithSeed(array, studentId + quizId)`) 구현?
- 성적 변경 함수에 `GradeAuditLog.create()` 호출?

---

### 차원 3 — 심리 안전

```bash
# 부정적 피드백 메시지 검사
grep -rn "틀렸습니다\|오답입니다\|실패했습니다\|Wrong answer\|Incorrect answer" \
  src/ --include="*.ts" --include="*.tsx" \
  | grep -v "\.test\." | grep -v "__tests__"

# 결핍 중심 진도 메시지 검사
grep -rn "개 남았습니다\|remaining\|not completed" \
  src/ --include="*.ts" --include="*.tsx" \
  | grep -v "\.test\."
```

UI 확인 (스크린샷 또는 코드 검토):
- 진도 메시지가 완료 수 기준? ("3개 완료!" ✅ vs "7개 남았습니다" ❌)
- 재시도 횟수 카운터 미표시 (형성평가)?
- 오답 피드백이 힌트/격려 포함?

---

### 차원 4 — 접근성 (WCAG 2.1 AA)

```bash
# alt 없는 img 검사
grep -rn "<img" src/ --include="*.tsx" | grep -v "alt="

# aria-label 없는 아이콘 버튼 (경고 수준)
grep -rn "<button" src/ --include="*.tsx" | grep -v "aria-label\|aria-labelledby\|>[^<]"
```

코드 리뷰 확인:
- 모든 `<img>` → `alt` 존재?
- 아이콘 전용 버튼 → `aria-label` 존재?
- 모든 폼 입력 → `<label htmlFor>` 연결?
- `:focus-visible` 스타일 있음?
- 색상만으로 정보 전달 안 함? (오류/성공에 아이콘+텍스트 병행)

---

### 차원 5 — 데이터 보호

```bash
# 하드코딩 비밀 검사 (CRITICAL)
grep -rEn "(apiKey|api_key|password|secret|token)\s*=\s*['\"][^'\"\$\{]{8,}" \
  src/ --include="*.ts" --include="*.tsx" \
  | grep -v "\.test\." | grep -v "example\|placeholder\|sample"

# 학생 데이터 외부 전송 패턴 (주의)
grep -rn "axios.post\|fetch.*student\|sendData" src/ --include="*.ts" \
  | grep -v "\.test\." | grep -v "api/\|/api"
```

코드/스키마 확인:
- 회원가입 플로우에 만 14세 미만 분기 (birthYear 필드 + 동의 플로우)?
- DB 스키마에 불필요한 개인정보 필드 없음?
- catch 블록 오류 메시지에 민감 정보 포함 안 함?

---

### 차원 6 — 성능

```bash
# 번들 크기 확인 (Next.js)
ls -lh .next/static/chunks/*.js 2>/dev/null | sort -k5 -h | tail -5

# 최적화 안 된 이미지 직접 참조 (CDN 미사용)
grep -rn "src=\"/images\|src=\"./images" src/ --include="*.tsx" | grep -v "cdn\|cloudfront\|vercel"
```

Lighthouse 또는 개발자 도구:
- LCP ≤ 2.5초?
- 모바일 반응형 768px, 480px 확인?

---

## 검증 보고서 출력

모든 차원 완료 후 다음 형식으로 보고:

```
검증 결과: [기능명]
날짜: [오늘 날짜]

차원 1. 기술 검증       [✅ PASS / ❌ FAIL / ⚠️ WARN]
차원 2. 평가 무결성     [✅ PASS / ❌ FAIL / ⚠️ WARN]
차원 3. 심리 안전       [✅ PASS / ❌ FAIL / ⚠️ WARN]
차원 4. 접근성          [✅ PASS / ❌ FAIL / ⚠️ WARN]
차원 5. 데이터 보호     [✅ PASS / ❌ FAIL / ⚠️ WARN]
차원 6. 성능            [✅ PASS / ❌ FAIL / ⚠️ WARN]

최종: [APPROVED / CONDITIONAL / REJECTED]

🔴 즉시 수정 필요 (CRITICAL):
  [항목 없으면 "없음"]

🟡 HIGH 미통과:
  [항목 목록 또는 "없음"]

기술 부채 등록 권장 (MEDIUM 미통과):
  [항목 목록 또는 "없음"]
```

---

## 자동 실행 (스크립트)

```bash
# 전체 코드베이스를 한 번에 점수화
bash .claude/skills/verify/verify.sh

# 출력 예
# CRITICAL_FAIL=0 HIGH=3/3 MEDIUM=1/2 SCORE=82 VERDICT=CONDITIONAL
```

| VERDICT | 의미 |
|---------|------|
| APPROVED | 모든 기준 충족 — 합격 |
| CONDITIONAL | MEDIUM 미통과 — 기술 부채 등록 후 진행 가능 |
| REJECTED | CRITICAL 또는 HIGH 미통과 — 즉시 수정 필요 |

---

## 상세 루브릭 참조

각 항목의 전체 목록과 측정 방법은 `docs/verification-rubric.md`를 참조하세요.
