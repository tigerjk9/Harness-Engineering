# Harness Build Guide — Converting Tacit Knowledge to Explicit Knowledge

> This guide explains how to **evolve the EduHarness template to fit your project**.
> Read this file first, right after cloning.

---

## 6-Phase Harness Build Pipeline {#pipeline}

> Follow this sequence when starting a new education project.
> EduHarness has implemented all 6 phases as files and skills.

```
┌──────────────────────────────────────────────────────────────────┐
│              Harness Build Pipeline                              │
└──────────────────────────────────────────────────────────────────┘

Phase 1             Phase 2             Phase 3
Ideation &          Constitution        Autonomous
Architecture        (CLAUDE.md)         Validation
[Empty → Structure] [Write rules]       [AI corrects inconsistencies]
      │                   │                    │
      ▼                   ▼                    ▼
architecture.md      CLAUDE.md           verify skill
progress.md          AGENTS.md           (harness validation)

Phase 4             Phase 5             Phase 6
Git Checkpoint      Tacit Knowledge     MBO Execution Loop
[Permanent memory]  [Assumptions →      [AI auto-iterates]
      │              Rules]                   │
      ▼                   │                   ▼
.husky/pre-commit    CLAUDE.md rules    execution-loop
git commit           added over time    skill + AGENTS.md
```

### Phase-to-File Mapping

| Phase | Core Action | File / Skill |
|-------|-------------|--------------|
| **1. Ideation & Architecture** | Agree on folder structure and tech stack with AI | Fill `architecture.md` |
| **2. Constitution** | Set non-negotiable rules (security, education rules, coding style) | Fill `[brackets]` in `CLAUDE.md` |
| **3. Autonomous Validation** | AI self-corrects logical inconsistencies between documents | Run `[verify skill]` |
| **4. Git Checkpoint** | Save the initial harness version as permanent memory | `.husky/pre-commit` + first `git commit` |
| **5. Tacit Knowledge** | Convert implicit "obvious" assumptions → explicit CLAUDE.md rules | Repeat phases 2–5 throughout development |
| **6. MBO Execution Loop** | AI writes and revises code until validation criteria are met | Run `[execution-loop skill]` |

### Pipeline Example

```
# Phase 1: Agree on structure with AI
"I want to build an educational quiz app starting from an empty Next.js project.
 Suggest a tech stack and folder structure so we can fill architecture.md."

# Phase 2: Write the constitution
"Fill in the [brackets] in CLAUDE.md.
 Our app targets elementary school students and is formative-assessment-focused."

# Phase 3: Autonomous validation
"[verify skill] Check for logical inconsistencies between CLAUDE.md and architecture.md."

# Phase 4: Git checkpoint
git add CLAUDE.md architecture.md progress.md
git commit -m "harness: initial constitution and architecture setup"

# Phase 5: Tacit knowledge (ongoing throughout development)
"I just realized while building the quiz component:
 the retry button should only appear on formative assessments.
 Add this rule to CLAUDE.md."

# Phase 6: MBO execution loop
"[execution-loop skill] Implement the student quiz-taking feature."
```

---

## Why Does This Process Matter?

The core of harness engineering is **converting tacit knowledge into explicit knowledge**.

Your head is full of "obvious things":
- "Our app is for elementary students, so no technical jargon"
- "DB schema can't change without team lead approval"
- "Quizzes must allow unlimited retries"

The AI doesn't know any of this. Without your explicit rules, the AI will build a
standard grading system, use technical jargon, and modify the DB freely.

**The harness is the work of turning those "obvious things" into code.**

---

## Phase 1: Understanding the 2-Layer Harness Structure

```
Repository Harness (do not modify)
├── .claude/skills/       # Education domain shared skills
├── .claude/settings.json # Automation hooks
└── .husky/pre-commit     # Automatic validation

Application Harness (fill this in)
├── CLAUDE.md             # ← This project's constitution
├── AGENTS.md             # ← Agent roles (modify as needed)
├── architecture.md       # ← System structure definition
└── progress.md           # ← Progress tracking
```

The **Repository Harness** contains common principles. Education domain rules (formative/summative
assessment, WCAG, etc.) are built in — don't modify it at the start.

The **Application Harness** is specific to your project. Filling in the `[brackets]` in these
4 files is where you begin.

---

## Phase 2: CLAUDE.md — Writing the Constitution (Most Important)

CLAUDE.md is the **constitution** that AI agents automatically read at the start of every session.

### What to Fill In

