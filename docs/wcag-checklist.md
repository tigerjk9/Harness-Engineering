# WCAG 2.1 접근성 체크리스트

> 공공 교육기관은 2026년 4월부터 WCAG 2.1 AA 준수가 법적 의무입니다.
> 이 체크리스트를 AI 에이전트에게 제공하거나 직접 점검에 활용하세요.

---

## 빠른 점검 (5가지 핵심)

배포 전 최소한 이것만은 확인하세요:

- [ ] **이미지 alt 텍스트**: 모든 `<img>`에 의미 있는 `alt` 속성
- [ ] **색상 대비**: 텍스트와 배경의 색상 대비 4.5:1 이상
- [ ] **키보드 내비게이션**: Tab키로 모든 기능 이용 가능
- [ ] **폼 레이블**: 모든 입력 필드에 `<label>` 연결
- [ ] **오류 메시지**: 오류 내용과 수정 방법을 명확하게 안내

---

## 1. 인지 가능성 (Perceivable)

### 1.1 텍스트 대안
- [ ] 의미 있는 이미지: `alt="설명적인 내용"` 제공
- [ ] 장식용 이미지: `alt=""` (빈 문자열)
- [ ] 복잡한 이미지(차트, 그래프): 긴 설명 (`longdesc` 또는 인접 텍스트)
- [ ] 아이콘 버튼: `aria-label` 또는 숨김 텍스트 제공

```html
<!-- ✅ 올바름 -->
<img src="quiz-icon.png" alt="퀴즈 시작" />
<button aria-label="학생 삭제">🗑️</button>

<!-- ❌ 잘못됨 -->
<img src="quiz-icon.png" />
<button>🗑️</button>
```

### 1.2 시간 기반 미디어
- [ ] 동영상: 자막(CC) 제공
- [ ] 오디오: 텍스트 스크립트 제공
- [ ] 라이브 동영상: 실시간 자막 제공

### 1.3 색상 대비

| 텍스트 유형 | 최소 대비율 |
|-------------|------------|
| 일반 텍스트 (18pt 미만) | **4.5:1** |
| 큰 텍스트 (18pt 이상, 또는 볼드 14pt 이상) | **3:1** |
| UI 컴포넌트, 그래픽 | **3:1** |

도구: [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)

```css
/* ✅ 좋은 예 — 흰 배경에 진한 텍스트 */
color: #1a1a1a; /* 대비율 18.1:1 */

/* ❌ 나쁜 예 — 연한 회색은 대비 부족 */
color: #999999; /* 흰 배경 대비 2.85:1 — 미달 */
```

- [ ] 색상만으로 정보 전달 금지 (예: 빨간색 = 오답)
  - 대신: 색상 + 아이콘 또는 텍스트 함께 사용

---

## 2. 운용 가능성 (Operable)

### 2.1 키보드 접근성
- [ ] 마우스 없이 Tab/Shift+Tab으로 모든 기능 이용 가능
- [ ] 포커스 순서가 논리적 (위→아래, 왼쪽→오른쪽)
- [ ] 포커스 트랩 없음 (모달 제외 — 모달은 트랩 필요)
- [ ] 키보드 단축키 충돌 없음

```html
<!-- ✅ 포커스 표시 유지 (CSS로 숨기지 말 것) -->
:focus {
  outline: 2px solid #005fcc;
  outline-offset: 2px;
}

/* ❌ 금지 */
:focus { outline: none; }
```

### 2.2 포커스 표시
- [ ] 포커스된 요소가 시각적으로 명확히 구분됨
- [ ] 포커스 링이 배경과 3:1 이상 대비

### 2.3 움직이는 콘텐츠
- [ ] 자동 재생 미디어: 5초 이상이면 정지·숨기기 컨트롤 제공
- [ ] 깜빡이는 콘텐츠: 1초에 3번 미만 (광과민성 발작 예방)

---

## 3. 이해 가능성 (Understandable)

### 3.1 언어 명시
- [ ] `<html lang="ko">` (한국어 페이지)
- [ ] 외국어 단어: `lang` 속성으로 언어 명시

```html
<!-- ✅ -->
<html lang="ko">
<p>이것은 <span lang="en">quiz</span>입니다.</p>
```

