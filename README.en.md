# EduHarness Foundation
### AI Coding Agent Harness Template for Educators

[한국어 →](README.md)

---

## What is Harness Engineering?

Instead of explaining context to AI every time, it's the practice of **designing the environment itself** where AI can work with consistent quality.

| | Prompt Engineering | Harness Engineering |
|---|---|---|
| Method | Re-explain context every session | Delegate upfront via rules and structure |
| Result | Consistency is hard to maintain | Structurally consistent quality |

---

## The 4 Core Components

| Component | Role | Files |
|---|---|---|
| 📜 Constitution | Rules and principles AI must follow | `CLAUDE.md`, `AGENTS.md` |
| 🏗 Work Structure | Blueprint defining what to build and how | `architecture.md`, `progress.md` |
| ✅ Verification | Quality criteria for evaluating outputs | `.husky/pre-commit`, `docs/verification-rubric.md` |
| 🔄 Execution Loop | Automated modify→verify→repeat workflow | `.claude/skills/execution-loop/` |

---

## Quick Start (5 minutes)

### Step 1: Get the template

Click **"Use this template"** on GitHub → Create new repository

### Step 2: Initialize the harness

```
/edu-harness-init
```

Just 2 questions (project name + education app Y/N) → the rest is auto-detected from `package.json` and inferred at first use.

> **Lazy-fill**: Tech stack and user descriptions are read automatically from your first `/edu-harness` request. No manual editing needed.

### Step 3: Build your first feature

```
/edu-harness Build a student quiz feature. Design it as formative assessment.
```

> Natural language also works without the slash command.
> "Build a quiz feature", "Add a grade management screen" → automatically triggers the `/edu-harness` workflow.

---

## The /edu-harness 7-Stage Cycle

That one line automatically runs all 7 stages below.

```
Plan → Agree on Done → Edu Design → Build → Pedagogy Review → Verify → Harness Evolution
```

| Stage | Key Action | Why |
|-------|-----------|-----|
| 1. Plan | Identify affected files and risks | Blueprint before writing code |
| 2. Agree on Done | Sprint contract — define "complete" explicitly | Align AI and human expectations upfront |
| 3. Edu Design | Decide formative/summative, design feedback messages | Ensure code serves educational purpose |
| 4. Build | Write code with unit tests + accessibility tests | Actual implementation |
| 5. Pedagogy Review | Cross-check API↔frontend shape | Verify no answer leakage, retry policies |
| 6. Verify | `verify.sh` 6-dimension automated scoring | Score-based APPROVED/REJECTED |
| 7. Harness Evolution | Auto-accumulate rules in `CLAUDE.md` | AI quality improves each loop |

With each loop, rules accumulate in `HARNESS_CHANGELOG.md`, and rubric gaps are surfaced for review.
**Code changes are delegated to AI; rubric changes require human approval** — this prevents the Goodhart's Law trap.

---

## Try It Now

```
# Quiz (formative assessment)
/edu-harness Build a multiple-choice quiz feature for students. Design as formative assessment.

# Quiz (summative assessment)
/edu-harness Build a final exam quiz feature. Design as summative assessment.

# Teacher grade management
/edu-harness Build a screen for teachers to view and edit student grades.

# Student login/signup
/edu-harness Build student login and signup. Include parental consent flow for under-14.

# Lesson list page
/edu-harness Build a lesson list page showing available courses. Include progress indicators.

# Learning progress dashboard
/edu-harness Build a student learning progress dashboard. Use growth-focused language.
```

---

## For Non-Education Projects

The base structure of EduHarness (constitution, verification, execution loop) works for any project.

When `/edu-harness-init` asks Q2 and you answer N, it automatically removes the education domain section from `CLAUDE.md`.
The `[EDU-DOMAIN]` checks in `verify.sh` auto-pass when no quiz/feedback components are found — no extra configuration needed.

