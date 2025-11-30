# 블로그 외관 빠른 참고

빠르게 블로그 외관을 수정할 때 참고하는 문서입니다.

**중요:** `_config.yml` 수정 후 **반드시 Jekyll 재시작!**

```bash
Ctrl+C
bundle exec jekyll serve --livereload
```

---

## 🎨 1. 테마 스킨 변경 (라인 15)

```yaml
minimal_mistakes_skin: "dark"
```

**선택 가능:**
- `default` - 기본 흰색
- `dark` - 다크 모드 (코드 블로그 추천)
- `contrast` - 고대비
- `air` - 연한 회색
- `aqua`, `mint`, `plum`, `sunrise`, `neon`, `dirt`

---

## 👤 2. 프로필 이미지 (라인 117)

```bash
# 1. 이미지 저장
cp ~/profile.jpg assets/images/bio-photo.jpg
```

```yaml
# 2. _config.yml
author:
  avatar: "/assets/images/bio-photo.jpg"
```

---

## ✍️ 3. Bio 수정 (라인 118)

```yaml
author:
  bio: "HW-SW Engineer | FPGA & Embedded Systems"
```

---

## 🔗 4. GitHub 링크 추가 (라인 134-136)

```yaml
author:
  links:
    - label: "GitHub"
      icon: "fab fa-fw fa-github"
      url: "https://github.com/jeongyoon-kang"  # 실제 URL로 변경
```

---

## 📧 5. Email 링크 활성화 (라인 122-124)

```yaml
author:
  links:
    - label: "Email"
      icon: "fas fa-fw fa-envelope-square"
      url: "mailto:goneki9713@naver.com"  # 주석 해제
```

---

## 🖼️ 6. 사이트 로고 (라인 29)

```bash
# 1. 로고 저장 (88x88px)
cp ~/logo.png assets/images/logo.png
```

```yaml
# 2. _config.yml
logo: "/assets/images/logo.png"
```

---

## 📝 7. 서브타이틀 (라인 22)

```yaml
subtitle: "Hardware meets Software"
```

---

## ⚙️ 8. 유용한 기능 활성화

### 코드 복사 버튼 (라인 33)

```yaml
enable_copy_code_button: true
```

### 검색 (라인 71)

```yaml
search: true
```

### 브레드크럼 (라인 31)

```yaml
breadcrumbs: true
```

---

## 💬 9. 댓글 (Giscus)

### 1단계: https://giscus.app 에서 설정값 생성

### 2단계: _config.yml 수정 (라인 36-61)

```yaml
comments:
  provider: "giscus"
  giscus:
    repo_id: "YOUR_REPO_ID"
    category_name: "Comments"
    category_id: "YOUR_CATEGORY_ID"
    discussion_term: "pathname"
    reactions_enabled: '1'
    theme: "preferred_color_scheme"
```

### 3단계: 댓글 활성화 (라인 325)

```yaml
defaults:
  - scope:
      type: posts
    values:
      comments: true  # 주석 해제
```

---

## 📊 10. Google Analytics (라인 107-111)

```yaml
analytics:
  provider: "google-gtag"
  google:
    tracking_id: "G-XXXXXXXXXX"  # 실제 ID로 변경
```

---

## 🎨 11. 커스텀 CSS

### 파일 생성

```bash
touch assets/css/custom.scss
```

### 스타일 작성

```scss
---
---

@import "minimal-mistakes/skins/{{ site.minimal_mistakes_skin | default: 'default' }}";
@import "minimal-mistakes";

/* 제목 색상 */
.page__title {
  color: #ff6b6b;
}

/* 코드 블록 둥글게 */
.highlight {
  border-radius: 8px;
}
```

---

## 🚀 추천 초기 설정

```yaml
# _config.yml

# 라인 15: 다크 모드
minimal_mistakes_skin: "dark"

# 라인 22: 서브타이틀
subtitle: "Hardware meets Software"

# 라인 33: 코드 복사 버튼
enable_copy_code_button: true

# 라인 71: 검색
search: true

# 라인 117: 프로필 이미지
author:
  avatar: "/assets/images/bio-photo.jpg"
  bio: "HW-SW Engineer"

# 라인 134-136: GitHub
  links:
    - label: "GitHub"
      icon: "fab fa-fw fa-github"
      url: "https://github.com/jeongyoon-kang"
```

---

## 🔍 문제 해결

### 변경사항 안 보임

```bash
# 1. 서버 재시작
Ctrl+C
bundle exec jekyll serve --livereload

# 2. 캐시 삭제
rm -rf _site .jekyll-cache

# 3. 브라우저 강력 새로고침
Ctrl+Shift+R
```

### 이미지 안 보임

```yaml
# ✅ 절대 경로 (맨 앞에 /)
avatar: "/assets/images/bio-photo.jpg"

# ❌ 상대 경로
avatar: "assets/images/bio-photo.jpg"
```

---

## 📋 체크리스트

### 필수 설정
- [ ] 스킨 선택
- [ ] 프로필 이미지
- [ ] Bio 작성
- [ ] GitHub 링크

### 추천 설정
- [ ] 코드 복사 버튼
- [ ] 검색 활성화
- [ ] 서브타이틀
- [ ] Email 링크

### 선택 설정
- [ ] 로고
- [ ] 댓글 (Giscus)
- [ ] Analytics
- [ ] 커스텀 CSS

---

## 🎯 자주 사용하는 아이콘

```yaml
# GitHub
icon: "fab fa-fw fa-github"

# Email
icon: "fas fa-fw fa-envelope-square"

# LinkedIn
icon: "fab fa-fw fa-linkedin"

# 블로그/웹사이트
icon: "fas fa-fw fa-link"

# Twitter
icon: "fab fa-fw fa-twitter-square"
```

---

## 📚 관련 문서

- [customization-guide.md](customization-guide.md) - 상세 가이드
- [Minimal Mistakes 공식 문서](https://mmistakes.github.io/minimal-mistakes/docs/configuration/)
- [Font Awesome 아이콘](https://fontawesome.com/icons)
- [Giscus 설정](https://giscus.app)
