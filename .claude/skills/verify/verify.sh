#!/usr/bin/env bash
# EduHarness verify.sh — 6차원 검증 실행 및 점수 출력
# 사용법: bash .claude/skills/verify/verify.sh [src_path]
# 출력:   CRITICAL_FAIL=N HIGH=N/N MEDIUM=N/N SCORE=N VERDICT=X
#
# VERDICT 기준:
#   APPROVED   → CRITICAL_FAIL=0 AND HIGH 100% AND MEDIUM ≥80%
#   CONDITIONAL → CRITICAL_FAIL=0 AND HIGH 100% AND MEDIUM <80%
#   REJECTED   → CRITICAL_FAIL>0 OR HIGH <100%

SRC=${1:-src}
C_FAIL=0; H_PASS=0; H_TOTAL=0; M_PASS=0; M_TOTAL=0

# ── UNIVERSAL 검사 (모든 프로젝트) ──────────────────────────────────
# Dim 2 isCorrect 노출, Dim 5 비밀, Dim 1 console.log, Dim 4 img alt
#
# ── EDU-DOMAIN 검사 (교육 앱만 해당) ────────────────────────────────
# Dim 3 부정적 메시지, Dim 4b fieldset, Dim 4c aria-live, Dim 4d progressbar
# 교육 앱이 아니라면: grep으로 관련 파일이 없어 자동 통과됩니다.

# ── Dimension 2: 평가 무결성 (CRITICAL) ──────────────────────────
# isCorrect 또는 correctAnswerId가 프론트엔드에 노출되면 즉시 실패
H_TOTAL=$((H_TOTAL + 1))
if [ -d "$SRC" ]; then
  LEAK=$(grep -rln "isCorrect.*:.*true\|\"isCorrect\".*true\|correctAnswerId" \
    "$SRC" --include="*.ts" --include="*.tsx" 2>/dev/null \
    | grep -v "\.test\.\|__tests__\|\.spec\.")
  if [ -z "$LEAK" ]; then
    H_PASS=$((H_PASS + 1))
  else
    C_FAIL=$((C_FAIL + 1))
  fi
fi

# ── Dimension 3: 심리 안전 (HIGH) ────────────────────────────────
# 부정적 피드백 메시지 금지
H_TOTAL=$((H_TOTAL + 1))
NEG=$(grep -rln \
  "틀렸습니다\|오답입니다\|실패했습니다\|Wrong answer\|Incorrect answer" \
  "$SRC" --include="*.ts" --include="*.tsx" 2>/dev/null \
  | grep -v "\.test\.\|__tests__\|\.spec\.")
[ -z "$NEG" ] && H_PASS=$((H_PASS + 1))

# ── Dimension 4: 접근성 (HIGH) ────────────────────────────────────
# alt 없는 <img> 태그 검사
H_TOTAL=$((H_TOTAL + 1))
NO_ALT=$(grep -rn "<img" "$SRC" --include="*.tsx" 2>/dev/null \
  | grep -v 'alt=')
[ -z "$NO_ALT" ] && H_PASS=$((H_PASS + 1))

# ── Dimension 5: 데이터 보호 (CRITICAL) ──────────────────────────
# 하드코딩 비밀 정보 검사
if [ -d "$SRC" ]; then
  SECRET=$(grep -rEnl \
    "(apiKey|api_key|password|secret|token)\s*=\s*['\"][^'\"\$\{]{8,}" \
    "$SRC" --include="*.ts" --include="*.tsx" 2>/dev/null \
    | grep -v "\.test\.\|__tests__\|example\|sample\|placeholder\|mock")
  [ -n "$SECRET" ] && C_FAIL=$((C_FAIL + 1))
fi

# ── Dimension 1: 기술 (MEDIUM) ────────────────────────────────────
# console.log 프로덕션 코드 잔류
M_TOTAL=$((M_TOTAL + 1))
CON=$(grep -rln "console\.log" "$SRC" \
  --include="*.ts" --include="*.tsx" 2>/dev/null \
  | grep -v "\.test\.\|__tests__\|\.spec\.")
[ -z "$CON" ] && M_PASS=$((M_PASS + 1))

