# architecture.md — 시스템 구조 가이드

> AI 에이전트는 코드를 작성하기 전에 이 문서를 읽습니다.
> `[대괄호]` 안의 내용을 자신의 프로젝트에 맞게 수정하세요.
> 마지막 업데이트: [YYYY-MM-DD]

---

## 프로젝트 개요

| 항목 | 내용 |
|------|------|
| 프로젝트명 | [YOUR_PROJECT_NAME] |
| 목적 | [교육 목적 설명 — 예: 교사가 쉽게 퀴즈를 만들고 학생 진도를 추적하는 웹앱] |
| 기술 스택 | [예: Next.js 14, TypeScript, PostgreSQL, Tailwind CSS, Prisma] |
| 배포 환경 | [예: Vercel (프론트엔드) + Railway (데이터베이스)] |
| 현재 버전 | v0.1.0 (MVP) |

---

## 핵심 사용자 역할

| 역할 | 설명 | 주요 기능 |
|------|------|-----------|
| 교사 | 콘텐츠 생성·관리 | 퀴즈 생성, 학생 관리, 성적 확인 |
| 학생 | 학습 활동 참여 | 퀴즈 응시, 진도 확인, 제출 |
| 관리자 | 시스템 관리 | 사용자 관리, 학교·기관 설정 |

---

## 디렉토리 구조

```
[YOUR_PROJECT_NAME]/
├── src/
│   ├── components/
│   │   ├── common/         # 범용 컴포넌트 (Button, Input, Modal)
│   │   └── edu/            # 교육 특화 컴포넌트 (QuizCard, ProgressBar)
│   ├── app/ (또는 pages/)  # Next.js 라우트 (App Router 권장)
│   │   ├── (auth)/         # 인증 관련 페이지
│   │   ├── dashboard/      # 대시보드
│   │   ├── quiz/           # 퀴즈 관련 페이지
│   │   └── api/            # API 라우트
│   ├── hooks/              # 커스텀 React 훅
│   ├── lib/                # 외부 라이브러리 설정 (Prisma, Auth 등)
│   ├── utils/              # 순수 유틸리티 함수
│   └── types/              # TypeScript 공유 타입 정의
├── tests/
│   ├── unit/               # 단위 테스트
│   └── integration/        # 통합 테스트
├── public/                 # 정적 파일 (이미지, 폰트)
├── prisma/ (또는 db/)      # 데이터베이스 스키마
└── .env.local              # 환경 변수 (git에 올리지 말 것!)
```

---

## 데이터 모델 (주요 엔티티)

> 교육 도메인 특수 엔티티는 ⭐로 표시

```
User {
  id          String   @id
  email       String   @unique
  role        Role     (TEACHER | STUDENT | ADMIN)
  name        String
  birthYear   Int?     // 만 14세 미만 판별용
  createdAt   DateTime
}

⭐ Cohort {            // 학급·코호트 단위 관리
  id          String   @id
  name        String   // 예: "2026년 1학기 3반"
  courseId    String → Course
  teacherId   String → User
  students    User[]
  startDate   DateTime
  endDate     DateTime?
}

Course {
  id          String @id
  title       String
  teacherId   String → User
  cohorts     Cohort[]
  lessons     Lesson[]
}

⭐ LearningObjective {  // 학습 목표 (Bloom's taxonomy 연결)
  id          String @id
  lessonId    String → Lesson
  description String   // "학생은 분수 덧셈을 할 수 있다"
  bloomLevel  BloomLevel
  // REMEMBER | UNDERSTAND | APPLY | ANALYZE | EVALUATE | CREATE
}

Lesson {
  id          String @id
  courseId    String → Course
  title       String
  content     String
  order       Int
  objectives  LearningObjective[]
  quiz        Quiz?
}

⭐ Quiz {
  id              String     @id
  lessonId        String     → Lesson
  type            QuizType   // FORMATIVE | SUMMATIVE  ← 핵심 구분
  timeLimit       Int?       // 분 단위, null = 제한 없음
  randomize       Boolean    @default(true)
  showAnswerAfter AnswerReveal
  // IMMEDIATELY(형성평가) | ON_SUBMIT | NEVER(총괄평가)
  maxAttempts     Int?       // null = 무제한(형성평가), 1 = 재시도 불가(총괄평가)
  questions       Question[]
}

Question {
  id          String   @id
  quizId      String → Quiz
  content     String
  choices     Choice[]
  currentVersion Int   @default(1)
  versions    QuestionVersion[]
}

⭐ QuestionVersion {    // 콘텐츠 버저닝 — 기존 응시 이력 보호
  id          String   @id
  questionId  String → Question
  version     Int
  content     String
  choicesJson Json     // 해당 버전의 선택지 스냅샷
  createdAt   DateTime
}

Progress {
  userId          String → User
  lessonId        String → Lesson
  completed       Boolean
  score           Int?
  attemptCount    Int     @default(0)
  questionVersion Int     // 응시 당시의 문항 버전 기록
  updatedAt       DateTime
}

⭐ GradeAuditLog {      // 성적 변경 감사 로그
  id          String   @id
  studentId   String → User
  quizId      String → Quiz
  oldScore    Int?
  newScore    Int
  changedById String → User   // 교사 또는 시스템
  reason      String?
  changedAt   DateTime
}
```

