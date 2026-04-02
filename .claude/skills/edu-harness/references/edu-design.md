# 단계 2: EDU DESIGN 상세 기준

## 평가 유형 결정 트리

```
이 기능에 평가 요소가 있는가?
├── 없음 → 단계 3(BUILD)으로 바로 이동
└── 있음 → 유형 결정 필수

  형성평가 (FORMATIVE) — 배움이 목적:
    maxAttempts: null       (무제한 재시도)
    showAnswerAfter: "IMMEDIATELY"
    timeLimit: null
    → 재시도 버튼 UI 필수
    → 즉각 피드백 필수
    → 정답 즉시 공개 가능

  총괄평가 (SUMMATIVE) — 측정이 목적:
    maxAttempts: 1
    showAnswerAfter: "NEVER" 또는 "ON_SUBMIT"
    → API 응답에 isCorrect, correctAnswerId 절대 불포함
    → 채점은 서버에서만 수행
    → 응시 중 정답 힌트 없음
```

## 학습 흐름 설계

```
Bloom's Taxonomy 수준 결정:
  REMEMBER → 기본 퀴즈 (정의, 사실 암기)
  UNDERSTAND → 개념 설명, 예시 매칭
  APPLY → 실제 문제 풀기
  ANALYZE → 비교·분석 문제
  EVALUATE → 비판적 사고 문제
  CREATE → 직접 만들기, 프로젝트

UDL 다양한 표현 수단:
  □ 텍스트 + 시각(이미지/영상) 중 최소 2가지
  □ 학생 성취도에 따른 스캐폴딩 고려

스캐폴딩 수준:
  높음 (어려움): 힌트 없음, 즉각 피드백만
  중간 (보통):   1회 오답 후 힌트 표시
  낮음 (쉬움):   힌트 항상 표시, 단계별 안내
```

## 피드백 메시지 설계

| 사용 금지 ❌ | 권장 표현 ✅ |
|------------|------------|
| "틀렸습니다" | "아직 아니에요. 다시 생각해볼까요?" |
| "오답입니다" | "이번엔 맞지 않았어요. 힌트를 볼까요?" |
| "실패했습니다" | "다시 도전해봐요!" |
| "N개 남았습니다" | "벌써 N개 완료했어요!" |
| "제한 시간 초과" | "시간이 다 됐어요. 다음엔 더 잘 할 수 있을 거예요." |

## 컴포넌트 접근성 요구사항

```
QuizCard:
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
