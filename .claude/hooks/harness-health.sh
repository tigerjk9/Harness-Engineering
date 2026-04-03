#!/usr/bin/env bash
# harness-health.sh — EduHarness 전체 상태 대시보드
#
# 하네스의 모든 핵심 상태를 단일 명령으로 확인합니다.
#
# 사용법:
#   bash .claude/hooks/harness-health.sh

echo ""
echo "🩺 EduHarness Health Dashboard"
echo "================================"

# ── 1. verify.sh 현재 점수 ────────────────────────────────────────
echo ""
echo "📊 VERIFY"
VERIFY_OUT=$(bash .claude/skills/verify/verify.sh 2>/dev/null)
SCORE=$(echo "$VERIFY_OUT" | grep -oE 'SCORE=[0-9]+' | cut -d= -f2)
VERDICT=$(echo "$VERIFY_OUT" | grep -oE 'VERDICT=[A-Z]+' | cut -d= -f2)
HIGH=$(echo "$VERIFY_OUT" | grep -oE 'HIGH=[0-9]+/[0-9]+' | cut -d= -f2)
MEDIUM=$(echo "$VERIFY_OUT" | grep -oE 'MEDIUM=[0-9]+/[0-9]+' | cut -d= -f2)

case "$VERDICT" in
  APPROVED)    VERDICT_ICON="✅" ;;
  CONDITIONAL) VERDICT_ICON="⚠️ " ;;
  REJECTED)    VERDICT_ICON="❌" ;;
  *)           VERDICT_ICON="❓" ;;
esac
echo "  $VERDICT_ICON VERDICT=$VERDICT  SCORE=$SCORE  HIGH=$HIGH  MEDIUM=$MEDIUM"

# ── 2. system-check.sh 요약 ───────────────────────────────────────
echo ""
echo "🔧 SYSTEM CHECK"
SC_OUT=$(bash .claude/hooks/system-check.sh --brief 2>/dev/null | grep "system-check:")
echo "  $SC_OUT"

# ── 3. checkpoint 상태 ────────────────────────────────────────────
echo ""
echo "💾 CHECKPOINT"
if [ -f ".harness-checkpoint" ]; then
  CHECKPOINT_COUNT=$(wc -l < .harness-checkpoint 2>/dev/null | tr -d ' ')
  LAST_CP=$(tail -1 .harness-checkpoint 2>/dev/null | cut -d'|' -f3 | tr -d ' ')
  echo "  ✅ 체크포인트 ${CHECKPOINT_COUNT}개 저장됨  |  마지막: ${LAST_CP:-없음}"
else
  echo "  ℹ️  체크포인트 없음 (.harness-checkpoint 미존재)"
fi

# ── 4. execution-loop 상태 ────────────────────────────────────────
echo ""
echo "🔄 LOOP STATE"
if [ -f ".execution-loop-state" ]; then
  LOOP_STATE=$(cat .execution-loop-state 2>/dev/null)
  echo "  📍 $LOOP_STATE"
else
  echo "  ℹ️  루프 없음 (새 세션 대기 중)"
fi

# ── 5. measure.sh 최근 delta 트렌드 ──────────────────────────────
echo ""
echo "📈 DELTA TREND"
if [ -f "objective-loop-log.md" ]; then
  RECENT=$(grep -oE 'delta: [+\-][0-9]+' objective-loop-log.md 2>/dev/null | tail -5)
  if [ -n "$RECENT" ]; then
    DELTA_LIST=$(echo "$RECENT" | tr '\n' ' ')
    echo "  최근 5회: $DELTA_LIST"
  else
    echo "  ℹ️  delta 기록 없음"
  fi
else
  echo "  ℹ️  objective-loop-log.md 없음"
fi

# ── 6. HARNESS_CHANGELOG 통계 ─────────────────────────────────────
echo ""
echo "📜 HARNESS CHANGELOG"
if [ -f "HARNESS_CHANGELOG.md" ]; then
  RULE_COUNT=$(grep -c "^| 20" HARNESS_CHANGELOG.md 2>/dev/null || echo 0)
  LAST_DATE=$(grep "^| 20" HARNESS_CHANGELOG.md 2>/dev/null | tail -1 | cut -d'|' -f2 | tr -d ' ')
  echo "  총 규칙 추가: ${RULE_COUNT}개  |  마지막 추가: ${LAST_DATE:-없음}"
else
  echo "  ℹ️  HARNESS_CHANGELOG.md 없음"
fi

# ── 7. progress.md 앵커 상태 ──────────────────────────────────────
echo ""
echo "⚓ CONTEXT ANCHOR"
if [ -f "progress.md" ] && grep -q "컨텍스트 앵커" progress.md 2>/dev/null; then
  INTENT=$(grep -A5 "^\*\*intent\*\*" progress.md 2>/dev/null | head -1 | sed 's/.*| //' | cut -c1-60)
  if [ -n "$INTENT" ] && [ "$INTENT" != "[이번 세션의 목적" ]; then
    echo "  ✅ 앵커 설정됨: $INTENT"
  else
    echo "  ⚠️  앵커 섹션은 있으나 아직 작성 전 (템플릿 상태)"
  fi
else
  echo "  ❌ progress.md에 앵커 섹션 없음"
fi

# ── 요약 ──────────────────────────────────────────────────────────
echo ""
echo "================================"
echo "  💡 세션 시작 전: progress.md → architecture.md 순으로 읽으세요"
echo ""