```
/edu-harness-init
# Q2: Is this an education app? → N
# → Removes edu domain section from CLAUDE.md, keeps all coding rules and verification structure
```

---

## File Structure

```
edu-harness/
├── CLAUDE.md              # 📜 Constitution — core AI rules (project purpose + coding rules + edu domain)
├── AGENTS.md              # 📜 Constitution — 7 agent roles + tool permission matrix
├── architecture.md        # 🏗 Work Structure — tech stack, directories, data model
├── progress.md            # 🏗 Work Structure — current state, next steps, context anchor
├── HARNESS_CHANGELOG.md   # Harness evolution history (auto-updated on commit)
├── LICENSE                # MIT License
│
├── docs/
│   ├── example-walkthrough.md   # ⭐ Hands-on walkthrough (start here)
│   ├── education-principles.md  # Educational pedagogy reference
│   ├── verification-rubric.md   # 6-dimension verification rubric (Dim1–Dim6)
│   ├── decision-log.md          # Architecture Decision Records (ADR)
│   ├── harness-audit.md         # Quarterly harness audit checklist
│   ├── harness-audit-results.md # Audit result history
│   ├── wcag-checklist.md        # WCAG accessibility checklist
│   ├── harness-guide.ko.md      # Detailed harness guide (Korean)
│   └── harness-guide.en.md      # Detailed harness guide (English)
│
├── .claude/
│   ├── hooks/
│   │   ├── harness-health.sh    # 🩺 Full status dashboard
│   │   ├── system-check.sh      # 🔧 Environment check (19 items)
│   │   ├── harness-checkpoint.sh # 💾 Level 2 self-repair (git stash)
│   │   └── harness-evolve.sh    # 📝 Auto-log rule changes
│   └── skills/
│       ├── edu-harness/         # 🎓 Main entry point (7-stage cycle)
│       ├── edu-harness-init/    # 🔧 Harness initialization (2 questions)
│       ├── harness-init/        # 🔧 Non-education app initialization
│       ├── execution-loop/      # 🔄 Repeat until passing
│       ├── objective-loop/      # 🎯 Repeat until score target + harness evolution
│       └── verify/              # ✅ 6-dimension verification
```

---

## Skill Catalog

| Skill | Purpose | When to use |
|-------|---------|-------------|
| `/edu-harness-init` | Initialize harness (education or general app) | Once after clone |
| `/harness-init` | Initialize for non-education app | Once after clone (non-edu) |
| `/edu-harness` | 7-stage feature implementation workflow | Every feature |
| `/execution-loop` | Auto-repeat until passing criteria met | When REJECTED |
| `/objective-loop` | Auto-repeat until score target + harness evolution | Score improvement |
| `/verify` | Measure 6-dimension quality score | Standalone check |

### Key Commands

```bash
bash .claude/hooks/harness-health.sh          # 🩺 Full status at a glance
bash .claude/skills/verify/verify.sh          # 📊 Code quality score (fast)
bash .claude/skills/verify/verify.sh --full   # 📊 Full check (lint+tsc+test)
bash .claude/hooks/system-check.sh            # 🔧 Environment diagnosis
```

---

## Harness Intensity

| Level | Situation | AI Autonomy |
|---|---|---|
| Strict | Payment/auth, student data, summative assessment | Low — approve each step |
| Balanced | General educational feature development | **Recommended** |
| Loose | Idea sketching, early prototype | High |

---

## Learn More

- [Hands-on Walkthrough: EduQuiz Mini](docs/example-walkthrough.md) ⭐ Start here if new
- [Harness Setup Guide](docs/customization-guide.ko.md)
- [Detailed Harness Guide (English)](docs/harness-guide.en.md)
- [Skill Catalog](.claude/skills/README.md)
- [한국어 가이드](docs/harness-guide.ko.md)

---

## Contributing

1. ⭐ Give it a **Star**
2. Suggest improvements via **Issues**
3. Share your classroom experience via **Discussions**

[MIT License](LICENSE)
