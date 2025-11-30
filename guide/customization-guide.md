# 블로그 외관 커스터마이징 가이드

Minimal Mistakes 테마를 사용한 블로그 외관 커스터마이징 완전 가이드입니다.

---

## 🎨 빠른 시작

모든 외관 설정은 `_config.yml` 파일에서 관리됩니다.

**중요:** `_config.yml`을 수정한 후에는 **반드시 Jekyll 서버를 재시작**해야 합니다!

```bash
# Ctrl+C로 서버 중지 후 재시작
bundle exec jekyll serve --livereload
```

---

## 🌈 1. 테마 스킨 변경

### 사용 가능한 스킨

Minimal Mistakes는 9가지 기본 스킨을 제공합니다:

```yaml
minimal_mistakes_skin: "default"  # 현재 설정
```

**스킨 종류:**

| 스킨 | 설명 | 특징 |
|------|------|------|
| `default` | 기본 스킨 | 흰색 배경, 검은 텍스트 |
| `air` | 밝고 가벼운 | 연한 회색 배경 |
| `aqua` | 청록색 계열 | 시원한 느낌 |
| `contrast` | 고대비 | 가독성 최고 |
| `dark` | 다크 모드 | 어두운 배경, 밝은 텍스트 |
| `dirt` | 따뜻한 갈색 | 자연스러운 느낌 |
| `neon` | 네온 다크 | 사이버펑크 스타일 |
| `mint` | 민트색 | 상쾌한 느낌 |
| `plum` | 자주색 | 우아한 느낌 |
| `sunrise` | 일출 주황 | 따뜻하고 활기찬 |

### 변경 방법

```yaml
# _config.yml (15번째 줄)
minimal_mistakes_skin: "dark"  # 원하는 스킨으로 변경
```

**추천:**
- 코드 중심 블로그: `dark`, `neon`, `contrast`
- 디자인/아트: `plum`, `sunrise`, `mint`
- 기술 문서: `default`, `air`, `contrast`

---

## 👤 2. 프로필 설정

### 아바타 이미지 추가

```bash
# 1. 이미지 준비 (정사각형 권장, 200x200px 이상)
# 2. assets/images/에 저장
cp ~/profile.jpg assets/images/bio-photo.jpg
```

```yaml
# _config.yml (117번째 줄)
author:
  name             : "Jeong Yoon Kang"
  avatar           : "/assets/images/bio-photo.jpg"  # 경로 추가
  bio              : "HW-SW Engineer"
  location         : "Korea"
  email            : "goneki9713@naver.com"
```

### Bio 문구 수정

```yaml
# _config.yml (118번째 줄)
bio: "Hardware & Software Engineer | FPGA Enthusiast"
```

---

## 🔗 3. 소셜 링크 추가

### 사이드바 링크

```yaml
# _config.yml (121-139번째 줄)
author:
  links:
    - label: "Email"
      icon: "fas fa-fw fa-envelope-square"
      url: "mailto:goneki9713@naver.com"  # 주석 해제하고 URL 추가

    - label: "GitHub"
      icon: "fab fa-fw fa-github"
      url: "https://github.com/jeongyoon-kang"  # GitHub 계정 추가

    - label: "LinkedIn"
      icon: "fab fa-fw fa-linkedin"
      url: "https://linkedin.com/in/yourprofile"  # LinkedIn 추가 (선택)

    # 불필요한 항목은 삭제하거나 주석 처리
```

### 푸터 링크

```yaml
# _config.yml (142-161번째 줄)
footer:
  links:
    - label: "GitHub"
      icon: "fab fa-fw fa-github"
      url: "https://github.com/jeongyoon-kang"

    # 나머지는 제거하거나 주석 처리
```

### 사용 가능한 아이콘

Font Awesome 무료 아이콘 사용:

```yaml
# 이메일
icon: "fas fa-fw fa-envelope-square"

# GitHub
icon: "fab fa-fw fa-github"

# LinkedIn
icon: "fab fa-fw fa-linkedin"

# 블로그
icon: "fas fa-fw fa-link"

# Twitter/X
icon: "fab fa-fw fa-twitter-square"

# Instagram
icon: "fab fa-fw fa-instagram"
```

---

## 🖼️ 4. 사이트 로고 및 제목

### 로고 추가

```bash
# 로고 이미지 준비 (88x88px 권장)
cp ~/logo.png assets/images/logo.png
```

```yaml
# _config.yml (29번째 줄)
logo: "/assets/images/logo.png"
```

