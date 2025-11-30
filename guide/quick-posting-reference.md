# 포스팅 빠른 참고

빠르게 포스트를 작성할 때 참고하는 문서입니다.

---

## 🚀 빠른 시작

### 방법 1: 자동화 스크립트 (권장)

```bash
# 새 포스트 생성
./scripts/new-post.sh "포스트 제목" cpp

# 이미지 추가
./scripts/add-images.sh 2025-11-30-slug ~/Downloads/image.png

# 포스트 편집
vim _posts/2025-11-30-slug.md
```

### 방법 2: 수동 생성

```bash
# 1. 파일 생성
touch _posts/2025-11-30-my-post.md

# 2. 템플릿 복사 (아래 참고)

# 3. 편집
vim _posts/2025-11-30-my-post.md
```

---

## 📝 포스트 템플릿

### 최소 템플릿
```yaml
---
layout: single
title: "포스트 제목"
categories: cpp
---

포스트 내용...
```

### 추천 템플릿
```yaml
---
layout: single
title: "포스트 제목"
date: 2025-11-30 14:00:00
categories: cpp
tags:
  - tag1
  - tag2
toc: true
toc_sticky: true
toc_label: "목차"
---

# 제목

내용...

## 섹션 1

내용...

## 섹션 2

내용...
```

### 풀옵션 템플릿
```yaml
---
layout: single
title: "완전한 포스트 제목"
date: 2025-11-30 14:00:00
last_modified_at: 2025-12-01 10:00:00
categories: [cpp, tutorial]
tags:
  - cpp
  - performance
  - tutorial
excerpt: "이 포스트는 C++ 성능 최적화에 대해 다룹니다."
header:
  teaser: /assets/images/2025-11-30-slug/thumbnail.jpg
toc: true
toc_label: "목차"
toc_sticky: true
author_profile: true
read_time: true
comments: true
share: true
related: true
---

내용...
```

---

## 📂 파일명 규칙

**형식:** `YYYY-MM-DD-slug.md`

**예시:**
```
_posts/2025-11-30-cpp-optimization.md
_posts/2025-12-01-fpga-design-tips.md
_posts/2025-12-02-python-async-guide.md
```

**규칙:**
- 날짜: `YYYY-MM-DD`
- 슬러그: 소문자, 하이픈 사용
- 확장자: `.md`

---

## 🏷️ 카테고리 사용

### 단일 카테고리
```yaml
categories: cpp
```

### 다중 카테고리
```yaml
categories: [cpp, tutorial]
```

### 사용 가능한 카테고리

```
Projects:
  dma, fpu

Hardware:
  hw-tech-watch, verilog, systemverilog, fpga,
  semiconductor, circuit, digital-design,
  microelectronic, vlsi, amba

Software:
  sw-tech-watch, python, cpp, system-sw

Linux:
  device-driver, linux-master

기타:
  overview
```

---

## 🖼️ 이미지 사용

### 이미지 저장
```
assets/images/2025-11-30-post-slug/
├── image1.png
├── image2.jpg
└── diagram.png
```

### 마크다운에서 사용
```markdown
![이미지 설명](/assets/images/2025-11-30-post-slug/image1.png)
```

### 자동화 스크립트로 추가
```bash
./scripts/add-images.sh 2025-11-30-post-slug ~/Downloads/*.png
```

---

## 💻 코드 블록

### 기본
````markdown
```python
def hello():
    print("Hello, World!")
```
````

### 지원 언어
```
python, cpp, c, java, javascript,
bash, shell, verilog, systemverilog,
yaml, json, html, css
```

---

## 🎨 특수 기능

### 알림 블록
```markdown
**참고:** 이것은 참고사항입니다.
{: .notice--info}

**경고:** 주의하세요!
{: .notice--warning}

**성공:** 완료되었습니다!
{: .notice--success}
```

### 이미지 정렬
```markdown
![좌측](/image.jpg){: .align-left}
![중앙](/image.jpg){: .align-center}
![우측](/image.jpg){: .align-right}
```