# [EDU-DOMAIN] Dim 4b HIGH: quiz 컴포넌트에 fieldset 그룹화 없음
# edu-harness 요구사항: QuizCard는 <fieldset>+<legend>로 문제 그룹화
if [ -d "$SRC" ]; then
  H_TOTAL=$((H_TOTAL+1))
  QUIZ_FILES=$(grep -rln "Quiz\|quiz\|Question\|question" "$SRC" --include="*.tsx" 2>/dev/null | grep -v "\.test\.")
  if [ -z "$QUIZ_FILES" ]; then
    H_PASS=$((H_PASS+1))  # 퀴즈 컴포넌트 없음 — 통과
  else
    NO_FIELDSET=$(echo "$QUIZ_FILES" | xargs grep -L "<fieldset" 2>/dev/null | head -3)
    [ -z "$NO_FIELDSET" ] && H_PASS=$((H_PASS+1))
  fi
fi

# [EDU-DOMAIN] Dim 4c HIGH: 피드백 영역에 aria-live 없음
# edu-harness 요구사항: 오답 피드백은 aria-live="polite" 영역 사용
if [ -d "$SRC" ]; then
  H_TOTAL=$((H_TOTAL+1))
  FEEDBACK_FILES=$(grep -rln "feedback\|Feedback\|피드백" "$SRC" --include="*.tsx" 2>/dev/null | grep -v "\.test\.")
  if [ -z "$FEEDBACK_FILES" ]; then
    H_PASS=$((H_PASS+1))  # 피드백 컴포넌트 없음 — 통과
  else
    NO_ARIA=$(echo "$FEEDBACK_FILES" | xargs grep -L 'aria-live' 2>/dev/null | head -3)
    [ -z "$NO_ARIA" ] && H_PASS=$((H_PASS+1))
  fi
fi

# [EDU-DOMAIN] Dim 4d MEDIUM: 진도바에 role="progressbar" 없음
# edu-harness 요구사항: ProgressBar는 role="progressbar" + aria-valuenow
if [ -d "$SRC" ]; then
  M_TOTAL=$((M_TOTAL+1))
  PROGRESS_FILES=$(grep -rln "ProgressBar\|progressbar\|progress-bar\|진도" "$SRC" --include="*.tsx" 2>/dev/null | grep -v "\.test\.")
  if [ -z "$PROGRESS_FILES" ]; then
    M_PASS=$((M_PASS+1))  # 진도바 없음 — 통과
  else
    NO_PB=$(echo "$PROGRESS_FILES" | xargs grep -L 'role="progressbar"' 2>/dev/null | head -3)
    [ -z "$NO_PB" ] && M_PASS=$((M_PASS+1))
  fi
fi

# 함수 50줄 초과 파일 존재 여부 (휴리스틱: 800줄 초과 파일)
M_TOTAL=$((M_TOTAL + 1))
LONG=$(find "$SRC" \( -name "*.ts" -o -name "*.tsx" \) 2>/dev/null \
  | xargs wc -l 2>/dev/null | awk '$1 > 800 {print $2}' | grep -v "total")
[ -z "$LONG" ] && M_PASS=$((M_PASS + 1))

# ── 점수 계산 ─────────────────────────────────────────────────────
# CRITICAL 20점 + HIGH 50점 + MEDIUM 30점
[ $H_TOTAL -gt 0 ] && H_RATE=$((H_PASS * 100 / H_TOTAL)) || H_RATE=100
[ $M_TOTAL -gt 0 ] && M_RATE=$((M_PASS * 100 / M_TOTAL)) || M_RATE=100

H_CONTRIB=$([ $H_TOTAL -gt 0 ] && echo $((H_PASS * 50 / H_TOTAL)) || echo 50)
M_CONTRIB=$([ $M_TOTAL -gt 0 ] && echo $((M_PASS * 30 / M_TOTAL)) || echo 30)
C_CONTRIB=$([ $C_FAIL -eq 0 ] && echo 20 || echo 0)
SCORE=$((C_CONTRIB + H_CONTRIB + M_CONTRIB))

if   [ $C_FAIL -gt 0 ];   then VERDICT=REJECTED
elif [ $H_RATE -lt 100 ]; then VERDICT=REJECTED
elif [ $M_RATE -lt 80 ];  then VERDICT=CONDITIONAL
else VERDICT=APPROVED
fi

echo "CRITICAL_FAIL=${C_FAIL} HIGH=${H_PASS}/${H_TOTAL} MEDIUM=${M_PASS}/${M_TOTAL} SCORE=${SCORE} VERDICT=${VERDICT}"
