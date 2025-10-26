# 블로그 포스팅 가이드

Jekyll과 Minimal Mistakes 테마로 블로그 포스트를 작성하고 발행하는 완전 가이드

---

## 목차
1. [빠른 시작](#빠른-시작)
2. [포스트 파일 구조](#포스트-파일-구조)
3. [Front Matter 레퍼런스](#front-matter-레퍼런스)
4. [콘텐츠 작성하기](#콘텐츠-작성하기)
5. [카테고리 가이드](#카테고리-가이드)
6. [발행 워크플로우](#발행-워크플로우)

---

## 빠른 시작

### 새 포스트 만들기

1. **`_posts/` 디렉토리에 파일 생성**
2. **파일명 형식**: `YYYY-MM-DD-제목.md`
3. **상단에 front matter 추가**
4. **마크다운으로 내용 작성**
5. **발행 전 로컬에서 테스트**

### 최소 포스트 템플릿

```markdown
---
layout: single
title: "포스트 제목"
categories: 카테고리명
---

여기에 내용을 작성합니다...
```

---

## 포스트 파일 구조

### 파일명 규칙

**형식:** `YYYY-MM-DD-포스트-제목.md`

**예시:**
```
_posts/2025-10-27-first-fpga-project.md
_posts/2025-10-27-python-threading-tutorial.md
_posts/2025-11-01-semiconductor-process-overview.md
```

**규칙:**
- 날짜는 `YYYY-MM-DD` 형식
- 제목은 소문자와 하이픈 사용
- 확장자는 `.md` 또는 `.markdown`
- 미래 날짜는 해당 날짜까지 표시되지 않음 (설정으로 변경 가능)

### 디렉토리 위치

모든 포스트는 `_posts/` 디렉토리에 위치해야 합니다:

```
jeongyoon-kang.github.io/
├── _posts/
│   ├── 2025-10-27-first-post.md
│   ├── 2025-10-27-second-post.md
│   └── 2025-10-28-third-post.md
├── _pages/
├── _data/
└── ...
```

---

## Front Matter 레퍼런스

Front Matter는 포스트 파일 상단의 YAML 블록입니다.

### 필수 필드

```yaml
---
layout: single
title: "포스트 제목"
categories: 카테고리명
---
```

### 주요 옵션 필드

```yaml
---
layout: single
title: "완전한 포스트 제목"
categories: python
date: 2025-10-27 14:30:00 +0900
last_modified_at: 2025-10-28 10:00:00 +0900
excerpt: "포스트 목록에 표시될 간단한 설명"
header:
  teaser: /assets/images/post-thumbnail.jpg
  overlay_image: /assets/images/header-image.jpg
  overlay_filter: 0.5
tags:
  - python
  - 튜토리얼
  - 초보자
toc: true
toc_label: "목차"
toc_icon: "list"
toc_sticky: true
author_profile: true
read_time: true
comments: true
share: true
related: true
---
```

### 필드 설명

#### 레이아웃
```yaml
layout: single  # 모든 포스트에 'single' 사용
```

#### 제목
```yaml
title: "포스트 제목"
# 메인 제목으로 표시됨
# 특수문자, 공백 등 사용 가능
```

#### 카테고리
```yaml
# 단일 카테고리
categories: python

# 여러 카테고리
categories: [python, tutorial]

# 또는 다른 문법
categories:
  - python
  - tutorial
```

**사용 가능한 카테고리:**
- `overview` - 블로그 소개/방향
- `hw-tech-watch` - 하드웨어 기술 뉴스
- `verilog` - Verilog HDL
- `systemverilog` - SystemVerilog
- `fpga` - FPGA 설계
- `semiconductor` - 반도체 공정
- `sw-tech-watch` - 소프트웨어 기술 뉴스
- `python` - Python 프로그래밍
- `cpp` - C/C++ 프로그래밍
- `linux` - Linux 팁과 튜토리얼

#### 날짜 & 시간
```yaml
# 명시적 날짜 (파일명 날짜 덮어씀)
date: 2025-10-27 14:30:00 +0900

# 마지막 수정 시간
last_modified_at: 2025-10-28 10:00:00 +0900
```

#### 발췌문
```yaml
# 포스트 미리보기용 커스텀 발췌문
excerpt: "Python에서 async I/O를 구현하는 방법을 실용적인 예제와 함께 배웁니다."

# 또는 본문에서 <!--more--> 사용
```

#### 태그
```yaml
tags:
  - python
  - async
  - 성능
  - 튜토리얼
```

#### 목차
```yaml
toc: true                    # 목차 활성화
toc_label: "이 페이지의 내용"   # 목차 제목
toc_icon: "list"             # Font Awesome 아이콘
toc_sticky: true             # 스크롤 시 목차 고정
```

#### 이미지
```yaml
header:
  teaser: /assets/images/thumb.jpg           # 목록 썸네일
  image: /assets/images/header.jpg           # 포스트 헤더 이미지
  overlay_image: /assets/images/overlay.jpg  # 전체 너비 오버레이
  overlay_filter: 0.5                        # 오버레이 어둡게 (0-1)
  caption: "사진 출처: [작성자](https://example.com)"
```

#### 표시 옵션
```yaml
author_profile: true   # 저자 사이드바 표시
read_time: true        # 예상 읽기 시간 표시
comments: true         # 댓글 활성화 (설정된 경우)
share: true           # 공유 버튼 표시
related: true         # 관련 포스트 표시
classes: wide         # 더 넓은 레이아웃 사용
```

---

## 콘텐츠 작성하기

### 마크다운 기초

#### 제목
```markdown
# H1 제목
## H2 제목
### H3 제목
#### H4 제목
```

**주의:** H1은 포스트 제목용이므로, 본문은 H2부터 시작하세요.

#### 텍스트 서식
```markdown
**굵은 텍스트**
*기울임 텍스트*
***굵은 기울임***
~~취소선~~
`인라인 코드`
```

#### 링크
```markdown
[링크 텍스트](https://example.com)
[제목이 있는 링크](https://example.com "제목 텍스트")
```

#### 이미지
```markdown
![대체 텍스트](/assets/images/image.jpg)
![대체 텍스트](/assets/images/image.jpg "이미지 제목")
```

#### 리스트

**순서 없는 목록:**
```markdown
- 항목 1
- 항목 2
  - 중첩 항목
  - 또 다른 중첩 항목
- 항목 3
```

**순서 있는 목록:**
```markdown
1. 첫 번째 항목
2. 두 번째 항목
3. 세 번째 항목
```

#### 코드 블록

**인라인 코드:**
```markdown
변수에는 `variable_name`을 사용하세요.
```

**문법 강조가 있는 코드 블록:**
````markdown
```python
def hello_world():
    print("Hello, World!")
```
````

**지원 언어:**
- `python`, `cpp`, `c`, `java`, `javascript`
- `bash`, `shell`, `console`
- `verilog`, `systemverilog`, `vhdl`
- `yaml`, `json`, `xml`, `html`, `css`

#### 인용구
```markdown
> 이것은 인용구입니다.
> 여러 줄에 걸쳐 작성할 수 있습니다.
>
> 그리고 여러 문단도 포함할 수 있습니다.
```

#### 표
```markdown
| 헤더 1 | 헤더 2 | 헤더 3 |
|--------|--------|--------|
| 셀 1   | 셀 2   | 셀 3   |
| 셀 4   | 셀 5   | 셀 6   |
```

#### 수평선
```markdown
---
```

### 특수 기능

#### 알림 블록

Minimal Mistakes는 알림 블록을 제공합니다:

```markdown
**참고:** 이것은 참고사항입니다.
{: .notice}

**경고:** 이것은 경고 메시지입니다.
{: .notice--warning}

**정보:** 이것은 정보 메시지입니다.
{: .notice--info}

**성공:** 이것은 성공 메시지입니다.
{: .notice--success}

**위험:** 이것은 위험 메시지입니다.
{: .notice--danger}
```

#### 버튼 링크
```markdown
[버튼 텍스트](https://example.com){: .btn .btn--primary}
[다른 버튼](https://example.com){: .btn .btn--success}
```

#### 이미지 정렬
```markdown
![왼쪽 정렬](/assets/images/image.jpg){: .align-left}
![가운데 정렬](/assets/images/image.jpg){: .align-center}
![오른쪽 정렬](/assets/images/image.jpg){: .align-right}
```

#### 캡션이 있는 그림
```markdown
{% raw %}
{% include figure image_path="/assets/images/image.jpg" alt="설명" caption="이것은 캡션입니다." %}
{% endraw %}
```

---

## 카테고리 가이드

### 올바른 카테고리 선택하기

**Overview** - 다음 용도로 사용:
- 블로그 공지사항
- 포스팅 방향 업데이트
- 다른 카테고리에 맞지 않는 일반적인 생각

**하드웨어 카테고리:**
- `hw-tech-watch` - 업계 뉴스, 트렌드, 아티클
- `verilog` - Verilog HDL 전용 콘텐츠
- `systemverilog` - SystemVerilog와 검증
- `fpga` - FPGA 설계와 구현
- `semiconductor` - 공정 기술, 제조

**소프트웨어 카테고리:**
- `sw-tech-watch` - 업계 뉴스, 트렌드, 아티클
- `python` - Python 프로그래밍, 패키지, 팁
- `cpp` - C/C++ 프로그래밍, 최적화
- `linux` - Linux 관리, 팁, 튜토리얼

### 다중 카테고리 포스트

여러 주제를 다루는 경우 여러 카테고리 사용:

```yaml
---
layout: single
title: "Python으로 Verilog 생성하기"
categories: [python, verilog]
---
```

**가이드라인:**
- 포스트당 최대 2-3개 카테고리
- 주요 카테고리를 먼저
- 관련 카테고리만 사용

---

## 발행 워크플로우

### 로컬 테스트

#### 1. Jekyll 서버 시작
```bash
cd /path/to/jeongyoon-kang.github.io
bundle exec jekyll serve --livereload
```

#### 2. 브라우저에서 확인
```
http://localhost:4000
```

#### 3. 포스트 확인
- 서식 확인
- 모든 링크 테스트
- 이미지 로딩 확인
- 모바일 뷰 확인

### 변경사항 커밋하기

#### 1. 상태 확인
```bash
git status
```

#### 2. 새 포스트 추가
```bash
git add _posts/2025-10-27-your-post.md
# 이미지도 추가
git add assets/images/your-image.jpg
```

#### 3. Conventional Commit 메시지로 커밋
```bash
git commit -m "feat: Python 스레딩에 관한 포스트 추가

- async/await 개념 설명
- 실용적인 예제 포함
- 성능 벤치마크 추가"
```

**커밋 메시지 형식:**
- `feat:` - 새 포스트
- `fix:` - 포스트의 오타나 오류 수정
- `docs:` - 문서 업데이트
- `style:` - 서식 변경

#### 4. GitHub에 푸시
```bash
git push origin master
# 또는
git push origin main
```

#### 5. 배포 확인
- GitHub Pages가 자동으로 빌드
- `https://jeongyoon-kang.github.io` 확인
- 1-5분 정도 소요될 수 있음

---

## 팁 & 모범 사례

### 작성 팁

1. **설명적인 제목 사용** - 독자와 SEO에 도움
2. **목차 추가** - 긴 포스트용 (toc: true)
3. **코드 예제 포함** - 보여주기, 단순 설명만 하지 말기
4. **이미지 추가** - 텍스트 나누기, 개념 설명
5. **섹션으로 작성** - 제목 사용 (##, ###)
6. **먼저 로컬에서 미리보기** - 푸시 전 항상 테스트

### SEO 팁

1. **Front matter에 excerpt** - 매력적인 설명 작성
2. **제목에 키워드 사용** - 하지만 자연스럽게
3. **이미지에 alt 텍스트 추가** - 접근성과 SEO에 도움
4. **내부 링크** - 다른 포스트에 링크
5. **적절한 제목 사용** - 구조화된 H2, H3, H4

### 파일 정리

```
assets/
├── images/
│   ├── 2025/
│   │   ├── 10/
│   │   │   ├── post-name-image1.jpg
│   │   │   └── post-name-image2.jpg
│   │   └── 11/
│   └── ...
```

**이미지 명명 규칙:**
- 설명적인 이름
- 포스트 참조 포함
- 연도/월별로 정리

---

## 자주 발생하는 문제

### 포스트가 표시되지 않음

**원인:**
1. 파일명의 미래 날짜
2. 잘못된 디렉토리 (`_posts/`가 아님)
3. 잘못된 파일명 형식
4. Front matter의 문법 오류

**해결책:**
```yaml
# 미래 포스트 강제 표시
date: 2025-10-27
# 또는 파일명에 과거 날짜 사용
```

### 서식이 깨짐

**확인사항:**
1. Front matter에 `---` 구분자 있는지
2. YAML 들여쓰기가 올바른지
3. 탭이 아닌 스페이스 사용
4. 코드 블록 닫힘 (```)

### 이미지가 로드되지 않음

**수정:**
```markdown
# 루트에서 절대 경로 사용
![이미지](/assets/images/image.jpg)

# 상대 경로 사용 금지
![이미지](../assets/images/image.jpg)  # ❌ 잘못됨
```

---

## 빠른 참조

### 최소 포스트
```yaml
---
layout: single
title: "포스트 제목"
categories: 카테고리명
---

내용...
```

### 전체 기능 포스트
```yaml
---
layout: single
title: "완전 튜토리얼: Python 비동기 프로그래밍"
date: 2025-10-27 14:00:00 +0900
categories: [python, tutorial]
tags:
  - python
  - async
  - 동시성
excerpt: "실용적인 예제로 Python 비동기 프로그래밍 마스터하기"
header:
  teaser: /assets/images/2025/10/python-async-thumb.jpg
toc: true
toc_label: "목차"
toc_sticky: true
---

## 소개

여기에 소개를 작성...

## 섹션 1

내용...

## 섹션 2

더 많은 내용...

## 결론

마무리...
```

### 필수 명령어
```bash
# 서버 시작
bundle exec jekyll serve --livereload

# 로컬에서 포스트 테스트
# http://localhost:4000 방문

# 커밋 및 푸시
git add _posts/your-post.md
git commit -m "feat: 새 포스트 추가"
git push
```

---

## 체크리스트

발행 전 확인사항:

- [ ] 파일명 형식: `YYYY-MM-DD-제목.md`
- [ ] `_posts/` 디렉토리에 파일 위치
- [ ] Front matter 완성
- [ ] 카테고리 지정
- [ ] 코드 블록에 문법 강조
- [ ] 이미지 정상 로드
- [ ] 링크 테스트
- [ ] 맞춤법/문법 확인
- [ ] 로컬 테스트 완료
- [ ] 설명적인 커밋 메시지
- [ ] GitHub에 푸시

**즐거운 블로깅 되세요!** 🚀
