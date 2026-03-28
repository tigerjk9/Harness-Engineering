---
name: harness-init
description: 새 프로젝트 시작 시 CLAUDE.md, architecture.md, progress.md의 [대괄호] 플레이스홀더를 자동으로 채웁니다. clone 직후 가장 먼저 실행하세요.
---

# /harness-init

> 새 프로젝트 시작 시 **가장 먼저** 실행하는 스킬입니다.
> `[대괄호]` 플레이스홀더 12개를 한 번의 대화로 채웁니다.

## 사용 방법

```
/harness-init
```

인수 없이 실행하면 스킬이 질문을 시작합니다.

---

## 실행 순서

### 1단계 — 프로젝트 정보 수집

다음 항목을 순서대로 질문합니다. 답변이 있으면 바로 다음으로 넘어갑니다.

```
Q1. 프로젝트 이름은? (예: EduQuiz Mini, LearnTrack Pro)
Q2. 핵심 사용자는? (예: 초등학교 교사와 학생)
Q3. 핵심 기능 3가지는? (예: 퀴즈 생성, 학생 응시, 진도 추적)
Q4. 기술 스택은? (예: Next.js 14, TypeScript, PostgreSQL, Prisma)
Q5. 배포 환경은? (예: Vercel + Supabase)
Q6. 개발 서버 명령어는? (예: npm run dev)
Q7. 테스트 명령어는? (예: npm test)
Q8. 린트 명령어는? (예: npm run lint)
Q9. 타입 체크 명령어는? (예: npx tsc --noEmit)
Q10. 빌드 명령어는? (예: npm run build)
```

교육 앱 여부 자동 감지: 기술 스택이나 사용자 설명에 "학생", "교사", "퀴즈", "학습" 등이 포함되면 CLAUDE.md 교육 도메인 섹션을 유지. 아니면 삭제 제안.

---

### 2단계 — CLAUDE.md 업데이트

수집된 정보로 다음 플레이스홀더를 교체:

| 플레이스홀더 | 교체 내용 |
|---|---|
| `[YOUR_PROJECT_NAME]` | Q1 답변 |
| `[예: 초등학교 교사, 대학생, 온라인 강사]` | Q2 답변 |
| `[예: 퀴즈 생성, 학습 진도 추적, 수업 자료 관리]` | Q3 답변 |
| `[예: Vercel, AWS, 로컬 서버]` | Q5 답변 |
| `[YOUR_DEV_COMMAND]` | Q6 답변 |
| `[YOUR_TEST_COMMAND]` | Q7 답변 |
| `[YOUR_LINT_COMMAND]` | Q8 답변 |
| `[YOUR_TYPECHECK_COMMAND]` | Q9 답변 |
| `[YOUR_BUILD_COMMAND]` | Q10 답변 |

교육 앱이 아닌 경우: `> ⚠️ 교육 앱이 아니라면...` 마커 아래 교육 도메인 섹션 전체를 삭제.

---

### 3단계 — architecture.md 업데이트

`architecture.md`의 `[대괄호]` 항목들을 수집된 정보로 채웁니다:
- 프로젝트명, 기술 스택, 배포 환경

---

### 4단계 — HARNESS_CHANGELOG.md 초기화

```
| 날짜 | 파일 | 변경 내용 | 맥락 |
|------|------|-----------|------|
| [오늘 날짜] | CLAUDE.md | 초기 하네스 설정 완료 | /harness-init 실행 |
```

---

### 5단계 — 완료 보고

```
✅ harness-init 완료

채워진 파일:
- CLAUDE.md — 9개 플레이스홀더 교체
- architecture.md — [N]개 플레이스홀더 교체
- HARNESS_CHANGELOG.md — 초기화 완료

다음 단계:
1. git add CLAUDE.md architecture.md HARNESS_CHANGELOG.md
2. git commit -m "harness: [프로젝트명] 초기 하네스 설정"
3. /edu-harness [첫 번째 기능]을 만들어줘.
```
