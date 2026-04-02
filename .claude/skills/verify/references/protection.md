# 차원 5-6: 데이터 보호 + 성능

## 차원 5 — 데이터 보호 (CRITICAL)

```bash
# CRITICAL: 하드코딩 비밀 정보
grep -rEn "(apiKey|api_key|password|secret|token)\s*=\s*['\"][^'\"\$\{]{8,}" \
  src/ --include="*.ts" --include="*.tsx" \
  | grep -v "\.test\.\|example\|placeholder\|sample\|mock"

# 학생 데이터 외부 전송 의심 패턴
grep -rn "axios\.post\|fetch.*student\|sendData\|analytics" \
  src/ --include="*.ts" | grep -v "\.test\." | grep -v "api/"
```

체크리스트:
- [ ] 하드코딩 API 키/비밀번호 없음 (process.env 사용)
- [ ] 회원가입: 만 14세 미만 보호자 동의 분기 (birthYear 필드 + 동의 플로우)
- [ ] catch 블록: 민감 정보 미포함
- [ ] 학생 데이터 제3자 전송 없음

---

## 차원 6 — 성능 (MEDIUM)

```bash
# Next.js 번들 크기 확인
ls -lh .next/static/chunks/*.js 2>/dev/null | sort -k5 -h | tail -5

# CDN 미사용 이미지 직접 참조
grep -rn "src=\"/images\|src=\"\./images" src/ --include="*.tsx" \
  | grep -v "cdn\|cloudfront\|vercel"
```

체크리스트:
- [ ] LCP ≤ 2.5초 (Lighthouse Core Web Vitals)
- [ ] 모바일 반응형 768px, 480px 확인
- [ ] 이미지: CDN 경유 또는 next/image 사용
- [ ] 큰 번들 청크 없음 (300KB 이하 기준)
