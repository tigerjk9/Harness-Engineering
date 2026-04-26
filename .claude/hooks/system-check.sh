#!/usr/bin/env bash
# system-check.sh — EduHarness 환경 진단
#
# openclaude scripts/system-check.ts 패턴을 bash로 구현.
# 워크플로우 시작 전 하네스가 실행 가능한 환경인지 검증합니다.
#
# 사용법:
#   bash .claude/hooks/system-check.sh          # 전체 진단 (상세 출력)
#   bash .claude/hooks/system-check.sh --brief  # 한 줄 요약 (settings.json 훅용)
#
# Exit code:
#   0 — 모두 통과 또는 경고만 있음 (진행 가능)
#   1 — FAIL 항목 있음 (진행 불가 권장)

BRIEF=false
VERBOSE=false
for _a in "$@"; do
  case "$_a" in
    --brief)   BRIEF=true ;;
    --verbose) VERBOSE=true ;;
  esac
done

PASS=0; FAIL=0; WARN=0

# ── 출력 헬퍼 ─────────────────────────────────────────────────────
# brief:   요약 한 줄만 (훅용)
# default: WARN + FAIL만 표시 (조용한 기본값)
# verbose: 전체 (✅ 포함)
check_pass() { $VERBOSE && echo "  ✅ $1"; PASS=$((PASS+1)); }
check_fail() { echo "  ❌ $1 — $2"; FAIL=$((FAIL+1)); }
check_warn() { $BRIEF || echo "  ⚠️  $1 — $2"; WARN=$((WARN+1)); }

$BRIEF || echo ""
$BRIEF || echo "🔧 EduHarness 환경 진단"
$BRIEF || echo "========================"

# ── 런타임 환경 ───────────────────────────────────────────────────
node -e "if(parseInt(process.version.slice(1))<18)process.exit(1)" 2>/dev/null \
  && check_pass "Node.js v18+" \
  || check_fail "Node.js v18+" "node --version 으로 확인 (v18 이상 필요)"

command -v npm &>/dev/null \
  && check_pass "npm" \
  || check_fail "npm" "npm 설치 필요"

command -v git &>/dev/null \
  && check_pass "git" \
  || check_fail "git" "git 설치 필요"

# ── 하네스 핵심 파일 ──────────────────────────────────────────────
[ -f "CLAUDE.md" ] \
  && check_pass "CLAUDE.md (헌법)" \
  || check_fail "CLAUDE.md" "헌법 파일 없음 — harness-init 먼저 실행"

[ -f ".claude/skills/verify/verify.sh" ] \
  && check_pass "verify.sh" \
  || check_fail "verify.sh" "하네스 스킬 없음"

[ -f "architecture.md" ] \
  && check_pass "architecture.md" \
  || check_warn "architecture.md" "아키텍처 문서 없음 (선택사항)"

[ -f "progress.md" ] \
  && check_pass "progress.md" \
  || check_warn "progress.md" "진행 상태 문서 없음 (선택사항)"

# ── CLAUDE.md 완성도 체크 ─────────────────────────────────────────
if [ -f "CLAUDE.md" ]; then
  if grep -q "\[YOUR_PROJECT_NAME\]\|\[YOUR_DEV_COMMAND\]\|\[YOUR_TEST_COMMAND\]" CLAUDE.md 2>/dev/null; then
    check_warn "CLAUDE.md 완성도" "[대괄호] 플레이스홀더 항목이 남아 있습니다"
  else
    check_pass "CLAUDE.md 완성도"
  fi
fi

# ── 프로젝트 설정 (package.json 있을 때만) ───────────────────────
if [ -f "package.json" ]; then
  grep -q '"lint"' package.json 2>/dev/null \
    && check_pass "npm run lint 스크립트" \
    || check_warn "npm run lint" "package.json에 lint 스크립트 없음 — verify --full 시 건너뜀"

  grep -q '"test"' package.json 2>/dev/null \
    && check_pass "npm test 스크립트" \
    || check_warn "npm test" "package.json에 test 스크립트 없음 — verify --full 시 건너뜀"

  [ -f "tsconfig.json" ] \
    && check_pass "tsconfig.json" \
    || check_warn "tsconfig.json" "TypeScript 설정 없음 — verify --full tsc 건너뜀"
