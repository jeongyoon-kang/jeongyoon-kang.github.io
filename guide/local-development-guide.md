# 로컬 개발 환경 가이드

GitHub Pages 블로그를 로컬에서 실행하고 테스트하는 방법을 안내합니다.

---

## 목차
1. [사전 요구사항](#사전-요구사항)
2. [로컬에서 블로그 실행하기](#로컬에서-블로그-실행하기)
3. [변경사항 확인하기](#변경사항-확인하기)
4. [자주 발생하는 문제](#자주-발생하는-문제)

---

## 사전 요구사항

Jekyll 블로그를 로컬에서 실행하려면 다음이 설치되어 있어야 합니다:

### 필수 설치 항목

1. **Ruby** (버전 2.7 이상)
2. **Bundler** (Ruby 패키지 관리자)
3. **Jekyll** (정적 사이트 생성기)

### 설치 확인

```bash
# Ruby 버전 확인
ruby -v

# Bundler 버전 확인
bundle -v

# Jekyll 버전 확인
jekyll -v
```

### 설치가 필요한 경우

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install ruby-full build-essential zlib1g-dev
gem install bundler jekyll
```

**macOS:**
```bash
brew install ruby
gem install bundler jekyll
```

**Windows:**
- [RubyInstaller](https://rubyinstaller.org/)를 다운로드하여 설치

---

## 로컬에서 블로그 실행하기

### 1. 의존성 패키지 설치

블로그 디렉토리로 이동한 후, 필요한 gem 패키지들을 설치합니다:

```bash
# 블로그 디렉토리로 이동
cd /path/to/jeongyoon-kang.github.io

# Gemfile에 명시된 패키지들 설치
bundle install
```

**처음 실행 시에만 필요합니다.** 이미 설치했다면 생략 가능합니다.

---

### 2. Jekyll 서버 실행

```bash
# 기본 실행 (포트 4000)
bundle exec jekyll serve

# 또는 자동 재빌드 옵션 포함
bundle exec jekyll serve --host 0.0.0.0 --livereload 

# 특정 포트로 실행
bundle exec jekyll serve --port 4001
```

### 3. 브라우저에서 확인

서버가 실행되면 다음 주소로 접속합니다:

```
http://localhost:4000
```

또는

```
http://127.0.0.1:4000
```

### 4. 서버 종료

터미널에서 `Ctrl + C`를 누르면 서버가 종료됩니다.

---

## 변경사항 확인하기

### 자동 재빌드

`--livereload` 옵션을 사용하면 파일 변경 시 자동으로 재빌드됩니다:

```bash
bundle exec jekyll serve --livereload
```

**자동 재빌드되는 파일:**
- 포스트 파일 (`_posts/*.md`)
- 레이아웃 파일 (`_layouts/*.html`)
- Include 파일 (`_includes/*.html`)
- CSS/JavaScript 파일

**수동 재시작이 필요한 경우:**
- `_config.yml` 파일 수정 시
- `Gemfile` 수정 시

### _config.yml 수정 후

`_config.yml`을 수정한 경우 반드시 서버를 재시작해야 합니다:

```bash
# 1. 서버 종료 (Ctrl + C)
# 2. 서버 재시작
bundle exec jekyll serve
```

---

## 일반적인 워크플로우

### 1. 새 포스트 작성 및 미리보기

```bash
# 1. Jekyll 서버 실행
bundle exec jekyll serve --livereload

# 2. 새 포스트 파일 생성
# _posts/2025-10-27-my-new-post.md

# 3. 브라우저에서 http://localhost:4000 확인

# 4. 만족스러우면 Git에 커밋
git add _posts/2025-10-27-my-new-post.md
git commit -m "feat: add new post about..."
git push
```

### 2. 설정 변경 및 확인

```bash
# 1. _config.yml 수정

# 2. 서버 재시작 (Ctrl + C 후)
bundle exec jekyll serve

# 3. 브라우저에서 변경사항 확인

# 4. Git에 커밋
git add _config.yml
git commit -m "chore: update site configuration"
git push
```

---

## 자주 발생하는 문제

### Q1. `bundle: command not found`

**해결:**
```bash
gem install bundler
```

### Q2. `Could not find gem...`

**해결:**
```bash
bundle install
```

### Q3. 포트 4000이 이미 사용 중

**해결:**
```bash
# 다른 포트 사용
bundle exec jekyll serve --port 4001

# 또는 기존 프로세스 종료
lsof -ti:4000 | xargs kill -9
```

### Q4. 변경사항이 반영되지 않음

**해결:**
```bash
# 캐시 삭제 후 재시작
rm -rf _site .jekyll-cache
bundle exec jekyll serve
```

### Q5. `_config.yml` 변경이 반영 안됨

**원인:** Jekyll은 `_config.yml` 변경 시 자동 재빌드하지 않습니다.

**해결:** 서버를 수동으로 재시작 (Ctrl + C 후 다시 실행)

### Q6. Ruby 버전 문제

**에러 메시지:**
```
Your Ruby version is X.X.X, but your Gemfile specified ~> Y.Y.Y
```

**해결:**
```bash
# rbenv 사용 시
rbenv install 2.7.0
rbenv local 2.7.0

# rvm 사용 시
rvm install 2.7.0
rvm use 2.7.0
```

### Q7. Permission denied 에러

**해결:**
```bash
# gem을 사용자 디렉토리에 설치
gem install --user-install bundler jekyll

# 또는 PATH 설정
export GEM_HOME="$HOME/.gem"
export PATH="$HOME/.gem/bin:$PATH"
```

---

## 유용한 옵션

### Draft 포스트 미리보기

```bash
# _drafts 폴더의 초안 포스트도 표시
bundle exec jekyll serve --drafts
```

### 미래 날짜 포스트 표시

```bash
# 미래 날짜로 작성된 포스트도 표시
bundle exec jekyll serve --future
```

### 증분 빌드 (빠른 빌드)

```bash
# 변경된 파일만 재빌드 (대규모 사이트에서 유용)
bundle exec jekyll serve --incremental
```

### 상세 로그 출력

```bash
# 디버깅을 위한 상세 로그
bundle exec jekyll serve --verbose
```

### 모든 옵션 조합

```bash
bundle exec jekyll serve --livereload --drafts --future --incremental
```

---

## 디렉토리 구조

Jekyll이 생성하는 주요 파일/폴더:

```
jeongyoon-kang.github.io/
├── _site/              # 빌드된 정적 사이트 (Git에 커밋하지 않음)
├── .jekyll-cache/      # Jekyll 캐시 (Git에 커밋하지 않음)
├── _posts/             # 블로그 포스트
├── _config.yml         # 사이트 설정
├── Gemfile             # Ruby 의존성
├── Gemfile.lock        # 의존성 버전 잠금
└── guide/              # 가이드 문서
```

**주의:** `_site/`와 `.jekyll-cache/`는 자동 생성되므로 Git에 커밋하지 않습니다.

---

## 성능 최적화 팁

### 1. 불필요한 파일 제외

`_config.yml`에 제외할 파일 추가:

```yaml
exclude:
  - node_modules
  - vendor
  - .bundle
  - docs
  - test
```

### 2. 증분 빌드 사용

대규모 사이트의 경우:

```bash
bundle exec jekyll serve --incremental
```

### 3. 플러그인 최소화

필요한 플러그인만 `_config.yml`에 유지

---

## 참고 자료

- [Jekyll 공식 문서](https://jekyllrb.com/docs/)
- [Minimal Mistakes 문서](https://mmistakes.github.io/minimal-mistakes/docs/quick-start-guide/)
- [Bundler 문서](https://bundler.io/docs.html)

---

## 요약

```bash
# 1. 의존성 설치 (처음만)
bundle install

# 2. 로컬 서버 실행
bundle exec jekyll serve --livereload

# 3. 브라우저에서 확인
# http://localhost:4000

# 4. _config.yml 수정 시 재시작
# Ctrl + C → bundle exec jekyll serve
```

**완료!** 이제 로컬에서 블로그를 개발하고 테스트할 수 있습니다.
