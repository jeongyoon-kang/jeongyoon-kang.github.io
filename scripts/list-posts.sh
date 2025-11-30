#!/bin/bash

# 블로그 포스트 목록 조회 스크립트
# 사용법: ./scripts/list-posts.sh [카테고리]

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# 도움말 함수
show_help() {
    echo -e "${BLUE}=== 블로그 포스트 목록 도구 ===${NC}"
    echo ""
    echo "사용법:"
    echo "  ./scripts/list-posts.sh [카테고리]"
    echo ""
    echo "예시:"
    echo "  ./scripts/list-posts.sh          # 모든 포스트"
    echo "  ./scripts/list-posts.sh sw       # SW 카테고리만"
    echo "  ./scripts/list-posts.sh hw       # HW 카테고리만"
    echo ""
}

# 인자 확인
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    show_help
    exit 0
fi

FILTER_CATEGORY="$1"

# 포스트 목록 조회
echo -e "${BLUE}=== 블로그 포스트 목록 ===${NC}"
echo ""

POST_COUNT=0

for post in _posts/*.md; do
    if [ -f "$post" ]; then
        # 포스트 정보 추출
        TITLE=$(grep "^title:" "$post" | head -1 | sed 's/title: *"\?\(.*\)"\?/\1/' | sed 's/"$//')
        CATEGORY=$(grep "^categories:" "$post" | head -1 | sed 's/categories: *//')
        DATE=$(grep "^date:" "$post" | head -1 | sed 's/date: *//' | cut -d' ' -f1)
        SLUG=$(basename "$post" .md)

        # 카테고리 필터
        if [ -n "$FILTER_CATEGORY" ] && [ "$CATEGORY" != "$FILTER_CATEGORY" ]; then
            continue
        fi

        # 이미지 개수 확인
        IMAGE_DIR="assets/images/${SLUG}"
        IMAGE_COUNT=0
        if [ -d "$IMAGE_DIR" ]; then
            IMAGE_COUNT=$(find "$IMAGE_DIR" -type f 2>/dev/null | wc -l)
        fi

        # 출력
        echo -e "${GREEN}📝 ${TITLE}${NC}"
        echo -e "   ${BLUE}파일:${NC} ${post}"
        echo -e "   ${CYAN}날짜:${NC} ${DATE:-N/A}  ${CYAN}카테고리:${NC} ${CATEGORY:-N/A}  ${CYAN}이미지:${NC} ${IMAGE_COUNT}개"
        echo -e "   ${YELLOW}슬러그:${NC} ${SLUG}"
        echo ""

        POST_COUNT=$((POST_COUNT + 1))
    fi
done

if [ $POST_COUNT -eq 0 ]; then
    if [ -n "$FILTER_CATEGORY" ]; then
        echo -e "${YELLOW}카테고리 '${FILTER_CATEGORY}'에 해당하는 포스트가 없습니다.${NC}"
    else
        echo -e "${YELLOW}포스트가 없습니다.${NC}"
    fi
    echo ""
    echo -e "${BLUE}새 포스트를 만들려면:${NC}"
    echo "  ./scripts/new-post.sh \"제목\" [카테고리]"
else
    echo -e "${BLUE}총 ${POST_COUNT}개의 포스트${NC}"
fi

echo ""