### 타입 정의

```typescript
type QuizType = "FORMATIVE" | "SUMMATIVE"
type AnswerReveal = "IMMEDIATELY" | "ON_SUBMIT" | "NEVER"
type BloomLevel =
  | "REMEMBER"    // 기억 — 사실 암기, 목록 나열
  | "UNDERSTAND"  // 이해 — 개념 설명, 요약
  | "APPLY"       // 적용 — 문제 해결, 공식 사용
  | "ANALYZE"     // 분석 — 원인 파악, 비교
  | "EVALUATE"    // 평가 — 판단, 비판
  | "CREATE"      // 창조 — 새로운 것 생성, 설계
```

---

## API 설계 원칙

- RESTful 패턴 (또는 tRPC)
- 모든 응답 형식 통일:
  ```typescript
  { data: T | null, error: string | null, status: number }
  ```
- 인증: 모든 보호된 라우트에 미들웨어 적용
- 입력 검증: zod 스키마 사용

---

## 데이터 흐름

```
사용자 (브라우저)
    ↓ HTTP 요청
Next.js API Routes / Server Actions
    ↓ 쿼리
Prisma ORM
    ↓
PostgreSQL (또는 [YOUR_DATABASE])
```

---

## 핵심 제약 사항

1. **개인정보**: 학생 데이터는 개인정보보호법 준수 — 최소 수집, 암호화 저장
2. **미성년자**: 만 14세 미만은 보호자 동의 없이 가입 불가
3. **접근성**: 모든 페이지 WCAG 2.1 AA 준수 (2026년 4월 법적 의무화)
4. **평가 무결성**: 정답 데이터는 서버에서만 처리 — 클라이언트에 절대 노출 금지
5. **콘텐츠 버저닝**: 응시된 문항 직접 수정 금지 — 새 버전으로만 변경
6. **반응형**: 모바일 퍼스트 — 768px, 480px 테스트 필수
7. **성능**: 페이지 LCP 2.5초 이하 목표
8. **미디어**: 이미지·동영상은 CDN을 통해 제공

---

## AI 에이전트 확인 필요 영역

다음 변경 시 **반드시 사용자 승인 요청**:

- `prisma/schema.prisma` 변경 (데이터베이스 스키마)
- `src/lib/auth.ts` 변경 (인증 로직)
- `src/app/api/` 새 엔드포인트 추가
- `.env` 변수 추가·삭제
- 외부 라이브러리 추가 (`package.json` 변경)

---

## 의존성 지도

```
components/ → types/ (타입만 의존)
hooks/      → utils/, types/
pages/      → components/, hooks/, lib/
api/        → lib/, utils/, types/
```

> 순환 의존성 금지: A → B → A 패턴 불가