else
  check_warn "package.json" "아직 없음 — npm init 후 사용 권장"
fi

# ── git hooks ─────────────────────────────────────────────────────
[ -f ".husky/pre-commit" ] \
  && check_pass ".husky/pre-commit" \
  || check_warn "pre-commit hook" "npx husky init 필요 (커밋 자동 검증 비활성화 상태)"

# ── 하네스 진화 문서 ────────────────────────────────────────────────
[ -f "HARNESS_CHANGELOG.md" ] \
  && check_pass "HARNESS_CHANGELOG.md" \
  || check_warn "HARNESS_CHANGELOG.md" "하네스 진화 기록 없음 — /edu-harness 완료 후 자동 생성"

[ -f "AGENTS.md" ] \
  && check_pass "AGENTS.md" \
  || check_warn "AGENTS.md" "에이전트 역할 분리 문서 없음"

[ -f "docs/verification-rubric.md" ] \
  && check_pass "docs/verification-rubric.md" \
  || check_warn "docs/verification-rubric.md" "검증 루브릭 없음 (docs/ 폴더 확인)"

# ── git 사용자 설정 ───────────────────────────────────────────────
GIT_NAME=$(git config user.name 2>/dev/null)
GIT_EMAIL=$(git config user.email 2>/dev/null)
if [ -n "$GIT_NAME" ] && [ -n "$GIT_EMAIL" ]; then
  check_pass "git 사용자 설정 ($GIT_NAME)"
else
  check_warn "git 사용자 설정" "git config user.name/email 설정 필요"
fi

# ── v6.0 신규 하네스 컴포넌트 검사 ────────────────────────────────
if [ -f "progress.md" ]; then
  grep -q "컨텍스트 앵커" progress.md 2>/dev/null \
    && check_pass "progress.md 컨텍스트 앵커 섹션" \
    || check_warn "progress.md 컨텍스트 앵커" "'## 컨텍스트 앵커' 섹션 없음 — 컨텍스트 전환 추적 비활성"
fi

[ -f "docs/harness-audit.md" ] \
  && check_pass "docs/harness-audit.md (분기별 감사)" \
  || check_warn "docs/harness-audit.md" "분기별 하네스 감사 체크리스트 없음"

[ -f "docs/decision-log.md" ] \
  && check_pass "docs/decision-log.md (ADR 기록)" \
  || check_warn "docs/decision-log.md" "아키텍처 결정 기록 없음 (docs/ 폴더 확인)"

if [ -f "AGENTS.md" ]; then
  grep -q "Evaluator" AGENTS.md 2>/dev/null \
    && check_pass "AGENTS.md Evaluator 역할" \
    || check_warn "AGENTS.md Evaluator" "Generator-Evaluator 패턴 미적용 — Goodhart's Law 방어 없음"
fi

# ── verify.sh 실행 가능 여부 ──────────────────────────────────────
if [ -f ".claude/skills/verify/verify.sh" ]; then
  bash .claude/skills/verify/verify.sh --check-only 2>/dev/null | grep -q "VERDICT=OK" \
    && check_pass "verify.sh 실행 테스트" \
    || check_fail "verify.sh 실행" "bash .claude/skills/verify/verify.sh 직접 실행으로 오류 확인"
fi

# ── 결과 출력 ─────────────────────────────────────────────────────
$BRIEF || echo ""
$BRIEF || echo "========================"

TOTAL=$((PASS + FAIL + WARN))
if [ $FAIL -gt 0 ]; then
  echo "  🔧 system-check: ✅$PASS / ❌$FAIL / ⚠️$WARN ($TOTAL개 항목) — 실패 항목 해결 후 사용 권장"
  $BRIEF || echo "  → docs/harness-guide.ko.md 를 참조하세요"
  exit 1
elif [ $WARN -gt 0 ]; then
  echo "  🔧 system-check: ✅$PASS / ⚠️$WARN ($TOTAL개 항목) — 경고 항목은 선택 해결"
else
  echo "  🔧 system-check: ✅$PASS/$TOTAL — 하네스 준비 완료 🚀"
fi
