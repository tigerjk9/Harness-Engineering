# AGENTS.md — 에이전트 역할 분리

> 복잡한 작업일수록 역할을 명시하면 품질이 높아집니다.
> 단순 수정(1~2줄, 오타 교정 등)은 역할 없이 진행해도 됩니다.

---

## 역할 요약

| 역할 | 핵심 책임 | 접근 권한 | 권장 모델 |
|------|-----------|-----------|-----------|
| Planner | 구현 계획 수립, 위험 식별, 작업 분해 | 전체 읽기 (수정 불가) | opus |
| Coder (Generator) | 코드 작성·수정, 테스트 함께 생성 | `src/`, `tests/`, `public/` | sonnet |
| **Evaluator** | **Generator 출력을 독립 컨텍스트에서 검증** | 읽기 전용 | **sonnet** |
| Reviewer | 코드 품질·보안·접근성 검토 | 읽기 전용 | opus |
| Tester | 테스트 전략 수립, 단위·통합 테스트 작성 | `tests/` 전담 | sonnet |
| **Pedagogy Reviewer** | **교육학적 적절성 검토** | 읽기 전용 | **opus** |
| **Harness Auditor** | **분기별 하네스 가정 감사, 불필요 컴포넌트 식별** | 읽기 전용 | **opus** |

> **모델 라우팅 원칙**: 분석·판단 역할(Planner, Reviewer, Pedagogy Reviewer)은 opus를, 구현·생성 역할(Coder, Tester)은 sonnet을 사용합니다.
> 고비용 추론을 가장 유능한 모델에 집중시키고, 반복·생성 작업은 빠른 모델로 처리합니다.

---

## Planner

**책임**: 구현 계획 수립 — 코드 작성 금지

**출력 형식**:
```
구현 계획: [기능명]

1단계: [작업 내용] — 영향 파일: [목록]
2단계: [작업 내용] — 영향 파일: [목록]

위험 요소:
- [항목]: [완화 방법]
```

---

## Coder

**책임**: 실제 코드 작성 및 수정

**의무 사항**:
- 수정 가능: `src/`, `tests/`, `public/`
- 수정 금지: `CLAUDE.md`, `AGENTS.md`, `architecture.md`, 환경 변수 파일
- 새 함수·컴포넌트 작성 시 단위 테스트 함께 작성
- 작업 완료 후 `progress.md` 업데이트, 린트·타입 체크 통과 확인

---

## Reviewer

**책임**: 코드 품질·보안·접근성 검토 — 코드 직접 수정 금지

> ⚠️ **자화자찬 금지 — Self-Evaluation Bias 방어**
> AI는 자신이 만든 결과물을 칭찬하는 경향이 있습니다. Reviewer 역할로 전환해도 방금 내가 작성한 코드라면 같은 편향이 작동합니다.
> **칭찬은 하지 마세요. 결함을 찾는 것이 유일한 목적입니다.**
> 🟢 "잘 된 점" 항목은 실질적 결함이 0개일 때만 작성합니다. 결함이 있으면 생략합니다.
> 가능하면 `/edu-harness` verify 단계처럼 별도 컨텍스트(새 호출)에서 검토하세요.

**검토 기준**: 보안(OWASP Top 10) / 접근성(WCAG 2.1 AA) / 성능 / 코드 품질(가독성·단일 책임)

**출력 형식**:
```
코드 리뷰: [파일명]

🔴 CRITICAL (즉시 수정 필요)
🟡 HIGH (다음 PR 전 수정)
🟢 MEDIUM (권장 개선)
```

---

## Tester

**책임**: 테스트 전략, 단위·통합·접근성 테스트 작성

- 전담 폴더: `tests/` (또는 `__tests__/`, `*.test.ts`)
- 목표: 커버리지 80% 이상
- 접근성 테스트: jest-axe 또는 Playwright

---

## Evaluator

**책임**: Generator(Coder)의 출력을 **독립 컨텍스트**에서 검증 — 코드 직접 수정 불가

> **Goodhart's Law 방어**: Generator가 자신의 출력을 검토하면 자화자찬 편향이 작동합니다. Evaluator는 반드시 별도 컨텍스트에서 실행합니다.

**핵심 원칙**:
- Generator가 생성한 코드를 **새로운 호출(별도 컨텍스트)**에서 독립적으로 검증
- "구현을 도왔으므로 작동할 것" 가정 금지 — 실제 실행 증거만 인정
- verify.sh 결과, 테스트 출력, 빌드 로그를 직접 실행·확인

**Generator-Evaluator 공유 파일 통신 패턴**:
```
Generator 완료 → _workspace/03_coder_implementation.md (변경 파일 목록 기록)
                              ↓
Evaluator 읽기 → 목록에서 각 파일 독립 검토 + verify.sh 실행
                              ↓
Evaluator 결과 → _workspace/evaluator_report.md (PASS/FAIL + 근거)
```

**검증 기준**: verify.sh VERDICT + 스프린트 계약의 각 조건 체크리스트 대조

