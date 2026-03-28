# EduHarness 검증 루브릭 (Verification Rubric)

> 이 루브릭은 EduHarness의 모든 검증 판단 기준입니다.
> `.claude/skills/verify/SKILL.md`와 `.husky/pre-commit`이 이 기준을 따릅니다.
> 마지막 업데이트: 2026-03-29

---

## 심각도 기준

| 심각도 | 의미 | 처리 방식 |
|---|---|---|
| 🔴 **CRITICAL** | 학생 피해, 데이터 유출, 보안 취약점 | **커밋 차단** — 즉시 수정 필수 |
| 🟡 **HIGH** | 교육적 품질 저하, 접근성 위반 | PR 머지 전 수정 필수 |
| 🟢 **MEDIUM** | 개선 권장, 사용자 경험 영향 | 다음 스프린트 수용 가능 |

**합격 조건:**
- CRITICAL 항목: 0개 (하나라도 있으면 자동 실패)
- HIGH 항목: 0개 (예외 인정 시 documented reason 필수)
- MEDIUM 항목: 80% 이상 통과

---

## 차원 1 — 기술 검증 (Technical)

코드 품질, 타입 안전성, 테스트 커버리지

| 심각도 | 항목 | 측정 방법 |
|---|---|---|
| 🟡 HIGH | ESLint 오류 0개 | `npm run lint` 실행 결과 |
| 🟡 HIGH | TypeScript 타입 오류 0개 | `npx tsc --noEmit` 결과 |
| 🟡 HIGH | 테스트 실패 0개 | `npm test` 결과 |
| 🟢 MEDIUM | 신규 코드 단위 테스트 존재 | 변경된 함수/컴포넌트에 `.test.ts` 파일 확인 |
| 🟢 MEDIUM | 파일 800줄 이하 | `wc -l src/**/*.ts` |
| 🟢 MEDIUM | 함수 50줄 이하 | 코드 리뷰 |
| 🟢 MEDIUM | console.log 없음 (프로덕션) | `grep -r "console.log" src/` |

---

## 차원 2 — 평가 무결성 (Assessment Integrity) 🔴

교육 시스템의 신뢰도와 직결. 위반 시 즉시 커밋 차단.

### 총괄평가 관련

| 심각도 | 항목 | 측정 방법 |
|---|---|---|
| 🔴 CRITICAL | API 응답에 `isCorrect` 미포함 | `grep -r "isCorrect.*true" src/` — 없어야 함 |
| 🔴 CRITICAL | API 응답에 `correctAnswerId` 미포함 | `grep -r "correctAnswerId" src/` — 없어야 함 |
| 🔴 CRITICAL | 채점 로직이 서버에만 존재 | API route 파일에만 채점 코드 확인 |
| 🟡 HIGH | `quiz.type` 필드 존재 (`FORMATIVE` or `SUMMATIVE`) | DB 스키마 + API 응답 확인 |
| 🟡 HIGH | 총괄평가 `maxAttempts === 1` | Quiz 설정 확인 |
| 🟡 HIGH | 시드 기반 문항 랜덤화 구현 | `shuffleWithSeed(array, studentId + quizId)` 패턴 확인 |
| 🟡 HIGH | 응시 중 이탈 시 자동 저장 | 세션 복구 로직 확인 |

### 형성평가 관련

| 심각도 | 항목 | 측정 방법 |
|---|---|---|
| 🟡 HIGH | 형성평가 `maxAttempts === null` (무제한) | Quiz 설정 확인 |
| 🟡 HIGH | 형성평가 `showAnswerAfter === "IMMEDIATELY"` | Quiz 설정 확인 |
| 🟡 HIGH | 오답 즉시 피드백 + 힌트 제공 | UI 확인 |
| 🟡 HIGH | 재시도 버튼 항상 표시 | UI 컴포넌트 확인 |

### 성적 감사

| 심각도 | 항목 | 측정 방법 |
|---|---|---|
| 🟡 HIGH | 성적 변경 시 GradeAuditLog 생성 | `updateGrade()` 함수에 auditLog.create 존재 확인 |
| 🟢 MEDIUM | 응시 시 문항 버전 기록 | `Progress.questionVersion` 필드 저장 확인 |
| 🟢 MEDIUM | 문항 직접 수정 금지 — 버전 생성 패턴 | `question.update()` 대신 `questionVersion.create()` 확인 |

