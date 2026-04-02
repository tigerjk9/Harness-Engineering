# EduHarness Foundation
### 교육자를 위한 AI 코딩 에이전트 하네스 템플릿

[English version →](README.en.md)

---

## 하네스 엔지니어링이란?

AI에게 매번 맥락을 설명하는 대신, **AI가 일관된 품질로 일할 수 있는 환경 자체를 설계**하는 작업입니다.

| | 프롬프트 엔지니어링 | 하네스 엔지니어링 |
|---|---|---|
| 방식 | 매번 맥락을 새로 설명 | 규칙·구조로 미리 위임 |
| 결과 | 일관성 유지 어려움 | 구조적으로 일관된 품질 |

---

## 하네스의 4대 구성 요소

| 구성 요소 | 역할 | 파일 |
|---|---|---|
| 📜 헌법 | AI가 따를 규칙과 원칙 | `CLAUDE.md`, `AGENTS.md` |
| 🏗 작업 구조 | 무엇을 어떻게 만들지 설계도 | `architecture.md`, `progress.md` |
| ✅ 검증 | 결과물 품질 판단 기준 | `.husky/pre-commit`, `docs/verification-rubric.md` |
| 🔄 실행 루프 | 수정→검증→반복 자동화 | `.claude/skills/execution-loop/` |

---

## 빠른 시작 (5분)

### 1단계: 템플릿 가져오기

GitHub **"Use this template"** 버튼 → 새 리포지토리 생성

### 2단계: 하네스 초기화

```
/edu-harness-init
```

질문 2개(프로젝트명 + 교육 앱 여부) → 나머지는 `package.json` 자동 감지 + 첫 기능 구현 시 자동 추론
> `지연 채움`: 기술 스택·사용자 설명은 첫 `/edu-harness` 요청 문장에서 자동으로 읽어옵니다. 직접 수정할 필요 없습니다.

### 3단계: 첫 기능 구현

```
/edu-harness 학생 퀴즈 응시 기능을 만들어줘. 형성평가로 설계해줘.
```

> 슬래시 커맨드 없이 자연어로도 트리거됩니다.
> "퀴즈 기능 만들어줘", "교사 성적 화면 추가해줘" → 자동으로 `/edu-harness` 워크플로우 실행.

---

## 바로 써보기

복사-붙여넣기하면 바로 시작됩니다.

```
# 퀴즈 응시 (형성평가)
/edu-harness 학생이 객관식 퀴즈를 응시하는 기능을 만들어줘. 형성평가로 설계해줘.

# 퀴즈 응시 (총괄평가)
/edu-harness 기말고사 형식의 퀴즈 응시 기능을 만들어줘. 총괄평가로 설계해줘.

# 교사 성적 관리
/edu-harness 교사가 학생 성적을 조회하고 수정하는 화면을 만들어줘.

# 학생 로그인/회원가입
/edu-harness 학생 로그인과 회원가입 기능을 만들어줘. 만 14세 미만 보호자 동의 플로우 포함해줘.

# 레슨 목록 페이지
/edu-harness 학생이 수강 가능한 레슨 목록 페이지를 만들어줘. 진도율 표시 포함.

# 학습 진도 대시보드
/edu-harness 학생 학습 진도 대시보드를 만들어줘. 성장 중심 표현으로 설계해줘.
```

---

## 교육 앱이 아닌 경우

EduHarness의 기반 구조(헌법·검증·실행 루프)는 모든 프로젝트에 사용할 수 있습니다.

`/edu-harness-init` 초기화 시 프로젝트가 교육 앱이 아닌 것으로 감지되면 `CLAUDE.md`에서 교육 도메인 섹션을 자동으로 제거합니다.
`verify.sh`의 `[EDU-DOMAIN]` 검사들은 관련 파일(퀴즈·피드백 컴포넌트)이 없을 때 자동으로 통과됩니다 — 추가 설정 불필요.

```
# 비교육 프로젝트 예시
/edu-harness-init
# → "교육 앱 기능이 감지되지 않았습니다. 교육 도메인 섹션을 제거할까요?" → Y
# → CLAUDE.md에서 규칙 1-5 섹션 삭제, 나머지 코딩 규칙·검증 구조 유지
```

---

## 파일 구조

```
edu-harness/
├── CLAUDE.md              # 📜 헌법 — AI 핵심 규칙 (프로젝트 목적 + 코딩 규칙 + 교육 도메인)
├── AGENTS.md              # 📜 헌법 — 에이전트 역할 분리 + 워크플로우
├── architecture.md        # 🏗 설계 — 기술 스택, 디렉토리, 데이터 모델
├── progress.md            # 🏗 진행 — 현재 상태, 다음 할 일, 이슈
├── HARNESS_CHANGELOG.md   # 하네스 진화 이력
│
├── docs/
│   ├── example-walkthrough.md   # ⭐ 실전 워크스루 (처음이라면 여기부터)
│   ├── education-principles.md  # 교육학 원칙 참조
│   ├── verification-rubric.md   # 6차원 검증 루브릭
│   ├── wcag-checklist.md        # WCAG 접근성 체크리스트
│   └── harness-guide.ko.md      # 하네스 상세 가이드
│
└── .claude/skills/
    ├── edu-harness/       # 🎓 기본 진입점 (계획→검증→하네스 진화 전체 사이클)
    ├── edu-harness-init/      # 🔧 하네스 초기화 자동화
    ├── execution-loop/    # 🔄 합격 기준까지 반복 (내부)
    ├── objective-loop/    # 🎯 수치 목표까지 반복 + 하네스 진화 (내부)
    └── verify/            # ✅ 6차원 검증 (내부)
```

---

## 스킬 카탈로그

| 스킬 | 용도 | 사용 시점 |
|------|------|-----------|
| `/edu-harness-init` | 하네스 초기 설정 자동화 | 클론 직후 |
| `/edu-harness` | 기능 구현 전체 워크플로우 (교육학 검토 포함) | 모든 기능 |
| `/execution-loop` | 합격 기준 충족까지 자동 반복 | 검증 루프 |
| `/objective-loop` | 수치 목표 달성까지 자동 반복 + 하네스 진화 | 목표 기반 개선 |
| `/verify` | 6차원 품질 검증 점수 측정 | 단독 검증 |

---

## 하네스 강도 선택

| 강도 | 상황 | AI 자율성 |
|---|---|---|
| 엄격 | 결제·인증, 학생 데이터, 총괄평가 | 낮음 — 매 단계 승인 |
| 균형 | 일반 교육 기능 개발 | **권장** |
| 느슨 | 아이디어 스케치, 초기 프로토타입 | 높음 |

---

## 더 알아보기

- [실전 워크스루: EduQuiz Mini](docs/example-walkthrough.md) ⭐ 처음이라면 여기부터
- [하네스 구축 시작 가이드](docs/customization-guide.ko.md)
- [하네스 상세 가이드](docs/harness-guide.ko.md)
- [스킬 카탈로그](.claude/skills/README.md)
- [English Guide](docs/harness-guide.en.md)

---

## 기여하기

1. ⭐ **Star**를 눌러주세요
2. 개선 사항은 **Issue**로 제안해주세요
3. 교육 현장 사용 경험은 **Discussions**에 공유해주세요

[MIT License](LICENSE)
