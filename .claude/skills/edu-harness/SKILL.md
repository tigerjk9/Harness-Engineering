---
name: edu-harness
description: 교육 앱 전용 하네스 워크플로우. harness 스킬을 확장해 Pedagogy Reviewer, 평가 무결성, 심리 안전, UDL 학습 설계를 추가합니다.
---

# edu-harness 스킬

> 교육 앱이라면 `/harness` 대신 이 스킬을 사용하세요.

`/harness` 스킬의 완전한 상위 호환입니다.
교육 도메인 전용 단계 3개를 추가로 실행합니다.

---

## 단계 0 — SYSTEM CHECK (자동, 매 실행 시)

```bash
bash .claude/hooks/system-check.sh
```

FAIL 항목이 있으면 해결 후 진행. WARN 항목은 계속 가능.
edu-harness는 verify --full (lint+tsc+test+grep)을 실행하므로
Node, tsconfig.json, lint/test 스크립트가 올바르게 설정돼 있어야 합니다.

---

## 사용 방법

```
/edu-harness [기능 설명]

예:
/edu-harness 학생 퀴즈 응시 기능을 만들어줘. 형성평가로 설계해줘.
/edu-harness 레슨 목록 페이지를 만들어줘.
/edu-harness 교사 성적 관리 화면을 만들어줘.
```

---

## 실행 흐름

```
/edu-harness [기능 설명]
         │
┌────────▼────────┐
│   1. PLAN       │  [Planner] — harness와 동일
│                 │  + 평가 유형(형성/총괄) 결정 포함
└────────┬────────┘
         │ 승인
┌────────▼────────┐
│   2. EDU DESIGN │  교육 도메인 설계 체크 ← 신규
│                 │  평가 유형 / UDL / 스캐폴딩 결정
└────────┬────────┘
         │
┌────────▼────────┐
│   3. BUILD      │  [Coder] — harness와 동일
│                 │  + 교육 규칙(CLAUDE.md 규칙 1-5) 준수
└────────┬────────┘
         │
┌────────▼────────┐
│   4. PEDAGOGY   │  [Pedagogy Reviewer] ← 신규
│     REVIEW      │  교육학적 적절성 검토
└────────┬────────┘
         │
┌────────▼────────┐
│   5. VERIFY     │  /verify (+ verify.sh)
│                 │  교육 차원(Dim 2, 3) 포함 검증
└────────┬────────┘
         │
    ┌────▼────┐
    │APPROVED?│
    └──┬──┬───┘
       │  │ REJECTED
       │  └─► FIX LOOP (/execution-loop / /objective-loop)
       │
┌──────▼──────────┐
│  6. HARNESS     │  교육 규칙도 하네스에 반영 (자동 실행)
│     UPDATE      │
└──────┬──────────┘
       │
┌──────▼──────────┐
│  7. DONE        │  progress.md 업데이트
└─────────────────┘
```

---

## 단계 1 — PLAN

progress.md, architecture.md, docs/education-principles.md를 먼저 읽은 후 계획을 세운다.
평가 관련 기능이면 형성/총괄 유형을 계획에 명시한다. 3단계 이상이면 사용자 승인 필수.

상세 기준: 이 파일 하단 [단계 1 참조] 섹션

---

## 단계 1.5 — SPRINT CONTRACT (사용자 승인 필수)

> Anthropic 연구: $9 단일 에이전트 vs $200 하네스의 차이는 "완료의 의미를 사전에 합의했는가"였다.

PLAN 승인 직후, EDU DESIGN 시작 전에 실행:

```
이번 스프린트의 합격 기준을 명시해줘.

스프린트 계약: [기능명]

완료 조건:
- [ ] [교육 기능 조건 — 예: 형성평가 재시도 버튼이 오답 시 즉시 표시됨]
- [ ] [기술 조건 — 예: isCorrect가 API 응답에 노출되지 않음]
- [ ] [접근성 조건 — 예: fieldset+legend로 문항 그룹화]

Pedagogy Reviewer는 완료 조건 기준으로만 채점합니다.
verify.sh는 위 조건을 grep으로 검증합니다.
```

사용자 승인 후 단계 2로 진행.

---

## 단계 2 — EDU DESIGN

