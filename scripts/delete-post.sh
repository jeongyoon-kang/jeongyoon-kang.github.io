#!/bin/bash

# 블로그 포스트 삭제/되돌리기 스크립트
# 사용법: ./scripts/delete-post.sh <포스트-슬러그> [--force]

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 도움말 함수
show_help() {
    echo -e "${BLUE}=== 블로그 포스트 삭제 도구 ===${NC}"
    echo ""
    echo "사용법:"
    echo "  ./scripts/delete-post.sh <포스트-슬러그> [--force]"
    echo ""
    echo "예시:"
    echo "  ./scripts/delete-post.sh 2025-10-25-first"
    echo "  ./scripts/delete-post.sh 2025-11-30-cpp-engine --force"
    echo ""
    echo "옵션:"
    echo "  --force  확인 없이 바로 삭제"
    echo ""
    echo "포스트 목록 보기:"
    echo "  ./scripts/list-posts.sh"
    echo ""
}

# 인자 확인
if [ $# -eq 0 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    show_help
    exit 0
fi

# 변수 설정
POST_SLUG="$1"
FORCE_DELETE=false

if [ "$2" == "--force" ]; then
    FORCE_DELETE=true
fi

# 경로 설정
POST_PATH="_posts/${POST_SLUG}.md"
IMAGE_DIR="assets/images/${POST_SLUG}"
BACKUP_DIR=".backup"
METADATA_FILE="${BACKUP_DIR}/${POST_SLUG}.meta"
TRASH_DIR="${BACKUP_DIR}/trash/$(date +%Y%m%d-%H%M%S)"

# 포스트 존재 확인
if [ ! -f "$POST_PATH" ]; then
    echo -e "${RED}❌ 오류: 포스트를 찾을 수 없습니다: ${POST_PATH}${NC}"
    echo ""
    echo -e "${YELLOW}💡 사용 가능한 포스트 목록:${NC}"
    ls _posts/*.md 2>/dev/null | sed 's/_posts\//  - /' | sed 's/.md$//' || echo "  (포스트 없음)"
    exit 1
fi

# 포스트 정보 읽기
TITLE=$(grep "^title:" "$POST_PATH" | sed 's/title: *"\?\(.*\)"\?/\1/')
CATEGORY=$(grep "^categories:" "$POST_PATH" | sed 's/categories: *//')

# 정보 출력
echo -e "${YELLOW}🗑️  다음 포스트를 삭제하려고 합니다:${NC}"
echo ""
echo -e "${BLUE}제목:${NC} ${TITLE}"
echo -e "${BLUE}카테고리:${NC} ${CATEGORY}"
echo -e "${BLUE}파일:${NC} ${POST_PATH}"

if [ -d "$IMAGE_DIR" ]; then
    IMAGE_COUNT=$(find "$IMAGE_DIR" -type f 2>/dev/null | wc -l)
    echo -e "${BLUE}이미지:${NC} ${IMAGE_DIR}/ (${IMAGE_COUNT}개 파일)"
else
    echo -e "${BLUE}이미지:${NC} (없음)"
fi
echo ""

# 확인 (--force 옵션이 없는 경우)
if [ "$FORCE_DELETE" = false ]; then
    echo -e "${RED}⚠️  경고: 이 작업은 파일을 백업 폴더로 이동시킵니다.${NC}"
    echo -e "${YELLOW}계속하시겠습니까? (y/N)${NC} "
    read -r response

    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}❌ 취소되었습니다.${NC}"
        exit 0
    fi
fi

# 백업 디렉토리 생성
mkdir -p "$TRASH_DIR"

# 파일 이동 (백업)
echo ""
echo -e "${YELLOW}📦 백업 중...${NC}"

# 포스트 파일 백업
if [ -f "$POST_PATH" ]; then
    mv "$POST_PATH" "$TRASH_DIR/"
    echo -e "${GREEN}✓${NC} 포스트 파일 백업: ${POST_PATH}"
fi

# 이미지 디렉토리 백업
if [ -d "$IMAGE_DIR" ]; then
    mv "$IMAGE_DIR" "$TRASH_DIR/"
    echo -e "${GREEN}✓${NC} 이미지 폴더 백업: ${IMAGE_DIR}/"
fi

# 메타데이터 백업
if [ -f "$METADATA_FILE" ]; then
    mv "$METADATA_FILE" "$TRASH_DIR/"
    echo -e "${GREEN}✓${NC} 메타데이터 백업"
fi

# 복원 정보 생성
RESTORE_INFO="${TRASH_DIR}/restore-info.txt"
cat > "$RESTORE_INFO" << EOF
=== 복원 정보 ===
삭제 시각: $(date +"%Y-%m-%d %H:%M:%S")
포스트: ${POST_SLUG}
제목: ${TITLE}
카테고리: ${CATEGORY}

복원 명령어:
  ./scripts/restore-post.sh $(basename "$TRASH_DIR")

백업 위치:
  ${TRASH_DIR}/
EOF

# 성공 메시지
echo ""
echo -e "${GREEN}✅ 포스트가 삭제되었습니다 (백업됨)${NC}"
echo ""
echo -e "${BLUE}백업 위치:${NC} ${TRASH_DIR}/"
echo -e "${YELLOW}복원하려면:${NC}"
echo "  ./scripts/restore-post.sh $(basename "$TRASH_DIR")"
echo ""