### 사이트 서브타이틀

```yaml
# _config.yml (22번째 줄)
subtitle: "Hardware meets Software"  # 메인 타이틀 아래 작은 글씨
```

### 마스트헤드 타이틀 오버라이드

```yaml
# _config.yml (30번째 줄)
masthead_title: "JY's Tech Blog"  # 기본 title 대신 표시됨
```

---

## ⚙️ 5. 기능 활성화

### 코드 복사 버튼

```yaml
# _config.yml (33번째 줄)
enable_copy_code_button: true  # 코드 블록에 복사 버튼 추가
```

### 사이트 검색

```yaml
# _config.yml (71번째 줄)
search: true  # 사이트 검색 활성화
search_full_content: true  # 전체 내용 검색 (선택)
```

### 브레드크럼 (경로 표시)

```yaml
# _config.yml (31번째 줄)
breadcrumbs: true  # 페이지 상단에 경로 표시
```

---

## 💬 6. 댓글 시스템

### Giscus (GitHub Discussions 기반, 추천)

```yaml
# _config.yml (36-61번째 줄)
comments:
  provider: "giscus"
  giscus:
    repo_id: "YOUR_REPO_ID"  # https://giscus.app 에서 생성
    category_name: "Comments"
    category_id: "YOUR_CATEGORY_ID"
    discussion_term: "pathname"
    reactions_enabled: '1'
    theme: "preferred_color_scheme"  # 또는 "light", "dark"
```

**Giscus 설정 방법:**
1. https://giscus.app 접속
2. GitHub 저장소 입력 (예: `jeongyoon-kang/jeongyoon-kang.github.io`)
3. Discussion 카테고리 선택
4. 생성된 설정값 복사

### 포스트별 댓글 활성화

```yaml
# _config.yml (325번째 줄)
defaults:
  - scope:
      path: ""
      type: posts
    values:
      comments: true  # 주석 해제
```

---

## 📊 7. Google Analytics

```yaml
# _config.yml (107-111번째 줄)
analytics:
  provider: "google-gtag"  # 또는 "google-universal"
  google:
    tracking_id: "G-XXXXXXXXXX"  # Google Analytics 추적 ID
    anonymize_ip: false
```

**Google Analytics 설정:**
1. https://analytics.google.com 접속
2. 새 속성 만들기
3. 데이터 스트림 추가 (웹)
4. 측정 ID 복사 (G-로 시작)

---

## 🎨 8. 고급 커스터마이징

### 커스텀 CSS 추가

```bash
# 1. 커스텀 CSS 파일 생성
touch assets/css/custom.scss
```

```scss
/* assets/css/custom.scss */
---
---

@import "minimal-mistakes/skins/{{ site.minimal_mistakes_skin | default: 'default' }}"; // 스킨
@import "minimal-mistakes"; // 메인 스타일

/* 커스텀 스타일 */
.page__title {
  color: #ff6b6b;  /* 제목 색상 변경 */
}

.sidebar {
  background-color: #f8f9fa;  /* 사이드바 배경색 */
}

/* 코드 블록 스타일 */
.highlight {
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}
```

```yaml
# _config.yml에 추가 (아무 곳이나)
head_scripts:
  - /assets/css/custom.scss
```

### 폰트 변경

```scss
/* assets/css/custom.scss */
@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700&display=swap');

body {
  font-family: 'Noto Sans KR', -apple-system, BlinkMacSystemFont, sans-serif;
}
```

### 색상 커스터마이징

```scss
/* assets/css/custom.scss */
$primary-color: #2c3e50;  /* 주요 색상 */
$link-color: #3498db;     /* 링크 색상 */
$link-color-hover: #2980b9;  /* 링크 호버 */
```

---

## 🏠 9. 홈페이지 레이아웃

### 방법 1: About 페이지를 홈으로

```yaml
# _pages/home.md 생성
---
layout: single
title: "Welcome"
permalink: /
author_profile: true
---

안녕하세요! HW-SW 엔지니어 강정윤입니다.

## 주요 프로젝트
- DMA 컨트롤러 설계
- FPU 최적화

## 기술 스택
- Hardware: Verilog, SystemVerilog, FPGA
- Software: C/C++, Python
```

### 방법 2: 최근 포스트 목록 (현재 설정)

이미 설정되어 있음 (`index.html` 참고)

---

## 📱 10. 반응형 이미지 및 레이아웃

### Wide 레이아웃 (전체 너비 사용)

