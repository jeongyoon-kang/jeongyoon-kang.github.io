# 블로그 자동화 스크립트

이 디렉토리에는 GitHub Pages 블로그를 쉽게 관리하기 위한 자동화 스크립트가 있습니다.

## 📋 스크립트 목록

### 1. `new-post.sh` - 새 포스트 생성
새로운 블로그 포스트와 이미지 폴더를 자동으로 생성합니다.

```bash
./scripts/new-post.sh "포스트 제목" [카테고리]
```

**예시:**
```bash
./scripts/new-post.sh "C++ Engine 만들기" sw
./scripts/new-post.sh "DMA 설계 가이드" hw
./scripts/new-post.sh "Linux 커맨드 정리" linux
```

**기능:**
- 포스트 마크다운 파일 생성 (`_posts/YYYY-MM-DD-slug.md`)
- 이미지 폴더 자동 생성 (`assets/images/YYYY-MM-DD-slug/`)
- 포스트 템플릿 자동 작성
- 복원을 위한 메타데이터 저장
- 한글 제목 자동 감지 및 영문 슬러그 입력 요청

**카테고리:**
- `overview` (기본값)
- `sw` (소프트웨어)
- `hw` (하드웨어)
- `linux` (리눅스)

---

### 2. `add-images.sh` - 이미지 추가
포스트에 이미지를 쉽게 추가합니다.

```bash
./scripts/add-images.sh <포스트-슬러그> <이미지-파일...>
```

**예시:**
```bash
./scripts/add-images.sh 2025-11-30-cpp-engine ~/Downloads/diagram.png
./scripts/add-images.sh 2025-11-30-cpp-engine ~/Pictures/*.png
```

**기능:**
- 이미지를 포스트 전용 폴더로 자동 복사
- 마크다운 코드 자동 생성
- 중복 파일 확인 및 덮어쓰기 옵션
- 복사된 이미지 목록 표시

---

### 3. `list-posts.sh` - 포스트 목록 조회
모든 포스트 또는 특정 카테고리의 포스트 목록을 조회합니다.

```bash
./scripts/list-posts.sh [카테고리]
```

**예시:**
```bash
./scripts/list-posts.sh          # 모든 포스트
./scripts/list-posts.sh sw       # SW 카테고리만
./scripts/list-posts.sh hw       # HW 카테고리만
```

**표시 정보:**
- 포스트 제목
- 파일 경로
- 날짜 및 카테고리
- 이미지 개수
- 슬러그 (삭제/복원 시 사용)

---

### 4. `delete-post.sh` - 포스트 삭제 (안전 백업)
포스트를 삭제하되 복원 가능하도록 백업합니다.

```bash
./scripts/delete-post.sh <포스트-슬러그> [--force]
```

**예시:**
```bash
./scripts/delete-post.sh 2025-11-30-test-post
./scripts/delete-post.sh 2025-11-30-test-post --force  # 확인 없이 삭제
```

**기능:**
- 포스트 파일 백업
- 이미지 폴더 백업
- 메타데이터 백업
- 복원 정보 생성
- 삭제 전 확인 (--force 옵션으로 스킵 가능)

**백업 위치:**
`.backup/trash/YYYYMMDD-HHMMSS/`

---

### 5. `restore-post.sh` - 포스트 복원
삭제한 포스트를 복원합니다.

```bash
./scripts/restore-post.sh <백업-ID>
```

**예시:**
```bash
./scripts/restore-post.sh 20251130-143022
```

**백업 목록 확인:**
```bash
ls -lt .backup/trash/
```

**기능:**
- 포스트 파일 복원
- 이미지 폴더 복원
- 메타데이터 복원
- 충돌 시 덮어쓰기 확인
- 원본 백업 보존 (복원 후에도 백업 유지)

---

## 🎯 일반적인 워크플로우

### 1. 새 포스트 작성하기

```bash
# 1. 새 포스트 생성
./scripts/new-post.sh "OpenMP 병렬처리 가이드" sw

# 한글 제목이면 영문 슬러그 입력 (예: openmp-parallel-guide)

# 2. 포스트 목록 확인
./scripts/list-posts.sh

# 3. 이미지 추가
./scripts/add-images.sh 2025-11-30-openmp-parallel-guide ~/Downloads/*.png

# 4. 포스트 편집
vim _posts/2025-11-30-openmp-parallel-guide.md

# 5. 로컬에서 확인
bundle exec jekyll serve

# 6. 커밋 및 푸시
git add .
git commit -m "Add: OpenMP 병렬처리 가이드"
git push
```

### 2. 포스트 수정하기

