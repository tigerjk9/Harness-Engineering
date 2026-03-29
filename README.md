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
/harness-init
```

프로젝트 정보 10가지 질문 → `CLAUDE.md`·`architecture.md`·`HARNESS_CHANGELOG.md` 자동 채움

### 3단계: 첫 기능 구현

```
# 교육 앱
/edu-harness 학생 퀴즈 응시 기능을 만들어줘. 형성평가로 설계해줘.

# 범용 앱
/harness 사용자 로그인 기능을 만들어줘.
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
    ├── harness/           # 🚀 범용 워크플로우 (진입점 1)
    ├── edu-harness/       # 🎓 교육 전용 워크플로우 (진입점 2)
    ├── harness-init/      # 🔧 하네스 초기화 자동화
    ├── execution-loop/    # 🔄 합격 기준까지 반복 (내부)
    ├── objective-loop/    # 🎯 수치 목표까지 반복 + 하네스 진화 (내부)
    └── verify/            # ✅ 6차원 검증 (내부)
```

---

## 스킬 카탈로그

| 스킬 | 용도 | 사용 시점 |
|------|------|-----------|
| `/harness-init` | 하네스 초기 설정 자동화 | 클론 직후 |
| `/harness` | 범용 기능 구현 전체 워크플로우 | 일반 앱 |
| `/edu-harness` | 교육 기능 구현 (교육학 검토 포함) | 교육 앱 |
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
