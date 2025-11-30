#!/bin/bash

# 블로그 새 포스트 생성 스크립트
# 사용법: ./scripts/new-post.sh "포스트 제목" [카테고리]

set -e  # 에러 발생 시 스크립트 중단

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 도움말 함수
show_help() {
    echo -e "${BLUE}=== 블로그 포스트 생성 도구 ===${NC}"
    echo ""
    echo "사용법:"
    echo "  ./scripts/new-post.sh \"포스트 제목\" [카테고리]"
    echo ""
    echo "예시:"
    echo "  ./scripts/new-post.sh \"C++ Engine 만들기\" sw"
    echo "  ./scripts/new-post.sh \"OpenMP 병렬처리\" sw"
    echo "  ./scripts/new-post.sh \"DMA 설계\" hw"
    echo ""
    echo "카테고리 (선택사항):"
    echo "  - overview (기본값)"
    echo "  - sw (소프트웨어)"
    echo "  - hw (하드웨어)"
    echo "  - linux (리눅스)"
    echo ""
}

# 인자 확인
if [ $# -eq 0 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    show_help
    exit 0
fi

# 변수 설정
POST_TITLE="$1"
CATEGORY="${2:-overview}"
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)

# 포스트명 생성 (제목을 URL 친화적으로 변환)
# 한글 제목인 경우 사용자에게 영문 슬러그 입력 받기
if echo "$POST_TITLE" | grep -q '[ㄱ-ㅎ가-힣]'; then
    echo -e "${YELLOW}한글 제목이 감지되었습니다.${NC}"
    echo -e "${YELLOW}영문 슬러그를 입력하세요 (예: cpp-engine-tutorial):${NC} "
    read -r POST_SLUG

    if [ -z "$POST_SLUG" ]; then
        echo -e "${RED}❌ 오류: 슬러그가 비어있습니다.${NC}"
        exit 1
    fi

    # 슬러그 정규화
    POST_SLUG=$(echo "$POST_SLUG" | sed -r 's/[^a-zA-Z0-9]+/-/g' | sed -r 's/^-+\|-+$//g' | tr '[:upper:]' '[:lower:]')
else
    POST_SLUG=$(echo "$POST_TITLE" | iconv -t ascii//TRANSLIT 2>/dev/null | sed -r 's/[^a-zA-Z0-9]+/-/g' | sed -r 's/^-+\|-+$//g' | tr '[:upper:]' '[:lower:]')
fi

# 파일 및 디렉토리 경로
POST_FILENAME="${DATE}-${POST_SLUG}.md"
POST_PATH="_posts/${POST_FILENAME}"
IMAGE_DIR="assets/images/${DATE}-${POST_SLUG}"
BACKUP_DIR=".backup"

# 이미 존재하는지 확인
if [ -f "$POST_PATH" ]; then
    echo -e "${RED}❌ 오류: 포스트가 이미 존재합니다: ${POST_PATH}${NC}"
    echo -e "${YELLOW}💡 다른 제목을 사용하거나 기존 포스트를 삭제하세요.${NC}"
    exit 1
fi

# 백업 디렉토리 생성
mkdir -p "$BACKUP_DIR"

# 이미지 디렉토리 생성
mkdir -p "$IMAGE_DIR"

# 메타데이터 저장 (되돌리기용)
METADATA_FILE="${BACKUP_DIR}/${DATE}-${POST_SLUG}.meta"
cat > "$METADATA_FILE" << EOF
POST_PATH=$POST_PATH
IMAGE_DIR=$IMAGE_DIR
CREATED_AT=$(date +"%Y-%m-%d %H:%M:%S")
TITLE=$POST_TITLE
CATEGORY=$CATEGORY
EOF

# 포스트 템플릿 생성
cat > "$POST_PATH" << EOF
---
layout: single
title: "${POST_TITLE}"
date: ${DATE} ${TIME}
categories: ${CATEGORY}
tags:
  -
toc: true
toc_sticky: true
toc_label: "목차"
---

# ${POST_TITLE}

포스트 내용을 여기에 작성하세요.

## 섹션 1

내용...

## 이미지 추가 예시

이미지를 추가하려면:

\`\`\`markdown
![이미지 설명]({{ site.url }}{{ site.baseurl }}/assets/images/${DATE}-${POST_SLUG}/image-name.png)
\`\`\`

또는 간단하게:

\`\`\`markdown
![이미지 설명](/assets/images/${DATE}-${POST_SLUG}/image-name.png)
\`\`\`

## 섹션 2

내용...

## 마무리

요약...
EOF

# 성공 메시지
echo -e "${GREEN}✅ 포스트가 생성되었습니다!${NC}"
echo ""
echo -e "${BLUE}📝 포스트 파일:${NC} ${POST_PATH}"
echo -e "${BLUE}📁 이미지 폴더:${NC} ${IMAGE_DIR}/"
echo -e "${BLUE}💾 백업 정보:${NC} ${METADATA_FILE}"
echo ""
echo -e "${YELLOW}다음 단계:${NC}"
echo "1. 이미지를 ${IMAGE_DIR}/ 폴더에 복사하세요"
echo "2. ${POST_PATH} 파일을 편집하여 내용을 작성하세요"
echo "3. 이미지를 추가할 때: /assets/images/${DATE}-${POST_SLUG}/파일명"
echo ""
echo -e "${YELLOW}되돌리기:${NC}"
echo "  ./scripts/delete-post.sh ${DATE}-${POST_SLUG}"
echo ""
