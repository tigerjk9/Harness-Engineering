# EduHarness Foundation
### 교육자를 위한 AI 코딩 에이전트 하네스 템플릿

> "AI와 협업하는 방식을 설계하는 것, 그것이 하네스 엔지니어링입니다."

[English version →](README.en.md)

---

## 하네스 엔지니어링이란?

하네스 엔지니어링은 단순히 AI에게 질문을 잘 던지는 법(프롬프트 엔지니어링)을 넘어,
**AI가 일관된 품질로 일할 수 있는 환경 자체를 설계**하는 작업입니다.

| | 프롬프트 엔지니어링 | **하네스 엔지니어링** |
|---|---|---|
| 관점 | AI를 일회성 도구로 활용 | AI가 일할 환경을 설계 |
| 방식 | 매번 맥락을 새로 설명 | 규칙·구조로 미리 위임 |
| 결과 | 일관성 유지 어려움 | 구조적으로 일관된 품질 |
| 핵심 | 어떻게 물어볼 것인가 | **어떻게 일하는 환경을 만들 것인가** |

---

## 하네스의 4대 구성 요소

| 구성 요소 | 역할 | 이 템플릿의 파일 |
|---|---|---|
| 📜 **헌법 (Constitution)** | AI가 반드시 따라야 할 규칙과 원칙 | `CLAUDE.md`, `AGENTS.md` |
| 🏗 **작업 구조 (Work Structure)** | 무엇을 어떻게 만들지 정의하는 설계도 | `architecture.md`, `progress.md` |
| ✅ **검증 (Verification)** | 결과물의 품질을 판단하는 기준 | `.husky/pre-commit`, 체크리스트 |
| 🔄 **실행 루프 (Execution Loop)** | 수정→검증→반복의 자동화 워크플로우 | `.claude/skills/execution-loop/` |

> 기술 제어 관점(Context/Constraint/Verification/Feedback)과의 상세 매핑은 [하네스 가이드](docs/harness-guide.ko.md)를 참조하세요.

---

## 하네스의 2계층 구조

하네스는 두 계층으로 구성됩니다. 원문 표현을 빌리면:

```
레포지토리 하네스 (Repository Harness) — "회사 취업 규칙"
│  어떤 교육 프로젝트에도 공통으로 적용되는 원칙
│  .claude/ 폴더 전체 (코딩 스타일, 접근성, 교육 도메인 규칙)
│
└── 애플리케이션 하네스 (Application Harness) — "팀 업무 매뉴얼"
       이 프로젝트만을 위한 전용 규칙
       CLAUDE.md + architecture.md + AGENTS.md
       (기술 스택, 데이터 모델, 프로젝트 목적)
```

**clone 후 레포지토리 하네스는 그대로 두고, 애플리케이션 하네스의 `[대괄호]`만 채우면 됩니다.**

---

## 하네스 엔지니어링의 본질: 1인 조직화

> "하네스는 당신의 판단력을 저장소에 저장하는 작업입니다."

하네스에 축적된 헌법, 작업 구조, 검증 기준은 시간이 흐를수록 고도화됩니다.
이는 다른 누구도 쉽게 흉내 낼 수 없는 **나만의 해자(Moat)**가 됩니다.

이 템플릿은 **출발점**입니다.
진짜 가치는 당신이 사용하고 발전시키면서 쌓아가는 과정에 있습니다.

---

## 빠른 시작 (5분)