```yaml
# 포스트 front matter에 추가
---
classes: wide
---
```

### 이미지 크기 조절

```markdown
![이미지](/assets/images/image.jpg){: .align-center width="50%"}
```

---

## ✨ 11. 추천 설정 조합

### 기술 블로그 (현재 설정 최적화)

```yaml
# _config.yml

# 스킨: 다크 모드 (코드 가독성)
minimal_mistakes_skin: "dark"

# 기능 활성화
enable_copy_code_button: true
search: true
breadcrumbs: true

# 프로필
author:
  avatar: "/assets/images/bio-photo.jpg"
  bio: "HW-SW Engineer | FPGA & Embedded Systems"
  links:
    - label: "GitHub"
      icon: "fab fa-fw fa-github"
      url: "https://github.com/jeongyoon-kang"
    - label: "Email"
      icon: "fas fa-fw fa-envelope-square"
      url: "mailto:goneki9713@naver.com"

# 댓글 (Giscus)
comments:
  provider: "giscus"
  # ... giscus 설정
```

---

## 🔍 문제 해결

### 변경사항이 반영 안 됨

```bash
# 1. Jekyll 서버 재시작
Ctrl+C
bundle exec jekyll serve --livereload

# 2. 캐시 삭제
rm -rf _site .jekyll-cache
bundle exec jekyll serve --livereload

# 3. 브라우저 강력 새로고침
Ctrl+Shift+R (Chrome/Firefox)
Cmd+Shift+R (Mac)
```

### 이미지가 안 보임

```yaml
# 절대 경로 사용 (맨 앞에 / 필수!)
avatar: "/assets/images/bio-photo.jpg"  # ✅
avatar: "assets/images/bio-photo.jpg"   # ❌
```

### 스킨이 적용 안 됨

```yaml
# 따옴표 확인
minimal_mistakes_skin: "dark"  # ✅
minimal_mistakes_skin: dark    # ❌ (따옴표 없어도 되지만 권장)
```

### Giscus 댓글이 안 보임

1. GitHub 저장소가 Public인지 확인
2. Discussions 기능이 활성화되어 있는지 확인
3. `repo_id`와 `category_id`가 정확한지 확인
4. 포스트의 `comments: true` 설정 확인

---

## 📋 커스터마이징 체크리스트

### 기본 설정
- [ ] 테마 스킨 선택
- [ ] 사이트 제목/서브타이틀 설정
- [ ] 프로필 이미지 추가
- [ ] Bio 문구 작성

### 기능 활성화
- [ ] 코드 복사 버튼
- [ ] 사이트 검색
- [ ] 브레드크럼
- [ ] 댓글 시스템 (선택)
- [ ] Google Analytics (선택)

### 소셜 링크
- [ ] GitHub 링크 추가
- [ ] Email 링크 추가
- [ ] 불필요한 링크 제거

### 고급 설정 (선택)
- [ ] 커스텀 CSS
- [ ] 폰트 변경
- [ ] 로고 추가
- [ ] 홈페이지 커스터마이징

---

## 🎯 다음 단계

1. **테마 선택**: 다양한 스킨을 테스트해보고 마음에 드는 것 선택
2. **프로필 완성**: 아바타 이미지와 Bio 추가
3. **소셜 링크**: GitHub, Email 등 실제 링크 추가
4. **기능 활성화**: 코드 복사, 검색 등 유용한 기능 켜기
5. **댓글 설정**: Giscus로 독자와 소통 (선택)
6. **Analytics**: 방문자 추적 (선택)

---

## 💡 빠른 시작 예제

```yaml
# _config.yml - 최소한의 커스터마이징

# 라인 15: 스킨 변경
minimal_mistakes_skin: "dark"

# 라인 33: 코드 복사 버튼
enable_copy_code_button: true

# 라인 71: 검색 활성화
search: true

# 라인 117: 프로필 이미지
author:
  avatar: "/assets/images/bio-photo.jpg"

# 라인 134-136: GitHub 링크
  links:
    - label: "GitHub"
      icon: "fab fa-fw fa-github"
      url: "https://github.com/jeongyoon-kang"
```

**위 설정만으로도 블로그가 훨씬 전문적으로 보입니다!**

---

**더 자세한 정보:**
- [Minimal Mistakes 공식 문서](https://mmistakes.github.io/minimal-mistakes/docs/configuration/)
- [Font Awesome 아이콘](https://fontawesome.com/icons)
- [Giscus 설정](https://giscus.app)
