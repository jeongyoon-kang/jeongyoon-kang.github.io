# 카테고리 사이드바 설정 가이드

Minimal Mistakes 테마를 사용하는 GitHub Pages 블로그에 카테고리별 사이드바 네비게이션을 추가하는 방법을 안내합니다.

---

## 목차
1. [개요](#개요)
2. [설정 방법](#설정-방법)
3. [포스트에 카테고리 추가하기](#포스트에-카테고리-추가하기)
4. [카테고리 추가/수정하기](#카테고리-추가수정하기)
5. [문제 해결](#문제-해결)

---

## 개요

이 가이드를 따라하면 블로그의 모든 포스트 페이지에 카테고리 네비게이션이 포함된 사이드바가 표시됩니다.

**현재 설정된 카테고리:**
- About - 개인 소개 (학력, 경력, 프로젝트)
- Introduction - 블로그 운영 방향 및 포스팅 계획
- Software - 소프트웨어 관련 글
- Hardware - 하드웨어 관련 글
- Linux - 리눅스 활용법
- Python - Python 관련 글
- C/C++ - C/C++ 관련 글

---

## 설정 방법

### 1. 카테고리 네비게이션 데이터 파일 설정

**파일 위치:** `_data/navigation.yml`

```yaml
# main links
main:
  - title: "Quick-Start Guide"
    url: https://mmistakes.github.io/minimal-mistakes/docs/quick-start-guide/

# sidebar navigation for categories
docs:
  - title: "Categories"
    children:
      - title: "About"
        url: /categories/about/
      - title: "Introduction"
        url: /categories/introduction/
      - title: "Software"
        url: /categories/software/
      - title: "Hardware"
        url: /categories/hardware/
      - title: "Linux"
        url: /categories/linux/
      - title: "Python"
        url: /categories/python/
      - title: "C/C++"
        url: /categories/cpp/
```

**설명:**
- `docs`: 사이드바 네비게이션의 ID입니다 (원하는 이름으로 변경 가능)
- `title`: 사이드바에 표시될 카테고리 이름
- `url`: 카테고리 페이지로 이동하는 URL
- `children`: 하위 메뉴 항목들

---

### 2. _config.yml에서 사이드바 활성화

**파일 위치:** `_config.yml`

파일 하단의 `defaults` 섹션에 다음 내용을 추가합니다:

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
        nav: "docs"  # 이 두 줄이 추가된 부분입니다!
```

**설명:**
- `sidebar`: 사이드바를 활성화합니다
- `nav: "docs"`: `_data/navigation.yml`에서 정의한 `docs` 네비게이션을 사용합니다

**중요:** `_config.yml`을 수정한 후에는 반드시 Jekyll 서버를 재시작해야 합니다!

```bash
# Jekyll 서버를 실행 중이라면
# Ctrl+C로 중지한 후 다시 실행
bundle exec jekyll serve
```

---

## 포스트에 카테고리 추가하기

새로운 포스트를 작성하거나 기존 포스트를 수정할 때, front matter에 `categories` 필드를 추가하세요.

### 예시 1: 단일 카테고리

```yaml
---
layout: post
title: "Python으로 데이터 분석하기"
categories: python
---

여기에 포스트 내용을 작성합니다...
```

### 예시 2: 여러 카테고리

```yaml
---
layout: post
title: "C++로 Python 확장 모듈 만들기"
categories: [cpp, python]
---

여기에 포스트 내용을 작성합니다...
```

### 사용 가능한 카테고리 이름

- `about` - About 카테고리 (개인 소개, 학력, 경력, 프로젝트)
- `introduction` - Introduction 카테고리 (블로그 운영 방향, 포스팅 계획)
- `software` - Software 카테고리
- `hardware` - Hardware 카테고리
- `linux` - Linux 카테고리
- `python` - Python 카테고리
- `cpp` - C/C++ 카테고리

**참고:** 카테고리 이름은 소문자로 작성하는 것이 권장됩니다.

---

## 카테고리 추가/수정하기

### 새로운 카테고리 추가

`_data/navigation.yml` 파일을 열고 `docs` 섹션의 `children` 아래에 새 항목을 추가합니다:

```yaml
docs:
  - title: "Categories"
    children:
      - title: "Software"
        url: /categories/software/
      - title: "Hardware"
        url: /categories/hardware/
      - title: "Linux"
        url: /categories/linux/
      - title: "Python"
        url: /categories/python/
      - title: "C/C++"
        url: /categories/cpp/
      - title: "AI/ML"          # 새로운 카테고리 추가
        url: /categories/ai/    # URL도 함께 설정
```

### 카테고리 이름 변경

`title` 값을 원하는 이름으로 변경하면 됩니다:

```yaml
- title: "머신러닝"  # 한글 이름도 가능
  url: /categories/ml/
```

### 카테고리 삭제

해당 카테고리 항목(title과 url)을 삭제하면 됩니다.

---

## 문제 해결

### Q1. 사이드바가 표시되지 않아요

**해결 방법:**
1. `_config.yml`을 수정한 후 Jekyll 서버를 재시작했는지 확인
2. `_config.yml`의 `defaults` 섹션에 `sidebar: nav: "docs"`가 올바르게 추가되었는지 확인
3. `_data/navigation.yml`에 `docs` 섹션이 올바르게 작성되었는지 확인

### Q2. 카테고리 링크를 클릭하면 404 에러가 나요

**해결 방법:**
- `_config.yml`에 카테고리 아카이브 설정이 있는지 확인:

```yaml
category_archive:
  type: liquid
  path: /categories/
```

- Minimal Mistakes 테마는 자동으로 카테고리 페이지를 생성합니다.

### Q3. 사이드바가 저자 프로필을 가려요

**해결 방법:**

특정 포스트에서만 저자 프로필을 숨기고 싶다면, 포스트의 front matter에서 설정을 변경할 수 있습니다:

```yaml
---
layout: single
title: "포스트 제목"
categories: software
author_profile: false  # 저자 프로필 숨김
---
```

또는 사이드바를 오른쪽에 배치하려면:

```yaml
defaults:
  - scope:
      path: ""
      type: posts
    values:
      layout: single
      author_profile: true
      read_time: true
      sidebar:
        nav: "docs"
      classes: wide  # 더 넓은 레이아웃 사용
```

### Q4. 사이드바 위치를 변경하고 싶어요

개별 포스트의 front matter에서 설정할 수 있습니다:

```yaml
---
layout: single
title: "포스트 제목"
sidebar:
  nav: "docs"
  position: right  # 왼쪽(left) 또는 오른쪽(right)
---
```

---

## 추가 커스터마이징

### 카테고리 아이콘 추가

Font Awesome 아이콘을 사용할 수 있습니다:

```yaml
docs:
  - title: "Categories"
    children:
      - title: "<i class='fas fa-code'></i> Software"
        url: /categories/software/
      - title: "<i class='fas fa-microchip'></i> Hardware"
        url: /categories/hardware/
```

### 계층적 카테고리 구조

중첩된 카테고리를 만들 수도 있습니다:

```yaml
docs:
  - title: "Programming"
    children:
      - title: "Python"
        url: /categories/python/
      - title: "C/C++"
        url: /categories/cpp/

  - title: "Engineering"
    children:
      - title: "Hardware"
        url: /categories/hardware/
      - title: "FPGA"
        url: /categories/fpga/
```

---

## 참고 자료

- [Minimal Mistakes 공식 문서 - 레이아웃](https://mmistakes.github.io/minimal-mistakes/docs/layouts/)
- [Minimal Mistakes 공식 문서 - 네비게이션](https://mmistakes.github.io/minimal-mistakes/docs/navigation/)
- [Jekyll 카테고리 가이드](https://jekyllrb.com/docs/posts/#categories)

---

## 요약

1. `_data/navigation.yml`에 카테고리 목록 추가
2. `_config.yml`의 `defaults` 섹션에 `sidebar: nav: "docs"` 추가
3. 각 포스트 front matter에 `categories: 카테고리명` 추가
4. Jekyll 서버 재시작 (config 파일 수정 시)
5. GitHub에 푸시하여 배포

**완료!** 이제 모든 포스트에 카테고리 사이드바가 표시됩니다.