---

## 차원 3 — 심리 안전 (Psychological Safety) 🎓

학생의 학습 의욕과 자존감에 직접 영향. `docs/education-principles.md` 섹션 4 기준.

| 심각도 | 항목 | 측정 방법 |
|---|---|---|
| 🟡 HIGH | "틀렸습니다" 문자열 없음 | `grep -r "틀렸습니다" src/` — 없어야 함 |
| 🟡 HIGH | "오답입니다" 문자열 없음 | `grep -r "오답입니다" src/` — 없어야 함 |
| 🟡 HIGH | "실패" 단독 표시 없음 | 오답 피드백 UI 검토 |
| 🟡 HIGH | 진도 표시가 성장 중심 | "아직 N개 남았습니다" ❌ → "N개 완료!" ✅ |
| 🟢 MEDIUM | 격려 메시지 사용 | "아직 아니에요", "다시 도전해봐요" 등 |
| 🟢 MEDIUM | 오류 메시지가 수정 방법 안내 | "오류 발생" ❌ → "다시 시도하거나 [방법]을 확인하세요" ✅ |
| 🟢 MEDIUM | 반 평균 비교 표시 없음 | 학습 대시보드 UI 확인 |
| 🟢 MEDIUM | 재시도 횟수 카운터 미표시 (형성평가) | UI 확인 |

---

## 차원 4 — 접근성 (Accessibility WCAG 2.1 AA)

2026년 4월 법적 의무. `docs/wcag-checklist.md` 전체 기준 참조.

| 심각도 | 항목 | 측정 방법 |
|---|---|---|
| 🟡 HIGH | 모든 `<img>`에 `alt` 속성 | `grep -r "<img" src/` → `alt` 없는 것 확인 |
| 🟡 HIGH | 버튼/링크에 텍스트 또는 `aria-label` | 아이콘 전용 버튼 확인 |
| 🟡 HIGH | 색상 대비 일반 텍스트 4.5:1 이상 | 디자인 시스템 색상 확인 |
| 🟡 HIGH | 키보드로 모든 기능 이용 가능 | Tab키 테스트 |
| 🟡 HIGH | 색상만으로 정보 전달 ❌ | 오류/성공 상태에 아이콘/텍스트 병행 |
| 🟢 MEDIUM | 폼 입력에 `<label>` 연결 | `htmlFor` 속성 확인 |
| 🟢 MEDIUM | 포커스 시각적 표시 | `:focus-visible` 스타일 확인 |
| 🟢 MEDIUM | 인터랙티브 요소 최소 44×44px | CSS 확인 |
| 🟢 MEDIUM | 동영상 자막 제공 | `<video>` 태그 → `<track kind="captions">` 확인 |
| 🟢 MEDIUM | 화면 판독기 논리적 순서 | DOM 구조 확인 |

---

## 차원 5 — 데이터 보호 (Data Privacy)

한국 개인정보보호법 + 미성년자 특별 규정. `docs/education-principles.md` 섹션 5 기준.

| 심각도 | 항목 | 측정 방법 |
|---|---|---|
| 🔴 CRITICAL | 비밀 정보 하드코딩 없음 | `grep -rE "apiKey|password|secret.*=.*['\"]" src/` |
| 🔴 CRITICAL | 학생 데이터 제3자 전송 코드 없음 | 외부 API 호출 코드 확인 |
| 🟡 HIGH | 만 14세 미만 보호자 동의 분기 존재 | 회원가입 플로우 확인 |
| 🟡 HIGH | 불필요한 개인정보 필드 없음 (최소 수집) | DB 스키마 확인 |
| 🟡 HIGH | 환경 변수로 민감 정보 관리 | `process.env.*` 패턴 확인 |
| 🟢 MEDIUM | 오류 메시지에 민감 정보 미포함 | catch 블록 오류 메시지 확인 |
| 🟢 MEDIUM | 학생 ID가 URL에 노출 최소화 | API 라우트 패턴 확인 |

---

## 차원 6 — 성능 (Performance)

교육 현장의 다양한 네트워크 환경 고려.

