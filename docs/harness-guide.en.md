# Harness Guide (English)

> EduHarness Foundation Detailed Usage Guide

---

## 1. What is Harness Engineering?

### Analogy: The Horse and the Saddle

An AI model is like a horse — powerful but without direction.
The harness is the saddle and the reins.

- The **same horse (model)** produces entirely different results with different harnesses
- A harness engineer is neither the rider nor the horse, but the saddle maker
- The nature of development has changed: from "writing code" to "designing the track for AI to run on"

### The 4 Pillars

| Pillar | Question | EduHarness Answer |
|--------|----------|------------------|
| **Context** | What should AI know? | `CLAUDE.md`, `architecture.md` |
| **Constraint** | What should AI NOT do? | `AGENTS.md`, `CLAUDE.md` forbidden list |
| **Verification** | How do we know AI did well? | `.husky/pre-commit`, tests |
| **Feedback** | How does AI record results? | `progress.md`, skills |

---

## 2. File Reference

### CLAUDE.md — Core AI Rulebook

Automatically loaded when an AI agent starts a session.
**This is the first file to customize.**

**What to include**:
- Project purpose (so AI knows "what this code is for")
- Coding rules (TypeScript, immutability, file size limits)
- Forbidden actions (file deletion, schema changes)
- Completion criteria (no claiming done without tests)
- Key commands (dev server, test, build)

**Warning**: If it's too long, AI won't read all of it. Keep it **concise with only essentials**.

### AGENTS.md — Agent Role Separation

Divides AI tasks into 4 roles to reduce cognitive load.

```
Planner → Coder → Reviewer → Coder (revisions) → Tester
```

**When is role separation effective?**
- Complex feature implementation (3+ files affected)
- When code review is needed
- When test coverage needs improvement

Simple edits (1-2 lines) don't need role specification.

### architecture.md — System Structure Guide

The "blueprint" that AI reads before writing code.

**Key purpose**: Tells AI "where this file should go" and "what modules this function should use."

**When to update**:
- Adding a new major component
- Changing data models
- Restructuring directories

### progress.md — Progress Tracker

A "current position indicator" for both AI and humans.

**Benefits for AI agents**:
- Understands context from previous session in a new session
- Prevents duplicate work
- Clear priority of next steps

**Update rule**: Read before starting work, always update after completion

---

## 3. Using Skills

Skills give AI agents "specialized roles."

### /edu-harness skill (Main Workflow)

Runs the full pipeline for educational app development in one command:

```
/edu-harness Create a student grade display card.
Show name, score, and rank. Must meet WCAG 2.1 AA accessibility.
```

Internally orchestrates: Planner → Coder → Evaluator → Reviewer → verify.sh → HARNESS UPDATE.

### /harness skill (General Workflow)

For non-educational general project features:

```
/harness Create a user login feature.
```

### /verify skill (Standalone Verification)

Verify current code state:

```bash
bash .claude/skills/verify/verify.sh        # Quick check
bash .claude/skills/verify/verify.sh --full # Full check (lint + tsc + test)
bash .claude/skills/verify/verify.sh --self-critique  # With constitutional self-critique
```

### /execution-loop skill (Auto-fix Loop)

Automatically iterates fixes until APPROVED:

```
/execution-loop Fix all verify failures.
Keep repeating until APPROVED.
```

---

## 4. Pre-commit Hook Setup

The `.husky/pre-commit` file runs automatically before each commit.

### Activating the Default Config

```bash
# 1. Install Husky
npm install --save-dev husky

# 2. Initialize Husky
npx husky init

# 3. Replace pre-commit hook with EduHarness version
# Copy the content from .husky/pre-commit in this repository
```

### Customizing

Modify for your project:

```bash
# Remove this block if you don't use ESLint
if [ -f "package.json" ] && grep -q '"lint"' package.json; then
  npm run lint
fi

# Remove this block if you don't use TypeScript
if [ -f "tsconfig.json" ]; then
  npx tsc --noEmit
fi
```

---

## 5. Adjusting Harness Intensity

### Too Strict?

Symptoms: AI requests approval for every task or is very slow

Fix:
- Reduce the "forbidden actions" list in CLAUDE.md
- Change "3+ files require approval" → "5+ files require approval"
- Prepare quick prompts for simple tasks

### Too Loose?

Symptoms: AI ignores rules or skips progress.md updates

Fix:
- Mark rules as "MANDATORY" at the top of CLAUDE.md
- Include rule compliance in session start prompts
- Strengthen pre-commit hooks

---

## 6. Project Type Examples

### Quiz/Assessment System

Add to CLAUDE.md:
```markdown
## Quiz System Rules
- Student score data: always encrypt at rest
- Correct answers: never expose directly to frontend
- All quiz attempts: must be logged
```

### Learning Progress Tracking

Add to architecture.md:
```markdown
## Progress Tracking Data Flow
Student activity → Progress table update → Dashboard real-time refresh
(No batch processing — real-time updates required)
```

### Course Material Management

Add to AGENTS.md:
```markdown
## Content Manager Role (Additional)
Role: File upload and classification logic
Access: storage/, content/ folders
Required: File size validation, upload only after virus scan
```

---

## 7. FAQ

**Q: What if CLAUDE.md gets too long?**
A: Split into docs/ folder. Keep CLAUDE.md as "table of contents + core rules" only. Move detailed content to docs/ and add reference links.

**Q: Do I need to re-explain the harness for each new session?**
A: No. CLAUDE.md is automatically loaded by Claude Code. Just ask "read progress.md" at the start of each session.

**Q: Can multiple developers use this together?**
A: Yes. Use progress.md as a shared state document, and run `git pull` before working to get the latest state.

**Q: What if AI ignores harness rules?**
A: 1) Start a new session 2) Request "re-read CLAUDE.md" 3) If it still ignores rules, bold the core rules at the top of CLAUDE.md
