# 카테고리 사이드바 설정 가이드

Minimal Mistakes 테마에서 계층적 카테고리 네비게이션 사이드바를 설정하는 완전한 가이드입니다.

---

## 목차
1. [개요](#개요)
2. [현재 카테고리 구조](#현재-카테고리-구조)
3. [설정 방법](#설정-방법)
4. [포스트에 카테고리 추가하기](#포스트에-카테고리-추가하기)
5. [카테고리 관리](#카테고리-관리)
6. [문제 해결](#문제-해결)

---

## 개요

이 가이드는 Minimal Mistakes 테마를 사용하는 GitHub Pages 블로그에서 계층적 구조(중첩 카테고리)를 가진 카테고리 사이드바 네비게이션을 설정하는 방법을 설명합니다.

**주요 기능:**
- 계층적 카테고리 구조 (Hardware/Software 및 하위 카테고리)
- 각 카테고리별 개별 페이지
- 카테고리별 자동 포스트 필터링
- 모든 페이지에서 사이드바 표시

---

## 현재 카테고리 구조

### 최상위 카테고리

**About** - 개인 소개 페이지 (정적 페이지, 카테고리 아님)
- 학력, 경력, 기술

**Overview** - 블로그 방향 및 포스팅 계획

**Hardware** (중첩 카테고리)
- Tech Watch - 하드웨어 트렌드 및 기사
- Verilog
- SystemVerilog
- FPGA
- 반도체 공정

**Software** (중첩 카테고리)
- Tech Watch - 소프트웨어 트렌드 및 기사
- Python
- C/C++

**Linux** - Linux 팁 및 튜토리얼

---

## 설정 방법

### 1. 네비게이션 데이터 구성

**파일:** `_data/navigation.yml`

```yaml
# sidebar navigation for categories
docs:
  - title: "About"
    url: /categories/about/

  - title: "Overview"
    url: /categories/overview/

  - title: "Hardware"
    children:
      - title: "Tech Watch"
        url: /categories/hw-tech-watch/
      - title: "Verilog"
        url: /categories/verilog/
      - title: "SystemVerilog"
        url: /categories/systemverilog/
      - title: "FPGA"
        url: /categories/fpga/
      - title: "반도체 공정"
        url: /categories/semiconductor/

  - title: "Software"
    children:
      - title: "Tech Watch"
        url: /categories/sw-tech-watch/
      - title: "Python"
        url: /categories/python/
      - title: "C/C++"
        url: /categories/cpp/

  - title: "Linux"
    url: /categories/linux/
```

**설명:**
- 최상위 카테고리: `title`과 `url` 사용
- 중첩 카테고리: `title`과 `children` 리스트 사용
- 각 하위 항목은 자체 `title`과 `url`을 가짐

### 2. Config에서 사이드바 활성화

**파일:** `_config.yml`

파일 하단의 `defaults` 섹션에 추가:

```yaml
defaults:
  # _posts
  - scope:
      path: ""
      type: posts
    values:
      layout: single
      author_profile: true
      read_time: true
      comments: # true
      share: true
      related: true
      sidebar:
        nav: "docs"

  # _pages
  - scope:
      path: ""
      type: pages
    values:
      layout: single
      author_profile: true
      sidebar:
        nav: "docs"

  # home page (index.html)
  - scope:
      path: ""
    values:
      sidebar:
        nav: "docs"
```

**중요:** `_config.yml` 수정 후 Jekyll 서버를 재시작해야 합니다!

```bash
# 서버 중지 (Ctrl+C) 후 재시작
bundle exec jekyll serve
```

### 3. 카테고리 페이지 생성

각 카테고리는 `_pages` 디렉토리에 자체 페이지가 필요합니다.

**예제:** `_pages/category-python.md`

```markdown
---
title: "Python"
layout: category
permalink: /categories/python/
taxonomy: python
author_profile: true
sidebar:
  nav: "docs"
---
```

**About과 같은 정적 페이지의 경우:**

```markdown
---
title: "About Me"
layout: single
permalink: /categories/about/
author_profile: true
sidebar:
  nav: "docs"
---

## 소개

당신의 콘텐츠...
```

**주요 차이점:**
- 카테고리 목록 페이지: `layout: category`와 `taxonomy` 사용
- 정적 콘텐츠 페이지: `layout: single`과 콘텐츠 작성

---

## 포스트에 카테고리 추가하기

### 포스트 Front Matter 구조

**파일:** `_posts/YYYY-MM-DD-post-title.md`

```yaml
---
layout: single
title: "포스트 제목"
categories: category-name
---

포스트 내용...
```

### 카테고리 이름 참조

포스트에서 다음 **taxonomy** 이름(소문자)을 사용하세요:

**최상위 카테고리:**
- `overview` - Overview 카테고리
- `linux` - Linux 카테고리

**Hardware 하위 카테고리:**
- `hw-tech-watch` - Hardware Tech Watch
- `verilog` - Verilog
- `systemverilog` - SystemVerilog
- `fpga` - FPGA
- `semiconductor` - 반도체 공정

**Software 하위 카테고리:**
- `sw-tech-watch` - Software Tech Watch
- `python` - Python
- `cpp` - C/C++

### 예제

**단일 카테고리:**
```yaml
---
layout: single
title: "FPGA 설계 기초"
categories: fpga
---
```

**다중 카테고리:**
```yaml
---
layout: single
title: "하드웨어 엔지니어를 위한 Python"
categories: [python, hw-tech-watch]
---
```

---

## 카테고리 관리

### 새 카테고리 추가하기

#### Step 1: 네비게이션에 추가

`_data/navigation.yml` 편집:

```yaml
  - title: "Software"
    children:
      - title: "Tech Watch"
        url: /categories/sw-tech-watch/
      - title: "Python"
        url: /categories/python/
      - title: "C/C++"
        url: /categories/cpp/
      - title: "Rust"          # 새 카테고리
        url: /categories/rust/  # 새 URL
```

#### Step 2: 카테고리 페이지 생성

`_pages/category-rust.md` 생성:

```yaml
---
title: "Rust"
layout: category
permalink: /categories/rust/
taxonomy: rust
author_profile: true
sidebar:
  nav: "docs"
---
```

#### Step 3: 포스트에서 사용

```yaml
---
layout: single
title: "Rust 시작하기"
categories: rust
---
```

### 카테고리 순서 변경

`_data/navigation.yml`에서 항목 순서만 변경하면 됩니다. 사이드바는 이 파일의 순서를 반영합니다.

### 카테고리 이름 변경

1. `_data/navigation.yml`에서 `title` 업데이트
2. `_pages/category-xxx.md`에서 페이지 제목 업데이트
3. `taxonomy`나 포스트의 `categories`는 변경할 필요 없음 (이것들은 내부 식별자)

### 카테고리 삭제

1. `_data/navigation.yml`에서 제거
2. `_pages/category-xxx.md` 삭제
3. 해당 카테고리를 사용하는 포스트 업데이트

---

## 문제 해결

### 사이드바가 표시되지 않음

**확인 사항:**
1. `_config.yml` 수정 후 Jekyll 서버 재시작
2. `_config.yml` defaults에 `sidebar: nav: "docs"` 있는지 확인
3. `_data/navigation.yml`에 `docs:` 섹션 있는지 확인

### 카테고리 클릭 시 404 오류

**해결 방법:**
1. `_pages/`에 카테고리 페이지가 존재하는지 확인
2. `permalink`가 navigation.yml의 URL과 일치하는지 확인
3. `_config.yml`에 다음이 있는지 확인:
```yaml
category_archive:
  type: liquid
  path: /categories/
```

### 중첩 카테고리가 표시되지 않음

**navigation.yml 구조 확인:**
```yaml
  - title: "Parent"
    children:        # 반드시 'children' 키 사용
      - title: "Child"
        url: /url/
```

### 변경 사항이 반영되지 않음

**해결 방법:**
1. Jekyll 캐시 삭제: `rm -rf _site .jekyll-cache`
2. 서버 재시작
3. 브라우저 강력 새로고침 (Ctrl+Shift+R)

---

## 모범 사례

### 카테고리 이름 짓기

- `taxonomy` 값은 소문자 사용
- 표시 이름은 설명적인 제목 사용
- URL은 간단하고 일관되게 유지

### 구조화 팁

1. **계층 구조를 먼저 계획** - 카테고리 구조를 미리 스케치
2. **깊이 제한** - 최대 2단계 (부모 → 자식)
3. **관련 주제 그룹화** - Hardware/Software 분리
4. **"Tech Watch" 추가** - 각 도메인의 트렌드와 뉴스용

### 포스팅 워크플로우

1. 포스트 작성
2. front matter에 적절한 `categories:` 추가
3. `_posts/` 디렉토리에 파일 저장
4. `bundle exec jekyll serve`로 로컬 테스트
5. GitHub에 커밋 및 푸시

---

## 고급 커스터마이징

### 아이콘 추가

Font Awesome 아이콘을 제목에 사용:

```yaml
- title: "<i class='fas fa-code'></i> Software"
  children:
    - title: "<i class='fab fa-python'></i> Python"
      url: /categories/python/
```

### 포스트별 커스텀 사이드바

포스트 front matter에서 오버라이드:

```yaml
---
layout: single
title: "특별한 포스트"
sidebar:
  nav: "custom-nav"  # 다른 네비게이션 사용
---
```

---

## 참고 자료

- [Minimal Mistakes - Layouts](https://mmistakes.github.io/minimal-mistakes/docs/layouts/)
- [Minimal Mistakes - Navigation](https://mmistakes.github.io/minimal-mistakes/docs/navigation/)
- [Jekyll Categories](https://jekyllrb.com/docs/posts/#categories)

---

## 빠른 참조

### 수정된 파일들
- `_data/navigation.yml` - 카테고리 구조
- `_config.yml` - 사이드바 기본 설정
- `_pages/category-*.md` - 개별 카테고리 페이지
- `_posts/*.md` - 포스트 카테고리 분류

### 자주 사용하는 명령어
```bash
# 서버 시작
bundle exec jekyll serve --livereload

# config 변경 후 재시작
# Ctrl+C, 그 다음 재시작

# 캐시 삭제
rm -rf _site .jekyll-cache
```

### 요약 체크리스트
- [ ] `_data/navigation.yml` 구성
- [ ] `_config.yml` defaults 업데이트
- [ ] `_pages/`에 카테고리 페이지 생성
- [ ] 포스트에 카테고리 추가
- [ ] 로컬 테스트
- [ ] 커밋 및 푸시
