---
name: edu-harness
description: '만들어줘', '구현해줘', '추가해줘', '설계해줘'가 포함된 모든 교육 앱 기능 요청에 반드시 이 스킬을 사용할 것. 퀴즈, 레슨, 학습 진도, 교사 관리, 평가, 피드백, 학생 인증 기능 모두 해당. 계획→교육설계→구현→교육학검토→검증→하네스진화 전체 사이클을 실행한다.
---

# edu-harness 스킬

> 이 레포지토리의 **기본 진입점**입니다. 모든 기능 구현에 이 스킬을 사용하세요.

```
/edu-harness [기능 설명]

예:
/edu-harness 학생 퀴즈 응시 기능을 만들어줘. 형성평가로 설계해줘.
/edu-harness 레슨 목록 페이지를 만들어줘.
/edu-harness 교사 성적 관리 화면을 만들어줘.
```

---

## 트리거 기준

**이 스킬을 써야 할 때:**
- "퀴즈 기능 만들어줘", "학생 로그인 구현해줘"
- "교사 성적 관리 화면 추가해줘", "레슨 목록 페이지 만들어줘"
- 교육 앱의 모든 신규 기능·컴포넌트·API 구현 요청

**이 스킬을 쓰면 안 될 때:**
- "이 코드 설명해줘" → 설명만 요청
- "오타 수정해줘", "색상 바꿔줘" → 1-2줄 수정
- "verify 점수 올려줘" → `/objective-loop` 사용
- "이 기능 고쳐줘 (이미 구현됨)" → `/execution-loop` 사용

---

## _workspace/ 아티팩트 규칙

각 단계 출력 파일(`_workspace/0N_*.md`)은 단계 7 완료까지 삭제하지 않습니다.
이전 단계 아티팩트는 다음 단계에서 참조 가능해야 하며, 새 세션에서 재개 시 상태 복원 근거가 됩니다.

---

## 단계 0 — SYSTEM CHECK (자동, 매 실행 시)

```bash
bash .claude/hooks/system-check.sh
```

FAIL 항목이 있으면 해결 후 진행.

---

## 단계 1 — PLAN

progress.md, architecture.md, docs/education-principles.md를 먼저 읽고 계획 수립.
3단계 이상이면 사용자 승인 필수.

출력 저장: `_workspace/01_planner_plan.md`

---

## 단계 1.5 — SPRINT CONTRACT (사용자 승인 필수)

> Anthropic $9 vs $200 연구의 핵심 교훈: "완료의 의미를 사전에 합의했는가"

PLAN 승인 직후 EDU DESIGN 전에 실행. 상세 가이드: `.claude/skills/edu-harness/references/sprint.md`

```
스프린트 계약: [기능명]

완료 조건:
- [ ] [교육 기능 조건]
- [ ] [기술 조건]
- [ ] [접근성 조건]

비완료 조건: [다음 스프린트로 미루는 항목]
```

출력 저장: `_workspace/01_planner_sprint_contract.md`

---

## 단계 2 — EDU DESIGN

평가 유형 결정(FORMATIVE/SUMMATIVE), 학습 흐름, 피드백 메시지 초안 확정.
상세 기준: `.claude/skills/edu-harness/references/edu-design.md`

출력 저장: `_workspace/02_edu_design.md`

---

## 단계 3 — BUILD

CLAUDE.md 규칙 1-5 준수. 단위 테스트 + jest-axe 접근성 테스트 함께 작성.

**평가 무결성 필수 체크 (구현 중):**
```
□ API 응답에 isCorrect 없음
□ 채점 로직 서버에만 존재
□ quiz.type: "FORMATIVE" | "SUMMATIVE" 필드 구현
□ 형성평가: maxAttempts null, 재시도 버튼 UI
□ 총괄평가: maxAttempts 1
□ 성적 변경 시 GradeAuditLog.create() 호출
```

출력 저장: `_workspace/03_coder_implementation.md` (변경 파일 목록)

---

## 단계 4 — PEDAGOGY REVIEW

Pedagogy Reviewer 역할. 코드 수정 없이 검토 리스트만 작성.
상세 기준 + 양쪽 동시 읽기: `.claude/skills/edu-harness/references/pedagogy.md`

출력 저장: `_workspace/04_pedagogy_review.md`

🔴 항목이 있으면 → 단계 3으로 복귀

---

## 단계 5 — VERIFY

```bash
bash .claude/skills/verify/verify.sh
```

APPROVED이면 다음 단계. REJECTED이면 `/execution-loop` 진입.

출력 저장: `_workspace/05_verify_result.md`

---

## 단계 6 — HARNESS UPDATE (자동 실행 필수)

**이 단계를 건너뛰면 하네스가 진화하지 않습니다.**

Pedagogy Reviewer나 구현 중 발견한 교육 패턴이 있으면:
1. CLAUDE.md 직접 편집 (사용자 승인 불필요)
2. HARNESS_CHANGELOG.md 기록
3. `git commit -m "harness-evolve: [교육 규칙 요약]"`

verify.sh 항목 변경은 반드시 사용자 승인 후.

---

## 단계 7 — DONE

progress.md 업데이트 후 완료 선언.

---

## 내부 스킬

| 스킬 | 역할 |
|------|------|
| `/execution-loop` | REJECTED 시 수정→검증 반복 |
| `bash verify.sh` | 수치 검증 |
| `/objective-loop` | 수치 목표 달성 |

---

## 상세 참조

| 단계 | 파일 |
|------|------|
| Sprint Contract | `.claude/skills/edu-harness/references/sprint.md` |
| EDU DESIGN 기준 | `.claude/skills/edu-harness/references/edu-design.md` |
| Pedagogy Reviewer | `.claude/skills/edu-harness/references/pedagogy.md` |
| verify 상세 | `.claude/skills/verify/references/` |