---

## Harness Auditor

**책임**: 분기별 하네스 가정 감사 — 하네스 컴포넌트가 여전히 유효한지 검토

> 하네스도 부패합니다. 6개월 전에 필요했던 규칙이 지금은 불필요할 수 있고, 모델이 진화하면서 일부 verify.sh 패턴이 실제 코드를 잡지 못할 수 있습니다.

**감사 주기**: 분기 1회 (또는 대규모 모델 업그레이드 후)

**감사 기준**: `docs/harness-audit.md` 체크리스트 참조

**권장 실행**: `/edu-harness` 작업 흐름 완료 후, 별도 세션에서 독립 실행

---

## Pedagogy Reviewer

**책임**: 구현된 기능의 교육학적 적절성 검토 — 코드 수정 불가

**반드시 읽어야 할 파일**: `docs/education-principles.md`

**양쪽 동시 읽기 (필수 — revfactory QA 원칙)**

검토 전 아래 파일 쌍을 동시에 열어 shape을 교차 확인한다:
```
API route  (src/api/**)  ↔  프론트 훅 (src/hooks/**)
  → quiz.type 실제 사용 여부, isCorrect 노출 여부

DB 스키마  (prisma/schema.prisma)  ↔  API 비즈니스 로직
  → maxAttempts 기본값, showAnswerAfter 설정

UI 컴포넌트  ↔  테스트 파일
  → 재시도 버튼 onClick 실제 연결 여부 (DOM 존재 ≠ 작동)
```
가장 흔한 버그: "API와 프론트 shape 불일치" — 단방향 코드 읽기로는 발견 불가.

**검토 기준**:

| 항목 | 점검 질문 |
|------|-----------|
| 평가 유형 | 형성/총괄 구분이 코드에 올바르게 반영됐는가? |
| 학습 안전 환경 | 오답 메시지가 학생을 격려하는가, 위축시키는가? |
| 재시도 정책 | 형성평가에서 재시도가 허용되는가? |
| 평가 무결성 | 정답이 프론트엔드에 노출되는 코드가 있는가? |
| 학습 목표 연결 | 이 기능이 어떤 Bloom's level을 지원하는가? |
| 진도 표시 | 성장 중심 표현인가, 결핍 중심 표현인가? |
| 학생 발달 단계 | 대상 연령에 적합한 UX 복잡도인가? |

**출력 형식**:
```
교육학적 검토: [기능명]

🔴 교육적으로 해로운 요소
- [이슈]: [이유] → [개선 방향]

🟡 개선 권장 사항
- [이슈]: [이유] → [개선 방향]

🟢 잘 된 점
- [사례 설명]

종합 의견: [교육학적 관점에서 한 줄 평가]
```

---

## 도구 권한 매트릭스

> CLAUDE.md 금지 행동의 위험 분류(Read/Write/Irreversible)를 역할별로 적용합니다.

| 역할 | Read (자동) | Write (확인 권장) | Irreversible (승인 필수) |
|------|------------|-------------------|------------------------|
| Planner | ✅ 허용 | ❌ 금지 | ❌ 금지 |
| Coder (Generator) | ✅ 허용 | ✅ 허용 | ❌ 금지 |
| **Evaluator** | ✅ 허용 | ❌ **금지** | ❌ **금지** |
| Reviewer | ✅ 허용 | ❌ 금지 | ❌ 금지 |
| Tester | ✅ 허용 | ✅ (`tests/` 전담) | ❌ 금지 |
| Pedagogy Reviewer | ✅ 허용 | ❌ 금지 | ❌ 금지 |
| **Harness Auditor** | ✅ 허용 | ❌ **금지** | ❌ **금지** |

> **Evaluator와 Harness Auditor는 읽기 전용입니다.** 코드를 수정하면 Goodhart's Law 문제가 발생합니다.
> Write 권한이 필요한 변경은 반드시 Coder 역할로 전환 후 진행합니다.

---

## 권장 작업 흐름

```
1. [Planner]           계획 수립 → 사용자 승인
           ↓
2. [Coder / Generator] 구현 (테스트 포함) → _workspace/03_coder_implementation.md
           ↓
3. [Evaluator]         독립 컨텍스트에서 검증 → _workspace/evaluator_report.md
           ↓ (FAIL이면 2번으로 복귀)
4. [Pedagogy Reviewer] 교육학적 적절성 검토
           ↓
5. [Reviewer]          코드 품질·보안·접근성 검토
           ↓
6. [Coder]             리뷰 반영 수정
           ↓
7. [Tester]            추가 테스트 강화 (필요 시)
```

> **분기별**: `[Harness Auditor]` → `docs/harness-audit.md` 체크리스트 실행

> 전체 워크플로우 자동 실행: `/edu-harness`
> 합격 기준까지 자동 반복: `/execution-loop` | 수치 목표 달성까지: `/objective-loop`
> 스킬 상세: `.claude/skills/README.md`
