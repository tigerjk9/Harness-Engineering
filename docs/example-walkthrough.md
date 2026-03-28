# 실전 워크스루: EduQuiz Mini 하네스 구축

> 빈 폴더에서 시작해 하네스가 완성되기까지의 실제 대화 흐름입니다.
> 가상 프로젝트: 초등학생 대상 수학 퀴즈 앱 "EduQuiz Mini"

---

## 출발 상황

```bash
git clone https://github.com/[your-org]/edu-harness.git edupquiz-mini
cd edupquiz-mini
npx create-next-app . --typescript --tailwind
npm install
```

EduHarness 템플릿이 복사됐고, Next.js 프로젝트가 초기화됐습니다.
이제 파이프라인 6단계를 따라갑니다.

---

## 단계 1 — 아이디에이션 & 아키텍처

**Claude Code에 입력:**
```
architecture.md 템플릿을 채워줘.
우리 앱: 초등학생(1-6학년) 대상 수학 퀴즈 앱 "EduQuiz Mini"
기술 스택: Next.js 14, TypeScript, PostgreSQL, Prisma, Tailwind
배포: Vercel + Supabase
핵심 기능: 교사가 퀴즈 생성, 학생이 응시, 진도 추적
```

**Claude 응답 (architecture.md 채워짐):**
```markdown
| 항목 | 내용 |
|------|------|
| 프로젝트명 | EduQuiz Mini |
| 목적 | 초등학생 대상 수학 퀴즈 웹앱 |
| 기술 스택 | Next.js 14 App Router, TypeScript, PostgreSQL, Prisma ORM |
| 배포 | Vercel (프론트) + Supabase (DB) |
| 주요 사용자 | 교사 (퀴즈 생성), 학생 (응시, 진도 확인) |

디렉토리 구조:
src/
├── app/
│   ├── teacher/quiz/    # 교사 퀴즈 관리
│   ├── student/quiz/    # 학생 응시 화면
│   └── api/             # API 라우트
├── components/          # 공유 컴포넌트
└── lib/                 # 유틸리티, DB 클라이언트
```

---

## 단계 2 — 헌법 제정 (CLAUDE.md 채우기)

**Claude Code에 입력:**
```
CLAUDE.md의 [대괄호] 항목들을 채워줘.
- 프로젝트: EduQuiz Mini
- 대상 사용자: 초등학생 1-6학년과 그 담임 교사
- 배포: Vercel
- 명령어: npm run dev / npm test / npm run lint / npx tsc --noEmit / npm run build
```

**Claude 응답:** CLAUDE.md 상단 채워짐
```markdown
## 프로젝트 목적
**EduQuiz Mini**는 교육자를 위한 웹 애플리케이션입니다.
- 대상 사용자: 초등학교 1-6학년 학생 및 담임 교사
- 핵심 기능: 퀴즈 생성, 학생 응시, 학습 진도 추적
- 배포 환경: Vercel
```

---

## 단계 3 — 자율 검증 및 정렬

**Claude Code에 입력:**
```
[verify 스킬 사용] CLAUDE.md와 architecture.md를 읽고
서로 모순되는 내용이 있는지 확인해줘.
또한 교육 도메인 규칙이 누락된 부분도 알려줘.
```

**Claude 응답:**
```
검증 결과: 초기 문서 일관성 검사

발견된 사항:
🟡 architecture.md에 quiz.type 필드(FORMATIVE/SUMMATIVE)가 DB 스키마에 없음
   → 규칙 1(형성/총괄평가 구분) 위반 가능성
   → Prisma 스키마에 type 필드 추가 권장

🟡 학생 연령(초등 1-6학년)이 명시됐으나
   만 14세 미만 보호자 동의 플로우가 CLAUDE.md에 언급은 있으나
   architecture.md 회원가입 플로우에 반영 없음

🟢 코딩 규칙(TypeScript, 불변성, 접근성)은 일관성 있음
```

→ architecture.md에 `quiz.type: FORMATIVE | SUMMATIVE` 추가
→ 회원가입 플로우에 연령 확인 단계 추가

---

## 단계 4 — Git 체크포인트

```bash
git add CLAUDE.md architecture.md progress.md
git commit -m "harness: 초기 헌법 및 아키텍처 설정

EduQuiz Mini 하네스 v1:
- 프로젝트 목적, 기술 스택, 디렉토리 구조 정의
- 교육 도메인 규칙 (형성/총괄평가, 심리 안전) 활성화
- quiz.type 필드 DB 스키마에 명시
- 만 14세 미만 보호자 동의 플로우 추가"
```

**이 커밋이 하네스 v1입니다.** 앞으로 모든 규칙 개선은 이 위에 쌓입니다.

---

## 단계 5 — 암묵지 명시화 (개발 중 발견)

첫 번째 기능(퀴즈 목록 페이지)을 만들다가 발견한 상황:

**개발 중 발견 1 — AI가 재시도 버튼 없이 구현함**
```
방금 퀴즈 응시 화면을 만들었는데, AI가 재시도 버튼을 만들지 않았어.
CLAUDE.md에 "형성평가 화면에는 재시도 버튼이 항상 표시돼야 한다"는
규칙을 추가해줘. 위치는 규칙 2(학습 안전 환경) 아래.
```