### 버튼
```markdown
[다운로드](https://example.com){: .btn .btn--primary}
```

---

## 🔄 로컬 테스트 워크플로우

```bash
# 1. 서버 시작
bundle exec jekyll serve --livereload

# 2. 브라우저에서 확인
# http://localhost:4000

# 3. 파일 저장하면 자동 새로고침됨
```

---

## 📤 발행 워크플로우

```bash
# 1. 포스트 작성
vim _posts/2025-11-30-my-post.md

# 2. 로컬 테스트
bundle exec jekyll serve --livereload

# 3. Git 추가
git add _posts/2025-11-30-my-post.md
git add assets/images/2025-11-30-my-post/

# 4. 커밋
git commit -m "feat: Add post about C++ optimization"

# 5. 푸시
git push

# 6. GitHub Pages가 자동 빌드 (1-5분 소요)
```

---

## 🛠️ 자주 사용하는 Front Matter

### 목차
```yaml
toc: true           # 목차 활성화
toc_sticky: true    # 스크롤 시 고정
toc_label: "목차"   # 목차 제목
```

### 이미지
```yaml
header:
  teaser: /assets/images/2025-11-30-slug/thumb.jpg
```

### 발췌문
```yaml
excerpt: "포스트 미리보기 텍스트"
```

### 날짜
```yaml
date: 2025-11-30 14:00:00
last_modified_at: 2025-12-01 10:00:00
```

---

## ⚠️ 주의사항

### Front Matter
- 시작과 끝에 `---` 필수
- YAML 문법 준수 (들여쓰기 중요)
- 스페이스 사용 (탭 사용 금지)

### 카테고리
- taxonomy와 일치해야 함
- 소문자, 하이픈 사용
- 공백 사용 금지 (`System SW` ❌, `system-sw` ✅)

### 이미지
- 절대 경로 사용 (`/assets/images/...`)
- 상대 경로 금지 (`../assets/...` ❌)

### 코드 블록
- 열고 닫기 확인 (```)
- 언어 명시 권장

---

## 🔍 문제 해결

### 포스트가 안 보임
```
원인 1: 미래 날짜 → 날짜 수정
원인 2: 잘못된 디렉토리 → _posts/로 이동
원인 3: 파일명 형식 오류 → YYYY-MM-DD-slug.md 확인
원인 4: Front Matter 오류 → YAML 문법 확인
```

### 이미지가 안 보임
```
원인: 상대 경로 사용
해결: /assets/images/... 절대 경로 사용
```

### 서식이 깨짐
```
원인 1: Front Matter --- 누락
원인 2: 코드 블록 안 닫힘 (```)
원인 3: YAML 들여쓰기 오류
```

### 카테고리 페이지에 안 나타남
```
원인: categories와 taxonomy 불일치
해결: 값을 일치시키기
```

---

## 📋 체크리스트

포스트 발행 전:
- [ ] 파일명 형식 확인 (`YYYY-MM-DD-slug.md`)
- [ ] `_posts/` 디렉토리에 위치
- [ ] Front Matter 작성 완료
- [ ] 카테고리 지정 (taxonomy와 일치)
- [ ] 이미지 경로 확인 (절대 경로)
- [ ] 코드 블록 닫기 확인
- [ ] 로컬 테스트 완료
- [ ] 맞춤법 확인
- [ ] Git 커밋 및 푸시

---

## 🎯 스크립트 명령어

```bash
# 새 포스트
./scripts/new-post.sh "제목" 카테고리

# 이미지 추가
./scripts/add-images.sh 슬러그 이미지파일

# 포스트 목록
./scripts/list-posts.sh

# 포스트 삭제 (백업됨)
./scripts/delete-post.sh 슬러그

# 복원
./scripts/restore-post.sh 백업ID
```

---

**자세한 내용:** [posting-guide.md](posting-guide.md)
