#!/usr/bin/env bash
# harness-evolve.sh — CLAUDE.md 변경 감지 → HARNESS_CHANGELOG.md 자동 기록
#
# 사용법:
#   bash .claude/hooks/harness-evolve.sh          # pre-commit에서 자동 호출
#   bash .claude/hooks/harness-evolve.sh --manual  # 수동 실행 (git staged 없이도 동작)
#
# 작동 원리:
#   git diff --cached -- CLAUDE.md 으로 staged 변경 추출
#   추가된 줄(+로 시작)에서 첫 번째 의미 있는 규칙 줄을 파싱
#   HARNESS_CHANGELOG.md 테이블에 자동 추가

MANUAL=false
[ "$1" = "--manual" ] && MANUAL=true

DATE=$(date +%Y-%m-%d)
CHANGELOG="HARNESS_CHANGELOG.md"
TRACK_PATTERN="CLAUDE.md AGENTS.md docs/*.md .claude/skills/verify/verify.sh"

# staged 변경 추출 (추가된 줄만, 메타줄 제외)
if $MANUAL; then
  # 수동 모드: 마지막 커밋과 현재 HEAD 비교
  NEW_LINES=$(git diff HEAD~1 -- $TRACK_PATTERN 2>/dev/null \
    | grep "^+" | grep -v "^+++" \
    | grep -v "^+#\|^+---\|^+$\|^+>\|^+ *$" \
    | sed 's/^+//' \
    | grep -v "^\s*$" \
    | head -5)
else
  # 자동 모드: staged 변경 감지
  NEW_LINES=$(git diff --cached -- $TRACK_PATTERN 2>/dev/null \
    | grep "^+" | grep -v "^+++" \
    | grep -v "^+#\|^+---\|^+$\|^+>\|^+ *$" \
    | sed 's/^+//' \
    | grep -v "^\s*$" \
    | head -5)
fi

# 변경 없으면 종료
if [ -z "$NEW_LINES" ]; then
  exit 0
fi

# 첫 번째 의미 있는 줄을 규칙 요약으로 사용 (60자 이내)
RULE_SUMMARY=$(echo "$NEW_LINES" | head -1 | sed 's/^[[:space:]]*//' | cut -c1-60)

# 컨텍스트 (호출 출처)
if $MANUAL; then
  CTX="manual harness-evolve"
else
  CTX="pre-commit harness-evolve"
fi

# 변경된 파일 감지
if $MANUAL; then
  CHANGED_FILE=$(git diff HEAD~1 --name-only 2>/dev/null | grep -E "CLAUDE\.md|AGENTS\.md|docs/.*\.md|verify\.sh" | head -1 || echo "CLAUDE.md")
else
  CHANGED_FILE=$(git diff --cached --name-only 2>/dev/null | grep -E "CLAUDE\.md|AGENTS\.md|docs/.*\.md|verify\.sh" | head -1 || echo "CLAUDE.md")
fi
ENTRY="| $DATE | $CHANGED_FILE | $RULE_SUMMARY | $CTX |"

# HARNESS_CHANGELOG.md가 없으면 생성
if [ ! -f "$CHANGELOG" ]; then
  cat > "$CHANGELOG" << 'EOF'
# HARNESS_CHANGELOG.md — 하네스 진화 기록

> AI가 규칙을 추가할 때마다 자동으로 여기에 기록합니다.
>
> 형식: YYYY-MM-DD | 수정 파일 | 추가된 규칙 | 발견 맥락

---

## 규칙 추가 이력

| 날짜 | 파일 | 추가된 규칙 | 발견 맥락 |
|------|------|------------|-----------|
EOF
fi

# Python3으로 플레이스홀더 교체 또는 테이블 끝에 추가
# sed 대신 Python3 사용 — Windows/Mac/Linux 동일하게 작동, | 문자 이슈 없음
python3 - "$CHANGELOG" "$ENTRY" << 'PYEOF'
import sys

changelog_path = sys.argv[1]
entry = sys.argv[2]
placeholder = "(규칙이 추가되면"

with open(changelog_path, 'r', encoding='utf-8') as f:
    content = f.read()

if placeholder in content:
    # 플레이스홀더 행을 실제 엔트리로 교체
    lines = content.splitlines()
    new_lines = []
    for line in lines:
        if placeholder in line:
            new_lines.append(entry)
        else:
            new_lines.append(line)
    new_content = '\n'.join(new_lines) + '\n'
else:
    # 테이블의 마지막 | 로 시작하는 행 뒤에 추가
    lines = content.splitlines()
    last_table_idx = -1
    for i, line in enumerate(lines):
        if line.startswith('|'):
            last_table_idx = i
    if last_table_idx >= 0:
        lines.insert(last_table_idx + 1, entry)
    else:
        lines.append(entry)
    new_content = '\n'.join(lines) + '\n'

with open(changelog_path, 'w', encoding='utf-8') as f:
    f.write(new_content)
PYEOF

echo "  📝 HARNESS_CHANGELOG.md 업데이트: $RULE_SUMMARY ($DATE)"
