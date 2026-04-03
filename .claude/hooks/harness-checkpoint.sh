#!/usr/bin/env bash
# harness-checkpoint.sh — Level 2 자기 복구: git stash 기반 체크포인트 & 롤백
#
# 사용법:
#   bash .claude/hooks/harness-checkpoint.sh checkpoint [label]
#   bash .claude/hooks/harness-checkpoint.sh restore
#   bash .claude/hooks/harness-checkpoint.sh list
#   bash .claude/hooks/harness-checkpoint.sh clear
#
# 하네스 엔지니어링 Level 2 자기 복구:
#   Level 1: 오류 컨텍스트 확인 후 재시도 (execution-loop)
#   Level 2: 마지막 체크포인트로 롤백 → 다른 전략으로 재시도 ← 이 스크립트
#
# 권장 사용 시점:
#   - edu-harness 단계 3 (BUILD) 시작 전
#   - 3개 이상 파일에 영향을 미치는 변경 전
#   - execution-loop 시작 전

CMD=${1:-list}
LABEL=${2:-"checkpoint-$(date +%H%M%S)"}
CHECKPOINT_FILE=".harness-checkpoint"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

case "$CMD" in

  checkpoint)
    # 변경 사항이 있는지 확인
    CHANGES=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')

    if [ "$CHANGES" -eq 0 ]; then
      echo "  ℹ️  harness-checkpoint: 변경 사항 없음 — 체크포인트 생성 불필요"
      exit 0
    fi

    # git stash에 저장
    STASH_MSG="harness-checkpoint: $LABEL ($DATE)"
    git stash push -u -m "$STASH_MSG" 2>/dev/null
    STASH_EXIT=$?

    if [ $STASH_EXIT -eq 0 ]; then
      # 체크포인트 메타데이터 저장
      STASH_REF=$(git stash list 2>/dev/null | head -1 | cut -d: -f1)
      echo "$DATE | $STASH_REF | $LABEL" >> "$CHECKPOINT_FILE"

      echo ""
      echo "  ✅ 체크포인트 저장 완료"
      echo "  📌 라벨: $LABEL"
      echo "  📦 stash: $STASH_REF"
      echo "  📋 변경 파일: $CHANGES개"
      echo ""
      echo "  롤백하려면: bash .claude/hooks/harness-checkpoint.sh restore"
    else
      echo "  ❌ 체크포인트 저장 실패 — git stash 오류"
      exit 1
    fi
    ;;

  restore)
    # 마지막 체크포인트 복원
    if [ ! -f "$CHECKPOINT_FILE" ] || [ ! -s "$CHECKPOINT_FILE" ]; then
      echo "  ⚠️  저장된 체크포인트 없음"
      exit 0
    fi

    LAST=$(tail -1 "$CHECKPOINT_FILE")
    LAST_LABEL=$(echo "$LAST" | cut -d'|' -f3 | tr -d ' ')
    LAST_STASH=$(echo "$LAST" | cut -d'|' -f2 | tr -d ' ')

    echo ""
    echo "  ⏪ 체크포인트 복원 중..."
    echo "  📌 대상: $LAST_LABEL"
    echo "  📦 stash: $LAST_STASH"
    echo ""

    # 현재 변경사항 경고
    CURRENT_CHANGES=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    if [ "$CURRENT_CHANGES" -gt 0 ]; then
      echo "  ⚠️  현재 $CURRENT_CHANGES개 변경 사항이 있습니다."
      echo "  이 변경사항은 복원 시 유실될 수 있습니다."
      echo "  계속하려면 체크포인트를 먼저 만드세요:"
      echo "  bash .claude/hooks/harness-checkpoint.sh checkpoint 'before-restore'"
    fi

    git stash pop 2>/dev/null
    if [ $? -eq 0 ]; then
      # 마지막 줄 제거
      python3 -c "
import sys
path = '$CHECKPOINT_FILE'
with open(path, 'r') as f:
    lines = f.readlines()
if lines:
    with open(path, 'w') as f:
        f.writelines(lines[:-1])
" 2>/dev/null
      echo "  ✅ 복원 완료: $LAST_LABEL"
    else
      echo "  ❌ 복원 실패 — git stash pop 오류"
      echo "  수동 확인: git stash list"
      exit 1
    fi
    ;;

  list)
    echo ""
    echo "  📋 하네스 체크포인트 목록"
    echo "  =========================="
    if [ ! -f "$CHECKPOINT_FILE" ] || [ ! -s "$CHECKPOINT_FILE" ]; then
      echo "  (저장된 체크포인트 없음)"
    else
      echo ""
      while IFS= read -r line; do
        echo "  • $line"
      done < "$CHECKPOINT_FILE"
      echo ""
      echo "  git stash 전체 목록: git stash list"
    fi
    echo ""
    ;;

  clear)
    if [ -f "$CHECKPOINT_FILE" ]; then
      rm "$CHECKPOINT_FILE"
      echo "  ✅ 체크포인트 메타데이터 초기화 완료 (git stash는 유지됨)"
    else
      echo "  ℹ️  초기화할 체크포인트 없음"
    fi
    ;;

  *)
    echo "  사용법: bash .claude/hooks/harness-checkpoint.sh [checkpoint|restore|list|clear] [label]"
    echo ""
    echo "  명령:"
    echo "    checkpoint [label]  — 현재 상태를 체크포인트로 저장"
    echo "    restore             — 마지막 체크포인트로 롤백"
    echo "    list                — 체크포인트 목록 표시"
    echo "    clear               — 체크포인트 메타데이터 초기화"
    exit 1
    ;;
esac