```markdown
## Project Purpose
[YOUR_PROJECT_NAME] → e.g., "EduQuiz Pro"
Target users: [e.g., elementary school teachers in grades 3–6]
Core features: [e.g., quiz creation, student progress tracking]
```

**Tip — Fill it in by talking with the AI:**
```
"Ask me 5 key questions about our education app.
Based on my answers, fill in the Project Purpose section of CLAUDE.md."
```

### Fill in the Key Commands

```markdown
## Key Commands
npm run dev      # ← Replace with your actual command
npm test         # ← Replace with your actual command
npm run lint     # ← Replace with your actual command
```

### Keep It Short — AI Won't Read Long Files

Keep CLAUDE.md **under 800 lines**.
Keep only the essentials; move the rest to the `docs/` folder.

---

## Phase 3: architecture.md — Defining the Work Structure

Document the system structure so the AI knows where and how to place code.

### Minimum Required Fields

```markdown
| Project Name | EduQuiz Pro |
| Purpose | Web app for teachers to create quizzes and track student progress |
| Tech Stack | Next.js 14, TypeScript, PostgreSQL, Tailwind |
| Deployment | Vercel (frontend) + Railway (DB) |
```

**The directory structure must match your actual project structure** so the AI places
files in the right locations.

---

## Phase 4: AI-Assisted Logical Consistency Review

Once you've filled in the documents, ask the AI to review them:

```
"Read CLAUDE.md and architecture.md as a senior developer.
Check for any inconsistencies between the two.
Tell me which side to fix if there are contradictions."
```

```
"Rate the rules in CLAUDE.md from 0–10 as a security expert.
Replace any vague expressions with specific numbers or code examples."
```

---

## Phase 5: Git Versioning for the Harness

The real value of a harness is that **it gets more sophisticated over time**.

```bash
# Commit every time you improve the harness
git add CLAUDE.md architecture.md
git commit -m "harness: formative assessment rules refined"

# Separate harness branch (optional)
git checkout -b harness/v2
```

Each time the harness evolves across projects, the next project starts from a
stronger baseline.

---

## The Delegating Manager Model

If you've built a good harness, you also need to change how you use AI.

### 3 Manager Archetypes

**Directive Manager ❌** — Limits AI's creative problem-solving space
```
"Make the login button blue (#3B82F6),
 with 16px bold text and 12px 16px padding."
```

**Hands-Off Manager ❌** — Results fall short of expectations
```
"Make a login page."
```

**Delegating Manager ✅** — Provide goals and criteria; let AI choose the method
```
"[Coder] Build the student login page.
 - Target: elementary school students (simple, large UI)
 - WCAG 2.1 AA accessibility compliance
 - Under 14: link to parental consent flow (see CLAUDE.md Rule 5)
 - Update progress.md when done."
```

### Conditions for Successful Delegation

1. **Clear completion criteria**: Measurable criteria like "WCAG 2.1 AA compliant"
2. **Reference document**: Tell AI where to look, e.g., "see education-principles.md"
3. **Explicit follow-up action**: "Update progress.md when done"

---

## Common Mistakes

### Mistake 1: Using the Harness Once and Stopping

The harness is a **living document**. As the project progresses:
- New prohibited behavior discovered → Add to CLAUDE.md
- Architecture decision made → Record in architecture.md
- Effective prompt pattern found → Add to AGENTS.md examples

### Mistake 2: Too Many Rules

If CLAUDE.md has more than 50 rules, the AI won't read them all.
Keep only the 10–20 most critical; move the rest to `docs/`.

### Mistake 3: Vague Rules

```
❌ "Write clean code"
✅ "Keep functions under 50 lines, files under 800 lines"

❌ "Be mindful of security"
✅ "Never include answer data in API responses (assessment-integrity rule)"
```

### Mistake 4: Using Without Roles

Without roles: `"Make a quiz"` → AI plans, implements, and reviews simultaneously → quality degrades

With roles: `[Planner] plan → [Coder] implement → [Pedagogy Reviewer] educational review`

---

## Checklist: Harness Ready?

- [ ] All `[brackets]` in CLAUDE.md filled in
- [ ] Actual tech stack reflected in architecture.md
- [ ] Current progress recorded in progress.md
- [ ] AI logical consistency review of CLAUDE.md completed
- [ ] Initial harness version saved with first Git commit

Once everything is checked, open Claude Code and start:

```
Read progress.md and architecture.md to understand the current state.
Plan the next task in [Planner] role.
```