```bash
# 1. 포스트 목록에서 슬러그 확인
./scripts/list-posts.sh

# 2. 이미지 추가 (필요시)
./scripts/add-images.sh 2025-11-30-openmp-parallel-guide ~/Downloads/new-image.png

# 3. 포스트 편집
vim _posts/2025-11-30-openmp-parallel-guide.md
```

### 3. 포스트 삭제하기

```bash
# 1. 삭제 (백업됨)
./scripts/delete-post.sh 2025-11-30-test-post

# 2. 실수로 삭제했다면 복원
./scripts/restore-post.sh 20251130-143022
```

---

## 📁 디렉토리 구조

```
jeongyoon-kang.github.io/
├── _posts/                          # 포스트 마크다운 파일
│   ├── 2025-10-25-first.md
│   ├── 2025-11-30-cpp-engine.md
│   └── ...
├── assets/images/                   # 이미지 파일 (포스트별)
│   ├── 2025-10-25-first/
│   │   ├── welcome.png
│   │   └── diagram.png
│   ├── 2025-11-30-cpp-engine/
│   │   ├── architecture.png
│   │   └── benchmark.png
│   └── ...
├── .backup/                         # 백업 및 메타데이터
│   ├── *.meta                       # 포스트 메타데이터
│   └── trash/                       # 삭제된 포스트 백업
│       └── YYYYMMDD-HHMMSS/
│           ├── *.md
│           ├── */                   # 이미지 폴더
│           └── restore-info.txt
└── scripts/                         # 자동화 스크립트
    ├── new-post.sh
    ├── add-images.sh
    ├── list-posts.sh
    ├── delete-post.sh
    └── restore-post.sh
```

---

## 🎨 포스트에서 이미지 사용하기

### 기본 사용법
```markdown
![이미지 설명](/assets/images/2025-11-30-cpp-engine/architecture.png)
```

### 전체 너비로 표시
```markdown
![이미지 설명](/assets/images/2025-11-30-cpp-engine/architecture.png)
{: .full}
```

### 2개 나란히
```html
<figure class="half">
    <img src="/assets/images/2025-11-30-cpp-engine/image1.png">
    <img src="/assets/images/2025-11-30-cpp-engine/image2.png">
    <figcaption>두 이미지 설명</figcaption>
</figure>
```

### 3개 나란히
```html
<figure class="third">
    <img src="/assets/images/2025-11-30-cpp-engine/image1.png">
    <img src="/assets/images/2025-11-30-cpp-engine/image2.png">
    <img src="/assets/images/2025-11-30-cpp-engine/image3.png">
    <figcaption>세 이미지 설명</figcaption>
</figure>
```

---

## ⚙️ 고급 설정

### 포스트 템플릿 커스터마이징

`new-post.sh` 파일의 템플릿 섹션을 수정하여 기본 포스트 구조를 변경할 수 있습니다:

```bash
# 파일: scripts/new-post.sh
# 라인: "cat > "$POST_PATH" << EOF" 부분
```

### 이미지 경로 변수 활용

포스트 Front Matter에 이미지 경로를 정의하여 재사용:

```yaml
---
title: "My Post"
image_path: /assets/images/2025-11-30-my-post
---

![Image 1]({{ page.image_path }}/screenshot.png)
![Image 2]({{ page.image_path }}/diagram.png)
```

---

## 🔍 문제 해결

### 스크립트 실행 권한 오류
```bash
chmod +x scripts/*.sh
```

### 한글 제목 슬러그 문제
스크립트가 자동으로 감지하여 영문 슬러그 입력을 요청합니다.

### 백업 복원 실패
백업 ID를 확인하세요:
```bash
ls -lt .backup/trash/
```

---

## 📝 참고 사항

- **백업 파일**: `.backup/trash/` 디렉토리의 백업은 자동으로 삭제되지 않습니다. 주기적으로 확인하여 정리하세요.
- **Git 관리**: `.backup/` 디렉토리는 `.gitignore`에 추가하는 것을 권장합니다.
- **이미지 최적화**: 웹 성능을 위해 이미지를 추가하기 전에 압축하는 것을 권장합니다.

---

## 💡 팁

1. **alias 설정**: 자주 사용하는 명령어를 `.bashrc` 또는 `.zshrc`에 추가
   ```bash
   alias new-post="./scripts/new-post.sh"
   alias list-posts="./scripts/list-posts.sh"
   alias add-images="./scripts/add-images.sh"
   ```

2. **이미지 이름 규칙**: 이미지 파일명을 설명적으로 작성
   - ✅ `openmp-architecture-diagram.png`
   - ❌ `image1.png`

3. **카테고리 일관성**: 카테고리 이름을 일관되게 사용
   - `sw`, `hw`, `linux`, `overview`