### 3.2 입력 보조
- [ ] 모든 `<input>`, `<select>`, `<textarea>`에 `<label>` 연결

```html
<!-- ✅ 올바름 -->
<label for="student-name">학생 이름</label>
<input type="text" id="student-name" name="name" />

<!-- ❌ placeholder만으로는 부족 -->
<input type="text" placeholder="학생 이름" />
```

### 3.3 오류 처리
- [ ] 오류 메시지: 무엇이 잘못됐는지 + 어떻게 고치는지 안내
- [ ] 오류 필드: `aria-invalid="true"` + `aria-describedby`로 오류 메시지 연결
- [ ] 중요한 제출(삭제, 결제): 확인 또는 되돌리기 기회 제공

```html
<!-- ✅ 접근 가능한 오류 표시 -->
<label for="email">이메일</label>
<input
  type="email"
  id="email"
  aria-invalid="true"
  aria-describedby="email-error"
/>
<p id="email-error" role="alert">
  올바른 이메일 형식을 입력해주세요. 예: name@school.ac.kr
</p>
```

---

## 4. 견고성 (Robust)

### 4.1 HTML 유효성
- [ ] HTML 유효성 검사 통과: [W3C Validator](https://validator.w3.org/)
- [ ] 중복 ID 없음
- [ ] 태그 올바르게 닫힘

### 4.2 ARIA 올바른 사용
- [ ] ARIA role이 HTML 시맨틱과 충돌하지 않음
- [ ] 필수 ARIA 속성 누락 없음

```html
<!-- ✅ 진도 바 -->
<div
  role="progressbar"
  aria-valuenow="60"
  aria-valuemin="0"
  aria-valuemax="100"
  aria-label="학습 진도 60%"
>
  <div style="width: 60%"></div>
</div>

<!-- ✅ 실시간 알림 -->
<div aria-live="polite" aria-atomic="true">
  <!-- 정답/오답 피드백이 여기에 삽입됨 -->
</div>
```

---

## 교육 컴포넌트별 체크리스트

### 퀴즈/평가

- [ ] 문제 번호와 전체 문항 수 안내: "3번 문제 / 전체 10문제"
- [ ] 선택지: radio 버튼 그룹 + `<fieldset>`/`<legend>`
- [ ] 정답 피드백: `aria-live="polite"` 영역에 표시
- [ ] 타이머: 남은 시간을 텍스트로 표시 + 경고 알림

### 진도 표시

- [ ] `role="progressbar"` + 수치 속성
- [ ] 시각적 표시 + 텍스트 대안: "현재 6/10 레슨 완료"

### 학습 내비게이션

- [ ] 건너뛰기 링크: "본문으로 바로 가기" (페이지 최상단)
- [ ] 현재 위치 표시: `aria-current="page"`
- [ ] 랜드마크: `<main>`, `<nav>`, `<header>`, `<footer>` 사용

```html
<!-- ✅ 건너뛰기 링크 -->
<a href="#main-content" class="skip-link">본문으로 바로 가기</a>
...
<main id="main-content">
```

---

## 자동화 도구

프로젝트에 통합하면 AI 에이전트가 자동으로 접근성을 검증합니다:

```bash
# jest-axe (React 컴포넌트 테스트)
npm install --save-dev jest-axe

# @axe-core/react (개발 모드 실시간 검사)
npm install --save-dev @axe-core/react

# Playwright (E2E 접근성 테스트)
npm install --save-dev @playwright/test
```

```typescript
// jest-axe 사용 예시
import { axe, toHaveNoViolations } from 'jest-axe'
expect.extend(toHaveNoViolations)

test('QuizCard는 접근성 기준을 충족해야 합니다', async () => {
  const { container } = render(<QuizCard question="..." choices={[...]} />)
  const results = await axe(container)
  expect(results).toHaveNoViolations()
})
```

---

## 참고 자료

- [WCAG 2.1 공식 문서](https://www.w3.org/TR/WCAG21/)
- [WebAIM WCAG Checklist](https://webaim.org/standards/wcag/checklist)
- [한국형 웹 콘텐츠 접근성 지침 (KWCAG)](https://www.wah.or.kr:444/Accessibility/define.asp)
- [Deque University](https://dequeuniversity.com/)
