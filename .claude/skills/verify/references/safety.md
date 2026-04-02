# 차원 3-4: 심리 안전 + 접근성

## 차원 3 — 심리 안전 (HIGH)

```bash
# 부정적 피드백 메시지 검사 (확장 패턴)
grep -rln \
  "틀렸습니다\|오답입니다\|실패했습니다\|틀린 것 같\|맞지 않았\|정답이 아니\|오류입니다\|Wrong answer\|Incorrect answer\|You failed\|That.s wrong\|Sorry.*wrong\|Unfortunately.*wrong" \
  src/ --include="*.ts" --include="*.tsx" | grep -v "\.test\.\|__tests__"

# 결핍 중심 진도 메시지 검사
grep -rn "개 남았\|개 남은\|remaining\|not completed\|미완료\|미달성" \
  src/ --include="*.ts" --include="*.tsx" | grep -v "\.test\."
```

체크리스트:
- [ ] 부정적 표현 없음 (grep 결과 0건)
- [ ] 진도: 완료 수 기준 ("3개 완료!" ✅ vs "7개 남음" ❌)
- [ ] 재시도 버튼: 항상 표시 (형성평가)
- [ ] 오답 피드백: 힌트 또는 격려 포함
- [ ] 시간 초과: 격려 표현 ("다음엔 더 잘 할 수 있을 거예요")
- [ ] 재시도 횟수 카운터 미표시 (형성평가)

---

## 차원 4 — 접근성 (HIGH/MEDIUM)

```bash
# alt 없는 img
grep -rn "<img" src/ --include="*.tsx" | grep -v 'alt='

# aria-label 없는 아이콘 버튼
grep -rn "<button" src/ --include="*.tsx" | grep -v "aria-label\|aria-labelledby\|>[^<]"

# 퀴즈: fieldset 없음
grep -rln "Quiz\|quiz\|Question\|question" src/ --include="*.tsx" \
  | grep -v "\.test\." | xargs grep -L "<fieldset" 2>/dev/null

# 피드백: aria-live 없음
grep -rln "feedback\|Feedback\|피드백" src/ --include="*.tsx" \
  | grep -v "\.test\." | xargs grep -L 'aria-live' 2>/dev/null

# 진도바: role="progressbar" 없음
grep -rln "ProgressBar\|progressbar\|progress-bar\|진도" src/ --include="*.tsx" \
  | grep -v "\.test\." | xargs grep -L 'role="progressbar"' 2>/dev/null
```

체크리스트:
- [ ] 모든 `<img>` → alt 존재
- [ ] 아이콘 버튼 → aria-label 존재
- [ ] 퀴즈 컴포넌트 → `<fieldset>` + `<legend>` 구조
- [ ] 피드백 영역 → `aria-live="polite"`
- [ ] 진도바 → `role="progressbar"` + `aria-valuenow/min/max`
- [ ] 색상+아이콘+텍스트 동시 표현 (색상만으로 정보 전달 금지)
- [ ] `:focus-visible` 스타일 존재
- [ ] 키보드로 모든 기능 접근 가능