**개발 중 발견 2 — "몇 개 남았습니다" 표현 사용됨**
```
진도 화면에 "아직 5개 레슨이 남았습니다"라는 문구가 나왔어.
CLAUDE.md 규칙 2에 구체적 금지 표현 예시를 추가해줘:
- 금지: "[N]개 남았습니다" → 허용: "벌써 [N]개 완료했어요!"
```

```bash
git add CLAUDE.md
git commit -m "harness-evolve: 형성평가 재시도 버튼 + 진도 표현 규칙 추가

개발 중 AI가 반복적으로 놓친 2가지 규칙을 명시화:
1. 형성평가: 재시도 버튼 항상 표시 (CLAUDE.md 규칙 2)
2. 진도 메시지: 성장 중심 표현 강제 (구체적 금지 예시 추가)"
```

**하네스가 v2로 진화했습니다.** 다음 기능부터는 AI가 이 실수를 반복하지 않습니다.

---

## 단계 6 — MBO 실행 루프

이제 실제 기능을 만듭니다.

**기준점 먼저 측정:**
```bash
bash .claude/skills/objective-loop/measure.sh baseline "퀴즈 응시 기능 개발 전"
# 출력: 기준점 저장 완료: SCORE=20 VERDICT=REJECTED
# (src/ 파일이 거의 없는 상태라 낮음)
```

**edu-harness 실행:**
```
[edu-harness 스킬 사용] 학생 퀴즈 응시 기능을 만들어줘.
형성평가로 설계하고, 오답 즉시 피드백과 재시도 버튼을 포함해줘.
완료 후 progress.md를 업데이트해줘.
```

**edu-harness 내부 실행 흐름:**
```
1. [Planner] 계획 수립
   → QuizSession 컴포넌트, API 라우트, Prisma 스키마 변경 계획

2. [EDU DESIGN] 평가 유형 확인
   → 형성평가: maxAttempts=null, showAnswerAfter="IMMEDIATELY" 확인

3. [Coder] 구현
   → src/app/student/quiz/[id]/page.tsx
   → src/components/QuizCard.tsx (fieldset+legend, aria-live)
   → src/app/api/quiz/[id]/submit/route.ts (서버 채점)
   → __tests__/QuizCard.test.tsx (jest-axe 포함)

4. [Pedagogy Reviewer] 검토
   → 🟡 발견: 재시도 버튼 있음 ✅, 힌트 없음 (개선 권장)
   → 수정: 오답 시 관련 개념 힌트 한 줄 추가

5. verify.sh 실행
```

**루프 1 완료 후 측정:**
```bash
bash .claude/skills/objective-loop/measure.sh check "루프 1: 기본 구현 완료"
# 출력:
# 현재: SCORE=75 | 기준점: 20 | delta: +55 | VERDICT=CONDITIONAL
```

**루프 2 (MEDIUM 미통과 항목 수정):**
```
[execution-loop 스킬 사용] verify CONDITIONAL 항목을 수정해줘.
APPROVED가 될 때까지 반복해줘.
```

```bash
bash .claude/skills/objective-loop/measure.sh check "루프 2: MEDIUM 항목 수정"
# 출력:
# 현재: SCORE=95 | 기준점: 20 | delta: +75 | VERDICT=APPROVED
```

---

## 최종 결과: Before vs After CLAUDE.md

**Before (clone 직후):**
```markdown
## 프로젝트 목적
[YOUR_PROJECT_NAME]은 교육자를 위한 웹 애플리케이션입니다.
- 대상 사용자: [예: 초등학교 교사, 대학생]
```

**After (하네스 진화 후):**
```markdown
## 프로젝트 목적
EduQuiz Mini는 교육자를 위한 웹 애플리케이션입니다.
- 대상 사용자: 초등학교 1-6학년 학생 및 담임 교사
- 핵심 기능: 퀴즈 생성, 학생 응시, 학습 진도 추적
- 배포 환경: Vercel

## 코딩 규칙 (추가된 규칙들)
### 형성평가 UI 필수 패턴
- 재시도 버튼은 오답 피드백과 함께 항상 표시할 것
- 오답 피드백에는 관련 수학 개념 힌트 한 줄 필수 포함

### 진도 표현 규칙
- 금지: "[N]개 레슨이 남았습니다"
- 허용: "벌써 [N]개 완료했어요!"
- 금지: "아직 [N]개를 더 풀어야 합니다"
- 허용: "[N]/[전체] 문제 완료!"
```

---

## 이 워크스루에서 생성된 git 히스토리

```
commit 4a3f921  harness-evolve: SCORE 20→95 달성, 퀴즈 응시 기능 완성
commit 2d8f034  harness-evolve: 형성평가 재시도 버튼 + 진도 표현 규칙 추가
commit 9e1b2c7  harness: 초기 헌법 및 아키텍처 설정
commit 4909004  Initial commit
```

각 커밋이 하네스의 성장 기록이며, 동시에 다음 AI 모델 학습의 데이터가 됩니다.

---

## 핵심 교훈

1. **하네스는 처음부터 완벽하지 않습니다.** "재시도 버튼" 규칙은 AI가 실수한 후에야 명시됐습니다.
2. **암묵지는 개발 중에 발견됩니다.** 당연하다고 생각한 것이 AI에겐 당연하지 않습니다.
3. **measure.sh 수치(20→95)가 진짜 증거입니다.** "잘 됐다" 는 주관적 판단, 숫자는 객관적 증거.
4. **git 히스토리가 하네스의 성장을 기록합니다.** 다음 프로젝트는 여기서 출발합니다.