평가 요소가 있으면 유형(FORMATIVE/SUMMATIVE)을 결정하고 설정값을 확정한다.
학습 흐름(Bloom's, UDL, 스캐폴딩)과 피드백 메시지 초안을 검토한다.

상세 기준: 이 파일 하단 [단계 2 참조] 섹션

---

## 단계 3 — BUILD

CLAUDE.md 규칙 1-5를 준수해 구현한다.
단위 테스트와 jest-axe 접근성 테스트를 함께 작성한다.

상세 기준: 이 파일 하단 [단계 3 참조] 섹션

---

## 단계 4 — PEDAGOGY REVIEW

[Pedagogy Reviewer] 역할로 교육학적 관점에서 검토한다.
코드 수정 없이 검토 리스트만 작성한다. 🔴 항목이 있으면 단계 3으로 복귀.

상세 기준: 이 파일 하단 [단계 4 참조] 섹션

---

## 단계 5 — VERIFY

```bash
bash .claude/skills/verify/verify.sh
```

/verify 스킬 또는 verify.sh로 검증한다. VERDICT=APPROVED이면 다음 단계 진행.
REJECTED이면 `/execution-loop` 또는 `/objective-loop`으로 재시도.

상세 기준: 이 파일 하단 [단계 5 참조] 섹션

---

## 단계 6 — HARNESS UPDATE (자동 실행 필수)

**이 단계를 건너뛰면 하네스가 진화하지 않습니다.**

### 즉시 실행 (사용자 승인 불필요)

Pedagogy Reviewer나 구현 중 발견한 교육 패턴이 있으면:

1. **CLAUDE.md를 직접 편집** — 교육 도메인 섹션의 해당 규칙에 추가
2. **HARNESS_CHANGELOG.md에 기록**
   ```
   | YYYY-MM-DD | CLAUDE.md | [추가 규칙] | edu-harness 결과: [기능명] |
   ```
3. **git commit** `harness-evolve: [교육 규칙 요약]`

### rubric 변경이 필요하다면 (사람 승인 필요)

verify.sh 항목 추가/수정은 반드시 사용자에게 제안 → 승인 후 반영.

---

## 내부 스킬

| 스킬 | 역할 |
|------|------|
| `/execution-loop` | 합격까지 반복 |
| `/verify` (+ verify.sh) | 수치 검증 |
| `/objective-loop` (+ measure.sh) | 수치 목표 달성 |

---

---

## 참조 — 단계 1 상세 기준

```
[Planner] [기능명]을 구현하기 위한 계획을 세워줘.
progress.md, architecture.md, docs/education-principles.md를 먼저 읽어줘.

이 기능이 평가 관련이라면:
- 형성평가(FORMATIVE)인지 총괄평가(SUMMATIVE)인지 먼저 결정해줘.
- 그에 맞는 설계 원칙을 계획에 반영해줘.
3단계 이상이면 내 승인을 먼저 받아줘.
```

---

## 참조 — 단계 2 상세 기준

### 평가 유형 체크

```
이 기능에 평가 요소가 있는가?
├── 없음 → 단계 3으로 바로 이동
└── 있음 → 평가 유형 결정 필수

  형성평가 (FORMATIVE) 설정:
    maxAttempts: null       (무제한 재시도)
    showAnswerAfter: "IMMEDIATELY"
    timeLimit: null
    → 재시도 버튼 UI 필수

  총괄평가 (SUMMATIVE) 설정:
    maxAttempts: 1
    showAnswerAfter: "NEVER" 또는 "ON_SUBMIT"
    → API 응답에 isCorrect, correctAnswerId 절대 불포함
    → 채점은 서버에서만 수행
```

### 학습 흐름 체크 (레슨/컨텐츠 기능인 경우)

```
Bloom's Taxonomy 수준은?
  REMEMBER / UNDERSTAND / APPLY / ANALYZE / EVALUATE / CREATE

UDL 다양한 표현 방식 제공?
  텍스트 + 시각(이미지/영상) 중 최소 2가지

스캐폴딩 수준 설계?
  학생 성적에 따라 지원 수준 자동 조정 고려
```

### 피드백 메시지 사전 검토

```
❌ 사용 금지           ✅ 권장 표현
"틀렸습니다"    →    "아직 아니에요. 다시 생각해볼까요?"
"오답입니다"    →    "이번엔 맞지 않았어요. 힌트를 볼까요?"
"실패했습니다"  →    "다시 도전해봐요!"
"N개 남았습니다" →  "벌써 N개 완료했어요!"
```

### 컴포넌트 접근성 요구사항

```
QuizCard 유형:
  <fieldset> + <legend>로 문제 그룹화
  각 선택지: <input type="radio"> + <label>
  피드백: aria-live="polite" 영역

ProgressBar:
  role="progressbar" + aria-valuenow/min/max
  시각적 막대 + 텍스트 레이블 병기

LessonList:
  <nav> + <ol> (순서 있는 목록)
  현재 항목: aria-current="page"
```

---

## 참조 — 단계 3 상세 기준

```
[Coder] Planner의 계획에 따라 [기능명]을 구현해줘.
CLAUDE.md의 모든 규칙을 준수하되, 특히:
- 규칙 1: 형성/총괄평가 구분 ([형성/총괄] 타입 명시)
- 규칙 2: 학습 안전 환경 (부정적 메시지 금지)
- 규칙 3: 평가 무결성 (isCorrect API 응답에 절대 불포함)
- 규칙 4: 교육 콘텐츠 버저닝
- 규칙 5: 미성년자 데이터 규정

성적 변경 함수가 있다면 GradeAuditLog.create() 반드시 포함.
단위 테스트와 jest-axe 접근성 테스트를 함께 작성해줘.
```

### 평가 무결성 체크리스트 (CRITICAL — 위반 시 커밋 차단)

```
□ API 응답에 isCorrect 없음
□ API 응답에 correctAnswerId 없음
□ 채점 로직이 서버(API route)에만 존재
□ 총괄평가 maxAttempts === 1
□ 시드 기반 문항 랜덤화 구현
□ 성적 변경 시 GradeAuditLog.create() 호출
```

### 심리 안전 체크리스트

```
□ "틀렸습니다" 문자열 없음
□ "오답입니다" 문자열 없음
□ 진도 표시가 성장 중심 ("N개 완료!" vs "N개 남음")
□ 형성평가 재시도 버튼 항상 표시
□ 오답 피드백에 힌트 또는 격려 포함
```

### UDL 접근성 체크리스트

```
□ 퀴즈 컴포넌트: fieldset + legend 구조
□ 피드백: aria-live="polite" 영역 사용
□ 진도바: role="progressbar" + aria-valuenow
□ 색상 + 아이콘 + 텍스트 동시 표현 (색상만으로 정보 전달 금지)
□ 키보드로 모든 기능 이용 가능
```

---

## 참조 — 단계 4 상세 기준

```
[Pedagogy Reviewer] 방금 구현한 [기능명]을 교육학적 관점에서 검토해줘.
docs/education-principles.md를 기준으로:

1. 평가 유형이 코드에 올바르게 반영됐는가?
2. 오답/오류 메시지가 학생을 격려하는가, 위축시키는가?
3. 형성평가에서 재시도가 허용되는가?
4. 정답이 프론트엔드에 노출될 수 있는 코드가 있는가?
5. 진도 표시가 성장 중심 표현인가?

코드는 수정하지 말고 검토 리스트만 작성해줘.
```

**Pedagogy Reviewer 출력 형식:**

```
교육학적 검토: [기능명]

🔴 교육적으로 해로운 요소 (즉시 수정)
🟡 개선 권장 사항
🟢 잘 된 점

종합 의견: [한 줄 평가]
```

---

## 참조 — 단계 5 상세 기준

```bash
bash .claude/skills/verify/verify.sh

# 출력 예시
CRITICAL_FAIL=0 HIGH=3/3 MEDIUM=2/2 SCORE=100 VERDICT=APPROVED
```

교육 특화 추가 점검:

```bash
# 평가 무결성: API 응답에 isCorrect 포함 여부
grep -rn "isCorrect\|correctAnswerId" src/ --include="*.ts" \
  | grep -v "\.test\.\|__tests__"

# 심리 안전: 부정적 메시지 잔류 여부
grep -rn "틀렸습니다\|오답입니다\|Wrong answer" src/ --include="*.tsx" \
  | grep -v "\.test\."
```
