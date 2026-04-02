# 차원 1-2: 기술 검증 + 평가 무결성

## 양쪽 동시 읽기 원칙 (필수 — revfactory QA 패턴)

가장 흔한 버그는 "API route와 프론트 훅의 shape 불일치"다.
단방향 grep으로는 잡히지 않는 버그를 이 방식으로 잡는다.

```
동시에 열어야 할 파일 쌍:
  API route  →  src/api/**/*.ts       (응답 타입 확인)
  프론트 훅  →  src/hooks/**/*.ts     (제네릭 타입 확인)
  DB 스키마  →  prisma/schema.prisma  (quiz.type, maxAttempts 확인)

교차 확인 체크리스트:
  □ API 응답 타입에 isCorrect / correctAnswerId 포함 여부
  □ quiz.type enum이 API·프론트·DB 3곳에서 동일한지
  □ maxAttempts 기본값이 형성(null) / 총괄(1) 올바른지
  □ 성적 변경 함수에 GradeAuditLog.create() 호출 존재 여부
```

---

## 차원 1 — 기술 검증 (MEDIUM)

```bash
# 린트
npm run lint 2>&1 | tail -5

# 타입 체크
npx tsc --noEmit 2>&1 | tail -10

# 테스트
npm test -- --passWithNoTests 2>&1 | tail -10
```

체크리스트:
- [ ] 변경 함수/컴포넌트에 테스트 파일 존재
- [ ] 파일 800줄 이하
- [ ] console.log 없음
- [ ] TypeScript any 없음

---

## 차원 2 — 평가 무결성 (CRITICAL)

```bash
# CRITICAL: 정답 데이터 프론트 노출 검사
grep -rn "isCorrect.*:.*true\|\"isCorrect\".*true\|correctAnswerId" \
  src/ --include="*.ts" --include="*.tsx" | grep -v "\.test\.\|__tests__"

# 평가 유형 구분 검사
grep -rn "quiz\.type\|quizType\|FORMATIVE\|SUMMATIVE" \
  src/ --include="*.ts" --include="*.tsx" | grep -v "\.test\."

# 재시도 횟수 설정 검사
grep -rn "maxAttempts\s*[:=]" src/ --include="*.ts" | grep -v "\.test\."

# 성적 감사 로그 검사
grep -rn "GradeAuditLog\|gradeAuditLog" src/ --include="*.ts" | grep -v "\.test\."
```

구조 체크리스트:
- [ ] isCorrect / correctAnswerId API 응답에 없음
- [ ] quiz.type: "FORMATIVE" | "SUMMATIVE" 필드 존재
- [ ] 형성평가: maxAttempts null, showAnswerAfter "IMMEDIATELY"
- [ ] 총괄평가: maxAttempts 1, showAnswerAfter "NEVER" 또는 "ON_SUBMIT"
- [ ] 성적 변경 함수에 GradeAuditLog.create() 호출
- [ ] 시드 기반 문항 랜덤화 구현 (shuffleWithSeed 또는 동등)
- [ ] 재시도 버튼 형성평가 UI에 존재
