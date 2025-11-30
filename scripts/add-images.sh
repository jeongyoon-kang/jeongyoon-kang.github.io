#!/bin/bash

# 블로그 포스트에 이미지 추가 스크립트
# 사용법: ./scripts/add-images.sh <포스트-슬러그> <이미지-파일...>

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 도움말 함수
show_help() {
    echo -e "${BLUE}=== 블로그 이미지 추가 도구 ===${NC}"
    echo ""
    echo "사용법:"
    echo "  ./scripts/add-images.sh <포스트-슬러그> <이미지-파일...>"
    echo ""
    echo "예시:"
    echo "  ./scripts/add-images.sh 2025-10-25-first ~/Downloads/image1.png"
    echo "  ./scripts/add-images.sh 2025-11-30-cpp-engine ~/Pictures/*.png"
    echo ""
    echo "포스트 목록 보기:"
    echo "  ./scripts/list-posts.sh"
    echo ""
}

# 인자 확인
if [ $# -lt 2 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    show_help
    exit 0
fi

# 변수 설정
POST_SLUG="$1"
shift  # 첫 번째 인자 제거
IMAGE_FILES=("$@")

# 경로 설정
POST_PATH="_posts/${POST_SLUG}.md"
IMAGE_DIR="assets/images/${POST_SLUG}"

# 포스트 존재 확인
if [ ! -f "$POST_PATH" ]; then
    echo -e "${RED}❌ 오류: 포스트를 찾을 수 없습니다: ${POST_PATH}${NC}"
    echo ""
    echo -e "${YELLOW}💡 사용 가능한 포스트:${NC}"
    ls _posts/*.md 2>/dev/null | sed 's/_posts\//  - /' | sed 's/.md$//' || echo "  (포스트 없음)"
    exit 1
fi

# 이미지 디렉토리 생성
mkdir -p "$IMAGE_DIR"

# 포스트 정보
TITLE=$(grep "^title:" "$POST_PATH" | sed 's/title: *"\?\(.*\)"\?/\1/')
echo -e "${BLUE}포스트:${NC} ${TITLE}"
echo -e "${BLUE}대상 폴더:${NC} ${IMAGE_DIR}/"
echo ""

# 이미지 복사
COPIED_COUNT=0
SKIPPED_COUNT=0

for img in "${IMAGE_FILES[@]}"; do
    if [ ! -f "$img" ]; then
        echo -e "${RED}⚠️  건너뜀: 파일을 찾을 수 없습니다 - ${img}${NC}"
        SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
        continue
    fi

    FILENAME=$(basename "$img")
    DEST="${IMAGE_DIR}/${FILENAME}"

    # 파일이 이미 존재하는 경우
    if [ -f "$DEST" ]; then
        echo -e "${YELLOW}⚠️  파일이 이미 존재합니다: ${FILENAME}${NC}"
        echo -e "${YELLOW}   덮어쓰시겠습니까? (y/N)${NC} "
        read -r overwrite
        if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}⊘ 건너뜀: ${FILENAME}${NC}"
            SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
            continue
        fi
    fi

    # 이미지 복사
    cp "$img" "$DEST"
    echo -e "${GREEN}✓ 복사됨: ${FILENAME}${NC}"

    # 마크다운 코드 생성
    echo -e "${CYAN}   마크다운:${NC} ![설명](/assets/images/${POST_SLUG}/${FILENAME})"

    COPIED_COUNT=$((COPIED_COUNT + 1))
done

# 결과 요약
echo ""
echo -e "${GREEN}✅ 완료: ${COPIED_COUNT}개 복사됨${NC}"
if [ $SKIPPED_COUNT -gt 0 ]; then
    echo -e "${YELLOW}⚠️  건너뜀: ${SKIPPED_COUNT}개${NC}"
fi

echo ""
echo -e "${BLUE}이미지 폴더:${NC} ${IMAGE_DIR}/"
echo -e "${BLUE}이미지 목록:${NC}"
ls -lh "$IMAGE_DIR" 2>/dev/null | grep -v "^total" | awk '{print "  - " $9 " (" $5 ")"}'

echo ""
echo -e "${YELLOW}💡 포스트에서 사용하기:${NC}"
echo ""
echo "```markdown"
for img in "${IMAGE_FILES[@]}"; do
    if [ -f "$img" ]; then
        FILENAME=$(basename "$img")
        echo "![이미지 설명](/assets/images/${POST_SLUG}/${FILENAME})"
    fi
done
echo "```"
echo ""