| 심각도 | 항목 | 측정 방법 |
|---|---|---|
| 🟡 HIGH | LCP(최대 콘텐츠풀 페인트) 2.5초 이하 | Lighthouse 측정 또는 목표 설정 |
| 🟢 MEDIUM | 이미지/동영상 CDN 경유 | `src` URL 패턴 확인 |
| 🟢 MEDIUM | 불필요한 리렌더링 없음 | React DevTools 또는 코드 리뷰 |
| 🟢 MEDIUM | 코드 스플리팅 적용 | Next.js dynamic import 또는 React.lazy 확인 |
| 🟢 MEDIUM | 모바일 반응형 768px, 480px | 브라우저 개발자 도구 확인 |

---

## 검증 점수 계산

```
CRITICAL 항목 중 실패 개수 = C_fail
HIGH 항목 통과율 = H_pass / H_total × 100%
MEDIUM 항목 통과율 = M_pass / M_total × 100%

최종 판정:
  APPROVED   → C_fail = 0 AND H_pass율 = 100% AND M_pass율 ≥ 80%
  CONDITIONAL → C_fail = 0 AND H_pass율 = 100% AND M_pass율 < 80%
               (MEDIUM 미통과 항목 다음 스프린트 기술 부채로 기록)
  REJECTED   → C_fail > 0 OR H_pass율 < 100%
```

---

## 루브릭 진화 프로세스

> 루브릭은 한 번 만들고 끝나는 문서가 아닙니다.
> objective-loop이 돌면서 루브릭 자체도 고도화됩니다.

### 루브릭이 진화해야 하는 상황

| 상황 | 예시 | 처리 |
|------|------|------|
| grep 우회 패턴 발견 | "틀렸습니다" → "틀린 것 같네요"로 통과 | 패턴 목록 확장 |
| proxy 타당성 의심 | 버튼 DOM 존재 ≠ 실제 클릭 작동 | 조건 강화 |
| 새 교육 패턴 발견 | 루프 중 반복적으로 같은 문제 발생 | 새 항목 추가 |
| 역효과 관찰 | 점수는 올랐는데 실제 UX 나빠짐 | 항목 재설계 |

### 루브릭 변경 원칙

```
코드 변경   → AI가 자율 결정 (objective-loop 내에서)
rubric 변경 → 반드시 사람이 검토·승인
```

이것이 Goodhart's Law를 방어하는 핵심 메커니즘입니다.
AI는 rubric을 최적화하는 방향으로 탐색하므로,
rubric이 실제 목표를 정확히 반영해야만 올바른 방향으로 수렴합니다.

### 루브릭 버전 관리

루브릭을 변경할 때마다 git 커밋으로 기록하세요:

```bash
git add docs/verification-rubric.md
git commit -m "harness-evolve: rubric [항목명] 강화

변경 이유: [Goodhart's Law 우회 패턴 발견 / 새 교육 패턴 / proxy 타당성]
변경 전: [기존 항목]
변경 후: [새 항목]
발견 경위: objective-loop N회차 루브릭 건강 검사"
```

이 커밋 히스토리가 **하네스의 진화 기록**이자
미래 모델 학습의 **데이터**가 됩니다.

---

## 검증 보고서 형식

```
검증 결과: [기능명]
날짜: YYYY-MM-DD
검증자: [Reviewer 에이전트 또는 사람 이름]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
차원 1. 기술 검증       ✅ PASS  (HIGH 3/3, MEDIUM 4/5)
차원 2. 평가 무결성     ✅ PASS  (CRITICAL 3/3, HIGH 5/5)
차원 3. 심리 안전       🟡 WARN  (HIGH 3/4 — 재시도 횟수 카운터 발견)
차원 4. 접근성          ✅ PASS  (HIGH 5/5, MEDIUM 7/8)
차원 5. 데이터 보호     ✅ PASS  (CRITICAL 2/2, HIGH 3/3)
차원 6. 성능            🟡 WARN  (HIGH 0/1 — LCP 3.2초 → 개선 필요)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
최종: CONDITIONAL (HIGH 미통과 1개 — LCP 수정 후 재검증)

🔴 즉시 수정 필요:
  없음

🟡 HIGH 미통과 항목:
  - [차원 6] LCP 3.2초 → 목표 2.5초 이하 (이미지 최적화 필요)
  - [차원 3] 재시도 횟수 카운터 표시 → 형성평가에서 제거 필요

기술 부채 등록 (MEDIUM):
  - [차원 1] console.log 2개 발견 — 다음 스프린트 제거
```
