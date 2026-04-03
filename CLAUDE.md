# CLAUDE.md — EduHarness Foundation

> 모든 작업 시작 전 이 파일을 읽으세요. 마지막 업데이트: 2026-04-03
> 계층 안내: 이 파일 = 애플리케이션 하네스 | `.claude/skills/` = 레포지토리 하네스(수정 금지)

---

## 프로젝트 목적

**[YOUR_PROJECT_NAME]** — 교육자를 위한 웹 애플리케이션
- 대상 사용자: [예: 초등학교 교사, 대학생, 온라인 강사]
- 핵심 기능: [예: 퀴즈 생성, 학습 진도 추적, 수업 자료 관리]
- 배포 환경: [예: Vercel, AWS, 로컬 서버]

---

## 작업 시작 전 필수 절차

1. `progress.md` 읽기 — 현재 상태 파악 **(컨텍스트 앵커 섹션 먼저 확인)**
2. `architecture.md` 읽기 — 시스템 구조 이해
3. **3개 이상 파일에 영향을 미치는 작업** → 계획 먼저 제시, 사용자 승인 후 진행
4. 논리적 충돌 발견 시 → 즉시 작업 중단, 사용자에게 보고

---

## 코딩 규칙

- TypeScript 필수, `any` 금지, 함수형 컴포넌트
- 불변성: 객체·배열 직접 수정 금지 — spread 연산자로 새 객체 생성
- async 함수: try-catch 필수, 오류 메시지에 민감 정보 포함 금지
- 비밀 정보: `process.env`만 사용, 코드 하드코딩 절대 금지
- 파일 800줄 이하 / 함수 50줄 이하 / 중첩 4단계 이하
- 접근성(WCAG 2.1 AA): 모든 `<img>` alt 텍스트, 버튼 aria-label, 키보드 완전 접근, 색상 대비 4.5:1 이상

---

## Context Anxiety 방어

AI 모델은 컨텍스트 창이 채워질수록 기능을 건너뛰거나 성급하게 완료를 선언하려는 경향이 있습니다.

- **컨텍스트 70% 이상**: 즉시 `progress.md` 업데이트 후 새 세션에서 재개
- **앵커 작성 의무**: 컨텍스트 70% 도달 시 `progress.md`의 **컨텍스트 앵커** 섹션(intent/changes_made/decisions_taken/next_steps)을 업데이트한 후 세션 전환
- **기능 축소 금지**: "컨텍스트가 부족해서 나중에" = 규칙 위반. 새 세션을 열고 이어서 진행
- **세션 시작 의식 (Session Init)**: 새 세션은 반드시 `progress.md` → `architecture.md` 순으로 읽은 후 시작
- **성급한 완료 선언 금지**: 컨텍스트 압박이 느껴지더라도 실행 증거 없이 완료 선언 불가

---

## 자기 복구 계층 (Self-Repair Hierarchy)

AI 에이전트가 오류를 만났을 때 사용하는 2단계 복구 전략입니다.

### Level 1 — 컨텍스트 재시도 (자동)
오류 메시지를 읽고, 원인을 파악한 후 다른 전략으로 재시도합니다.
→ `/execution-loop`이 이 레벨을 자동화합니다.

### Level 2 — 체크포인트 롤백 (오염 감지 시)
Level 1으로 해결되지 않거나 여러 파일이 예상과 다르게 변경된 경우:

```bash
# 현재 상태 확인
bash .claude/hooks/harness-checkpoint.sh list

# 마지막 안전한 지점으로 복원
bash .claude/hooks/harness-checkpoint.sh restore
```

**체크포인트 생성 시점** (3개 이상 파일 변경 전 자동 실행):
```bash
bash .claude/hooks/harness-checkpoint.sh checkpoint "[기능명] 구현 전"
```

> **규칙**: execution-loop가 3회 연속 같은 오류를 반복하면 Level 2 롤백 후 재시작.

---

> ⚠️ **교육 앱이 아니라면 아래 섹션(교육 도메인 특수 규칙) 전체를 삭제하세요.**

---

## 교육 도메인 특수 규칙

### 규칙 1 — 형성평가 vs 총괄평가 반드시 구분

| 구분 | 형성평가 Formative | 총괄평가 Summative |
|------|-------------------|-------------------|
| 재시도 | **허용 (권장)** | 불가 |
| 즉각 피드백 | **필수** | 제출 후 일괄 공개 |
| 정답 노출 | 즉시 또는 재시도 후 | 교사 설정에 따름 |
| `maxAttempts` | `null` (무제한) | `1` |
| `showAnswerAfter` | `"IMMEDIATELY"` | `"NEVER"` 또는 `"ON_SUBMIT"` |

- DB에 `quiz.type: "FORMATIVE" | "SUMMATIVE"` 필드 필수
- 형성평가에 총괄평가 로직 적용 = CRITICAL 오류

