# EduHarness Foundation
### AI Coding Agent Harness Template for Educators

> "Designing how you collaborate with AI — that is Harness Engineering."

[한국어 →](README.md)

---

## What is Harness Engineering?

Harness Engineering goes beyond prompt engineering (crafting better questions for AI).
It's the practice of **designing the environment itself** in which AI works consistently and at high quality.

| | Prompt Engineering | **Harness Engineering** |
|---|---|---|
| Perspective | AI as a one-time tool | Design the environment AI works in |
| Method | Re-explain context every session | Delegate via rules and structure |
| Result | Consistency is hard to maintain | Structurally consistent quality |
| Core question | How should I ask? | **How should I design the working environment?** |

---

## The 4 Core Components

| Component | Role | Files in this template |
|---|---|---|
| 📜 **Constitution** | Rules and principles AI must follow | `CLAUDE.md`, `AGENTS.md` |
| 🏗 **Work Structure** | Blueprint defining what to build and how | `architecture.md`, `progress.md` |
| ✅ **Verification** | Quality criteria for evaluating outputs | `.husky/pre-commit`, checklists |
| 🔄 **Execution Loop** | Automated modify→verify→repeat workflow | `.claude/skills/execution-loop/` |

> For detailed mapping to the technical 4 pillars (Context/Constraint/Verification/Feedback), see the [Harness Guide](docs/harness-guide.en.md).

---

## The 2-Layer Structure

A harness consists of two distinct layers:

```
Repository Harness — "Company employment rules"
│  Common principles applied across all educational projects
│  Entire .claude/ folder (coding style, accessibility, edu domain rules)
│
└── Application Harness — "Team work manual"
       Rules specific to this project only
       CLAUDE.md + architecture.md + AGENTS.md
       (tech stack, data model, project purpose)
```

**After cloning: leave the Repository Harness as-is, just fill in the `[brackets]` in the Application Harness.**

---

## The Core: Building a One-Person Organization

> "A harness stores your judgment in a repository."

The constitution, work structure, and verification criteria accumulated in your harness grow more sophisticated over time.
This becomes your personal **moat** — a structured repository of judgment and experience that others cannot easily replicate.

This template is a **starting point**.
The real value comes from how you evolve and accumulate it over time.

---

## Quick Start (5 minutes)

### Step 1: Get the template

Click **"Use this template"** on GitHub → Create new repository

Or directly:
```bash
git clone https://github.com/[YOUR_GITHUB]/edu-harness.git my-edu-project
cd my-edu-project && rm -rf .git && git init
```

### Step 2: Build your Application Harness

Follow [`docs/customization-guide.ko.md`](docs/customization-guide.ko.md) to fill in the `[brackets]`:

| File | What to update |
|------|---------------|
| `CLAUDE.md` | Project purpose, key commands |
| `architecture.md` | Tech stack, directory structure, data model |
| `progress.md` | Current status, next steps |
| `AGENTS.md` | Remove roles you don't need |

### Step 3: Use AI as a Delegative Manager

```
# ❌ Directive — limits AI's creative problem space
"Make the button #3B82F6, text white, padding 12px 24px..."

# ❌ Laissez-faire — results fall short of expectations
"Build a UI."

# ✅ Delegative — harness philosophy
"[Coder] Build the quiz results screen.
 Follow the psychological safety principles in education-principles.md,
 comply with WCAG 2.1 AA, and update progress.md when done."
```

---

## File Structure

```
edu-harness/
├── CLAUDE.md                      # 📜 Constitution — core project rules (edit first)
├── AGENTS.md                      # 📜 Constitution — role separation + execution loop
├── architecture.md                # 🏗 Work Structure — system design template
├── progress.md                    # 🏗 Work Structure — progress tracking
│
├── docs/
│   ├── customization-guide.ko.md  # ⭐ Harness setup guide (read first)
│   ├── harness-guide.ko.md        # Detailed guide (Korean)
│   ├── harness-guide.en.md        # Detailed guide (English)
│   ├── education-principles.md    # Educational pedagogy reference
│   └── wcag-checklist.md          # ✅ WCAG accessibility checklist
│
├── .claude/
│   ├── settings.json              # Automation hook configuration
│   └── skills/
│       ├── execution-loop/        # 🔄 Execution loop skill
│       ├── assessment-design/     # Formative/summative assessment design
│       ├── learning-flow/         # UDL learning flow design
│       ├── edu-component/         # Educational component generator
│       ├── accessibility/         # WCAG accessibility review
│       └── progress-update/       # Auto progress.md updater
│
└── .husky/
    └── pre-commit                 # ✅ Verification — automated quality check
```

---

## Usage Examples

### Execution Loop for complex features

```
# Complex feature (3+ files)
[Use execution-loop skill] Implement the student quiz session feature.
Design as formative assessment following assessment-design skill.
Loop until: lint passes, tests pass, Pedagogy Reviewer approves.
```

### Using skills

```
# Design assessment correctly
[Use assessment-design skill] Design the end-of-unit quiz.
Design as summative — ensure correct answers aren't exposed in the API.

# Review accessibility
[Use accessibility skill] Review src/pages/quiz.tsx for WCAG compliance.
Categorize issues as CRITICAL/HIGH/MEDIUM.
```

### Save points

Always commit before starting a task:
```bash
git add -A && git commit -m "checkpoint: before quiz feature implementation"
```

---

## Harness Intensity

| Level | Situation | AI Autonomy |
|---|---|---|
| Strict | Payment/auth, student data, summative assessment | Low — approve each step |
| Adaptive | General educational features | **Recommended** |
| Vibe | Idea sketching, early prototype | High — fast but risky |

### Accessibility Note (April 2026)

Public educational institutions face **mandatory WCAG 2.1 AA compliance from April 2026**.
See `docs/wcag-checklist.md`.

---

## Educational Project Types

- Quiz & assessment systems (formative/summative distinction built-in)
- Learning progress trackers
- Course material management platforms
- Student portfolio sites
- Attendance management systems
- Learning dashboards

---

## Learn More

- [Harness Setup Guide](docs/customization-guide.ko.md)
- [Detailed Harness Guide (English)](docs/harness-guide.en.md)
- [WCAG 2.1 Accessibility Checklist](docs/wcag-checklist.md)
- [한국어 가이드](docs/harness-guide.ko.md)

---

## Contributing

If this template helped you:
1. ⭐ Give it a **Star**
2. Suggest improvements via **Issues**
3. Share your classroom experience via **Discussions**

---

## License

[MIT License](LICENSE) — Use, modify, and distribute freely.
