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
> `Lazy-fill`: Tech stack and user descriptions are read automatically from your first `/edu-harness` request. No manual editing needed.

### Step 3: Build your first feature

```
/edu-harness Build a student quiz feature. Design it as formative assessment.
```

> Natural language also works without the slash command.
> "Build a quiz feature", "Add a grade management screen" → automatically triggers the `/edu-harness` workflow.

---

## Try It Now

Copy and paste to get started immediately.

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

When `/edu-harness-init` detects the project is not an education app, it automatically removes the education domain section from `CLAUDE.md`.
The `[EDU-DOMAIN]` checks in `verify.sh` auto-pass when no quiz/feedback components are found — no extra configuration needed.

```
# Example for a non-education project
/edu-harness-init
# → "No education app features detected. Remove edu domain section?" → Y
# → Removes rules 1-5 from CLAUDE.md, keeps all coding rules and verification structure
```

---

## File Structure

```
edu-harness/
├── CLAUDE.md              # 📜 Constitution — core AI rules (project purpose + coding rules + edu domain)
├── AGENTS.md              # 📜 Constitution — agent role separation + workflow
├── architecture.md        # 🏗 Work Structure — tech stack, directories, data model
├── progress.md            # 🏗 Work Structure — current state, next steps, issues
├── HARNESS_CHANGELOG.md   # Harness evolution history (auto-updated on commit)
│
├── docs/
│   ├── example-walkthrough.md   # ⭐ Hands-on walkthrough (start here)
│   ├── education-principles.md  # Educational pedagogy reference
│   ├── verification-rubric.md   # 6-dimension verification rubric
│   ├── wcag-checklist.md        # WCAG accessibility checklist
│   └── harness-guide.en.md      # Detailed harness guide
│
└── .claude/skills/
    ├── edu-harness/       # 🎓 Main entry point (plan→verify→harness evolution full cycle)
    ├── edu-harness-init/  # 🔧 Harness initialization automation
    ├── execution-loop/    # 🔄 Repeat until passing (internal)
    ├── objective-loop/    # 🎯 Repeat until score target + harness evolution (internal)
    └── verify/            # ✅ 6-dimension verification (internal)
```

---

## Skill Catalog

| Skill | Purpose | When to use |
|------|------|-----------|
| `/edu-harness-init` | Automate initial harness setup | Right after clone |
| `/edu-harness` | Full feature implementation workflow (with pedagogy review) | Every feature |
| `/execution-loop` | Auto-repeat until passing criteria met | Verification loop |
| `/objective-loop` | Auto-repeat until score target + harness evolution | Score-based improvement |
| `/verify` | Measure 6-dimension quality score | Standalone check |

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
