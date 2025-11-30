# 카테고리 빠른 참고

빠르게 카테고리를 추가하거나 수정할 때 참고하는 문서입니다.

---

## 📋 전체 카테고리 목록

### Introduce My Projects
```
dma              DMA 프로젝트
fpu              FPU 프로젝트
```

### Hardware
```
hw-tech-watch    Hardware Tech Watch
verilog          Verilog
systemverilog    SystemVerilog
fpga             FPGA
semiconductor    Semiconductor
circuit          Circuit
digital-design   Digital Design
microelectronic  Microelectronic
vlsi             VLSI
amba             AMBA
```

### Software
```
sw-tech-watch    Software Tech Watch
python           Python
cpp              C/C++
system-sw        System SW
```

### Linux
```
device-driver    Device Driver
linux-master     Linux Master
```

### 기타
```
overview         Overview
```

---

## ➕ 새 카테고리 추가하기 (3단계)

### 1. navigation.yml에 추가
**파일:** `_data/navigation.yml`

```yaml
# 예: Software 하위에 "Rust" 추가
  - title: "Software"
    children:
      # ... 기존 항목들 ...
      - title: "Rust"              # 사이드바 표시 이름
        url: /categories/rust/      # URL (반드시 / 로 끝!)
```

### 2. 카테고리 페이지 생성
**파일:** `_pages/category-rust.md`

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

**중요:**
- `permalink`과 navigation.yml의 `url`이 일치해야 함!
- `taxonomy`는 포스트에서 사용할 이름 (보통 소문자, 하이픈 사용)

### 3. 포스트에서 사용

```yaml
---
title: "Rust 시작하기"
categories: rust     # taxonomy와 동일!
---
```

**완료!** 🎉

---

## ✏️ 기존 카테고리 수정하기

### 표시 이름만 변경

**navigation.yml:**
```yaml
- title: "System Software"  # 이름만 변경 (OK!)
  url: /categories/system-sw/
```

**_pages/category-system-sw.md:**
```yaml
title: "System Software"  # 같이 변경해도 됨
taxonomy: system-sw       # 이건 변경 안 함!
```

**포스트:**
```yaml
categories: system-sw  # 변경 안 함!
```

### taxonomy 변경 (권장하지 않음)

taxonomy를 변경하면 **모든 포스트**의 categories도 변경해야 합니다!

1. `_pages/category-*.md`의 taxonomy 변경
2. 모든 포스트의 categories 변경
3. navigation.yml의 url도 변경 권장

---

## 🗑️ 카테고리 삭제하기

### 1. navigation.yml에서 제거
해당 항목 삭제

### 2. 카테고리 페이지 삭제
```bash
rm _pages/category-xxx.md
```

### 3. 포스트 확인
해당 카테고리를 사용하는 포스트를 다른 카테고리로 변경

---

## 🔍 문제 해결

### 404 오류
```
원인: navigation.yml의 url ≠ _pages의 permalink
해결: 두 값을 일치시키기
```

### 포스트가 안 보임
```
원인: _pages의 taxonomy ≠ _posts의 categories
해결: 두 값을 일치시키기
```

### 사이드바에 안 나타남
```
원인 1: navigation.yml에 없음 → 추가
원인 2: _config.yml 수정 후 재시작 안 함 → 재시작
해결: Ctrl+C 후 bundle exec jekyll serve
```

---

## 💡 파일 매칭 규칙

```
navigation.yml              _pages                    _posts
─────────────────────────────────────────────────────────────
url:                    ←→  permalink:           (무관)
  /categories/cpp/            /categories/cpp/

title:                  ←→  title:               (무관)
  "C/C++"                     "C/C++"

(없음)                      taxonomy:            ←→  categories:
                              cpp                      cpp
```

**핵심:**
1. `url` ↔ `permalink` 일치
2. `taxonomy` ↔ `categories` 일치
3. 모든 URL은 `/`로 끝나야 함
4. taxonomy와 categories는 **소문자**, **하이픈** 사용 권장

---

## 📝 템플릿

### navigation.yml 항목 (최상위)
```yaml
- title: "카테고리 이름"
  url: /categories/slug/
```

### navigation.yml 항목 (중첩)
```yaml
- title: "부모 카테고리"
  children:
    - title: "자식 카테고리"
      url: /categories/slug/
```

### 카테고리 페이지
```yaml
---
title: "표시 이름"
layout: category
permalink: /categories/slug/
taxonomy: slug
author_profile: true
sidebar:
  nav: "docs"
---
```

### 포스트에서 사용
```yaml
---
title: "포스트 제목"
categories: slug
---
```

---

## ⚡ 빠른 체크리스트

새 카테고리 추가 시:
- [ ] `_data/navigation.yml`에 항목 추가 (url 끝에 `/`)
- [ ] `_pages/category-{slug}.md` 생성
- [ ] `permalink`과 `url` 일치 확인
- [ ] `taxonomy` 값 확인 (소문자, 하이픈)
- [ ] Jekyll 서버 재시작 (navigation.yml 수정 시)
- [ ] 브라우저에서 확인

카테고리 수정 시:
- [ ] 표시 이름만? → `title` 수정 (taxonomy 유지)
- [ ] URL 변경? → `url`, `permalink` 모두 수정
- [ ] 식별자 변경? → `taxonomy`, `categories` 모두 수정 + 모든 포스트 업데이트

---

**자세한 내용:** [category-sidebar-guide.md](category-sidebar-guide.md)