### 규칙 2 — 학습 안전 환경 (Psychological Safety)

금지 메시지 → 권장 대체:
- "틀렸습니다" → "아직 아니에요. 다시 생각해볼까요?"
- "오답입니다. 0점" → "이번엔 맞지 않았어요. 힌트를 볼까요?"
- "제한 시간 초과" → "시간이 다 됐어요. 다음엔 더 잘 할 수 있을 거예요."
- "학습 완료율 30%" → "벌써 3개 레슨을 마쳤어요!" (성장 중심 표현)
- 형성평가 재시도 버튼 **항상** 제공

### 규칙 3 — 평가 무결성

- 정답 데이터(`isCorrect`, `correctAnswerId`) API 응답 포함 절대 금지
- 채점은 서버에서만 수행
- 문항 순서: 학생마다 시드(seed) 기반 랜덤화 — 재현 가능해야 함
- 성적 변경: `GradeAuditLog` 테이블에 기록 (누가, 언제, 이유)

### 규칙 4 — 교육 콘텐츠 버저닝

- 응시된 문항(Question) 직접 수정 금지 → 새 버전 생성 후 신규 Quiz에 연결
- 기존 Progress/Score는 응시 당시 버전으로 영구 보존

### 규칙 5 — 미성년자 데이터

- 만 14세 미만: 회원가입 시 보호자 동의 플로우 필수
- 수집 최소화: 학습에 직접 필요한 항목만 (이름, 학교, 학번)
- 학생 데이터 제3자 제공 코드 작성 시 → 즉시 중단, 사용자 확인

---

## 단일 기능 세션 경계

> OWASP Agentic Top 10 원칙: 세션당 하나의 명확한 목표만 완성합니다.

**규칙**: 세션당 1개 기능만 완성. **완성 기준** = 테스트 통과 + git commit + progress.md 업데이트

- 세션 시작 시 이번 세션에서 완성할 기능 1개를 명시적으로 선언
- 기능 완성 전 다른 기능으로 전환 금지 (발견한 다른 이슈 → `progress.md` 이슈 테이블에 기록 후 다음 세션으로)
- 완성 기준 미충족 = 미완성 (CONDITIONAL이상 VERDICT 필요)

**세션 시작 6단계 의식** (새 세션 시작 시 순서대로 실행):

```
1. pwd                          → 현재 디렉토리 확인
2. git log --oneline -5         → 마지막 5개 커밋 확인
3. progress.md 앵커 섹션 읽기   → intent/next_steps 확인
4. feature_list 또는 prd.json 읽기 → 다음 구현 대상 확인
5. cat .execution-loop-state    → 미완료 루프 여부 확인
6. bash .claude/skills/verify/verify.sh → 현재 VERDICT 확인
```

---

## 금지 행동

| 행동 | 위험 분류 | 이유 |
|------|-----------|------|
| 파일 읽기, Glob, Grep 검색 | Read (자동) | 부작용 없음 |
| 파일 생성·수정, Bash 스크립트 | Write (확인 권장) | 되돌리기 가능하나 부작용 있음 |
| `rm -rf`, 파일 영구 삭제 | Irreversible (사용자 승인 필수) | 복구 불가 |
| 데이터베이스 스키마 변경 | Irreversible (사용자 승인 필수) | 데이터 손실 위험 |
| 인증·권한 로직 수정 | Write (확인 권장) | 보안 취약점 위험 |
| 환경 변수 추가·삭제 | Write (확인 권장) | 배포 환경 영향 |
| 외부 API 설정 변경 | Irreversible (사용자 승인 필수) | 서비스 중단 위험 |

---

## 작업 완료 기준

작업 완료 선언 전 반드시:
1. 관련 테스트 명령어 실행 → 결과 확인
2. `progress.md` 업데이트
3. 변경 요약 한 줄 제시 (무엇을, 왜)

> "아마 될 것 같습니다", "테스트 없이 확인됐습니다" 금지 — 실행 증거 필수

---

## 주요 명령어

```bash
[YOUR_DEV_COMMAND]        # 개발 서버
[YOUR_TEST_COMMAND]       # 테스트
[YOUR_LINT_COMMAND]       # 린트
[YOUR_TYPECHECK_COMMAND]  # 타입 체크
[YOUR_BUILD_COMMAND]      # 빌드
```

---

## 참고 문서

| 파일 | 내용 |
|------|------|
| `architecture.md` | 시스템 구조와 데이터 흐름 |
| `progress.md` | 현재 진행 상황과 다음 할 일 |
| `AGENTS.md` | 에이전트 역할 분리 |
| `docs/education-principles.md` | 형성/총괄 평가, Bloom's taxonomy, UDL 원칙 |
| `docs/example-walkthrough.md` | 실전 하네스 구축 워크스루 |
| `.claude/skills/README.md` | 스킬 카탈로그 |
