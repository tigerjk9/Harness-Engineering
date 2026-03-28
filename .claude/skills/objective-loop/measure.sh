#!/usr/bin/env bash
# EduHarness measure.sh — objective-loop 점수 측정 및 delta 계산
#
# 사용법:
#   bash .claude/skills/objective-loop/measure.sh baseline [label]
#   bash .claude/skills/objective-loop/measure.sh check    [label]
#
# baseline: 현재 점수를 기준점으로 저장 (.objective-baseline)
# check:    현재 점수 측정 후 기준점과 비교, delta 출력
#
# 출력 파일: objective-loop-log.md (자동 생성)

MODE=${1:-check}
LABEL=${2:-"측정"}
LOG="objective-loop-log.md"
BASELINE_FILE=".objective-baseline"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# verify.sh 실행하여 현재 점수 획득
RAW=$(bash "$SCRIPT_DIR/../verify/verify.sh" 2>/dev/null)
SCORE=$(echo "$RAW" | grep -oE 'SCORE=[0-9]+' | cut -d= -f2)
VERDICT=$(echo "$RAW" | grep -oE 'VERDICT=[A-Z]+' | cut -d= -f2)
C_FAIL=$(echo "$RAW" | grep -oE 'CRITICAL_FAIL=[0-9]+' | cut -d= -f2)
HIGH=$(echo "$RAW" | grep -oE 'HIGH=[0-9]+/[0-9]+' | cut -d= -f2)
MED=$(echo "$RAW" | grep -oE 'MEDIUM=[0-9]+/[0-9]+' | cut -d= -f2)

[ -z "$SCORE" ]   && SCORE=0
[ -z "$VERDICT" ] && VERDICT=UNKNOWN

# 로그 파일 초기화 (없을 때만)
if [ ! -f "$LOG" ]; then
  printf "# objective-loop 측정 기록\n\n" > "$LOG"
fi

if [ "$MODE" = "baseline" ]; then
  # ── 기준점 저장 ───────────────────────────────────────────────
  echo "$SCORE" > "$BASELINE_FILE"
  printf "\n---\n## 기준점: %s\n**날짜**: %s  \n**점수**: %s  \n**판정**: %s  \n**상세**: CRITICAL=%s HIGH=%s MEDIUM=%s\n" \
    "$LABEL" \
    "$(date '+%Y-%m-%d %H:%M')" \
    "$SCORE" \
    "$VERDICT" \
    "$C_FAIL" "$HIGH" "$MED" >> "$LOG"

  echo ""
  echo "┌─────────────────────────────────────────┐"
  echo "│  기준점 저장 완료                         │"
  echo "├─────────────────────────────────────────┤"
  printf "│  SCORE   : %-30s│\n" "$SCORE"
  printf "│  VERDICT : %-30s│\n" "$VERDICT"
  printf "│  상세    : CRITICAL=%s HIGH=%s MED=%s\n" "$C_FAIL" "$HIGH" "$MED"
  echo "└─────────────────────────────────────────┘"
  echo "  파일: $BASELINE_FILE"

else
  # ── 현재 측정 + delta 계산 ─────────────────────────────────────
  BASELINE=$(cat "$BASELINE_FILE" 2>/dev/null || echo "0")
  DELTA=$((SCORE - BASELINE))
  [ $DELTA -ge 0 ] && SIGN="+" || SIGN=""

  # 방향 이모지
  if   [ $DELTA -gt 0 ]; then ARROW="↑ 개선"
  elif [ $DELTA -lt 0 ]; then ARROW="↓ 악화"
  else ARROW="→ 변화 없음"
  fi

  printf "\n---\n## %s\n**날짜**: %s  \n**점수**: %s (delta: %s%s)  \n**판정**: %s  \n**상세**: CRITICAL=%s HIGH=%s MEDIUM=%s\n" \
    "$LABEL" \
    "$(date '+%Y-%m-%d %H:%M')" \
    "$SCORE" "$SIGN" "$DELTA" \
    "$VERDICT" \
    "$C_FAIL" "$HIGH" "$MED" >> "$LOG"

  echo ""
  echo "┌─────────────────────────────────────────┐"
  echo "│  objective-loop 측정 결과                 │"
  echo "├─────────────────────────────────────────┤"
  printf "│  현재 점수  : %-28s│\n" "$SCORE"
  printf "│  기준점     : %-28s│\n" "$BASELINE"
  printf "│  delta      : %s%s (%s)%-*s│\n" "$SIGN" "$DELTA" "$ARROW" $((20 - ${#DELTA} - ${#ARROW})) ""
  printf "│  판정       : %-28s│\n" "$VERDICT"
  echo "└─────────────────────────────────────────┘"

  # delta = 0 경고
  if [ "$DELTA" -eq 0 ]; then
    echo ""
    echo "  ⚠️  delta = 0: 탐색 공간 전환을 고려하세요."
    echo "     현재 접근법으로는 점수가 오르지 않고 있습니다."
  fi
fi

echo ""
echo "  로그: $LOG"
