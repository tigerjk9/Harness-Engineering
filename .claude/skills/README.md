# EduHarness 스킬 카탈로그

Claude Code에서 `/스킬명 ...` 형태로 호출합니다.

---

## 사용자 진입점

| 스킬 | 명령어 |
|------|--------|
| **edu-harness** | `/edu-harness 기능명을 만들어줘.` |

---

## 내부 워크플로우 스킬 (단독 사용도 가능)

| 스킬 | 용도 | 명령어 |
|------|------|--------|
| **execution-loop** | 합격 기준까지 수정→검증→반복 | `/execution-loop ...` |
| **verify** | 6차원 수치 검증 | `bash .claude/skills/verify/verify.sh` |
| **objective-loop** | 수치 목표 달성 + 하네스 진화 | `/objective-loop ...` |

---

## 실행 스크립트

```bash
# 현재 코드베이스 검증 (숫자 점수 출력)
bash .claude/skills/verify/verify.sh

# objective-loop 기준점 저장
bash .claude/skills/objective-loop/measure.sh baseline "시작"

# objective-loop 현재 점수 + delta 측정
bash .claude/skills/objective-loop/measure.sh check "루프 1 완료"
```

---

## 언제 무엇을 쓰나요?

```
새 기능 만들기               → edu-harness
점수 개선이 필요할 때        → objective-loop
구현 후 빠른 검증            → verify.sh
합격까지 자동 수정           → execution-loop
```