> 처음 사용하신다면 **[실전 하네스 구축 파이프라인 6단계](docs/customization-guide.ko.md#파이프라인)** 를 먼저 읽으세요.
> 아이디에이션 → 헌법 → 자율 검증 → Git 체크포인트 → 암묵지 명시화 → MBO 실행 루프.

### 1단계: 템플릿 가져오기

GitHub에서 **"Use this template"** 버튼 → 새 리포지토리 생성

또는 직접:
```bash
git clone https://github.com/[YOUR_GITHUB]/edu-harness.git my-edu-project
cd my-edu-project && rm -rf .git && git init
```

### 2단계: 애플리케이션 하네스 채우기

[`docs/customization-guide.ko.md`](docs/customization-guide.ko.md)를 따라 `[대괄호]`를 채우세요:

| 파일 | 수정할 내용 |
|------|------------|
| `CLAUDE.md` | 프로젝트 목적, 주요 명령어 |
| `architecture.md` | 기술 스택, 디렉토리 구조, 데이터 모델 |
| `progress.md` | 현재 진행 상황, 다음 할 일 |
| `AGENTS.md` | 불필요한 역할 정리 |

### 3단계: 위임형 상사로 AI 사용하기

```
# ❌ 지시형 — AI의 창의적 해결 공간 제한
"버튼을 파란색으로 만들고, 텍스트는 16px 흰색으로 설정해줘."

# ❌ 방임형 — 기대치에 미달하는 결과
"UI 만들어줘."

# ✅ 위임형 — 하네스 철학
"[Coder] 퀴즈 결과 화면을 만들어줘.
 education-principles.md의 학습 안전 환경 원칙을 지키고,
 WCAG 2.1 AA를 준수하고, 완료 후 progress.md를 업데이트해줘."
```

---

## 파일 구조

```
edu-harness/
├── CLAUDE.md                      # 📜 헌법 — 프로젝트 핵심 규칙 (가장 먼저 수정)
├── AGENTS.md                      # 📜 헌법 — 역할 분리 + 실행 루프 워크플로우
├── architecture.md                # 🏗 작업 구조 — 시스템 설계 템플릿
├── progress.md                    # 🏗 작업 구조 — 진행 상태 추적
│
├── docs/
│   ├── customization-guide.ko.md  # ⭐ 하네스 구축 시작 가이드 (먼저 읽기)
│   ├── harness-guide.ko.md        # 하네스 상세 가이드 (한국어)
│   ├── harness-guide.en.md        # Detailed guide (English)
│   ├── education-principles.md    # 교육학 원칙 참조 문서
│   └── wcag-checklist.md          # ✅ WCAG 접근성 체크리스트
│
├── .claude/
│   ├── settings.json              # 자동화 훅 설정
│   └── skills/
│       ├── harness/               # 🚀 범용 워크플로우 (사용자 진입점 1)
│       ├── edu-harness/           # 🎓 교육 전용 워크플로우 (사용자 진입점 2)
│       ├── execution-loop/        # 🔄 실행 루프 — 합격 기준까지 반복 (내부)
│       ├── objective-loop/        # 🎯 목표 루프 — 수치 목표까지 반복 + 하네스 진화 (내부)
│       └── verify/                # ✅ 6차원 검증 — APPROVED/CONDITIONAL/REJECTED (내부)
│
└── .husky/
    └── pre-commit                 # ✅ 검증 — 자동 품질 검사
```

---

## 사용 예시

### 에이전트 역할 지정 + 실행 루프

```
# 복잡한 기능 구현 시 (3개 이상 파일)
[Planner] 학생 퀴즈 응시 기능을 어떻게 구현할지 계획을 세워줘.
architecture.md를 먼저 읽고 기존 구조에 맞게 계획해.
3단계 이상이면 내 승인을 먼저 받아줘.

# 실행 루프 시작
[execution-loop 스킬 사용] 위 계획대로 퀴즈 응시 기능을 구현해줘.
모든 검증이 통과할 때까지 수정→검증→반복 루프를 돌려줘.
```

### 스킬 활용

```
# 교육 앱: 한 명령으로 계획→구현→검증→하네스 업데이트 전체 실행
[edu-harness 스킬 사용] 학생 퀴즈 응시 기능을 만들어줘. 형성평가로 설계해줘.

# 범용 앱: 동일한 워크플로우, 교육 도메인 검사 제외
[harness 스킬 사용] 사용자 로그인 기능을 만들어줘.

# 수치 목표 달성 + 하네스 자체 진화
[objective-loop 스킬 사용] verify 점수를 REJECTED → APPROVED로 올려줘.
[objective-loop 스킬 사용] Pedagogy Reviewer 🔴 0개, 🟡 2개 이하 달성해줘.

# 현재 점수 측정
bash .claude/skills/verify/verify.sh
bash .claude/skills/objective-loop/measure.sh baseline "시작"
bash .claude/skills/objective-loop/measure.sh check "루프 1 완료"
```

### 세이브 포인트 만들기

작업 시작 전 항상 커밋:
```bash
git add -A && git commit -m "checkpoint: 퀴즈 기능 구현 시작 전"
```

---

## 하네스 강도 선택

| 하네스 강도 | 상황 | AI 자율성 |
|---|---|---|
| 엄격 (Strict) | 결제·인증, 학생 데이터, 총괄평가 | 낮음 — 매 단계 승인 |
| 균형 (Adaptive) | 일반 교육 기능 개발 | **권장** |
| 느슨 (Vibe) | 아이디어 스케치, 초기 프로토타입 | 높음 — 빠르지만 위험 |

### 접근성 주의 (2026년 4월)

공공 교육기관은 **2026년 4월부터 WCAG 2.1 AA 준수가 법적 의무**입니다.
`docs/wcag-checklist.md`를 참조하세요.

---

## 활용 가능한 교육 프로젝트 유형

- 퀴즈·평가 시스템 (형성/총괄 평가 구분 내장)
- 학습 진도 추적 앱
- 수업 자료 관리 플랫폼
- 학생 포트폴리오 사이트
- 출결 관리 시스템
- 학습 대시보드

---

## 더 알아보기

- [실전 워크스루: EduQuiz Mini 하네스 구축](docs/example-walkthrough.md) ⭐ 처음이라면 여기부터
- [하네스 구축 시작 가이드](docs/customization-guide.ko.md)
- [하네스 상세 가이드](docs/harness-guide.ko.md)
- [스킬 카탈로그](.claude/skills/README.md)
- [WCAG 2.1 접근성 체크리스트](docs/wcag-checklist.md)
- [English Guide](docs/harness-guide.en.md)

---

## 기여하기

이 템플릿이 도움이 되었다면:
1. ⭐ **Star**를 눌러주세요
2. 개선 사항은 **Issue**로 제안해주세요
3. 교육 현장에서 사용한 경험을 **Discussions**에 공유해주세요

---

## 라이선스

[MIT License](LICENSE) — 자유롭게 사용·수정·배포하세요.
