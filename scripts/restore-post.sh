#!/bin/bash

# 블로그 포스트 복원 스크립트
# 사용법: ./scripts/restore-post.sh <백업-ID>

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 도움말 함수
show_help() {
    echo -e "${BLUE}=== 블로그 포스트 복원 도구 ===${NC}"
    echo ""
    echo "사용법:"
    echo "  ./scripts/restore-post.sh <백업-ID>"
    echo ""
    echo "예시:"
    echo "  ./scripts/restore-post.sh 20251130-143022"
    echo ""
    echo "백업 목록 보기:"
    echo "  ls -lt .backup/trash/"
    echo ""
}

# 인자 확인
if [ $# -eq 0 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    show_help
    exit 0
fi

# 변수 설정
BACKUP_ID="$1"
TRASH_DIR=".backup/trash/${BACKUP_ID}"

# 백업 존재 확인
if [ ! -d "$TRASH_DIR" ]; then
    echo -e "${RED}❌ 오류: 백업을 찾을 수 없습니다: ${TRASH_DIR}${NC}"
    echo ""
    echo -e "${YELLOW}💡 사용 가능한 백업 목록:${NC}"
    ls -lt .backup/trash/ 2>/dev/null | grep "^d" | awk '{print "  - " $NF}' || echo "  (백업 없음)"
    exit 1
fi

# 복원 정보 읽기
RESTORE_INFO="${TRASH_DIR}/restore-info.txt"
if [ -f "$RESTORE_INFO" ]; then
    echo -e "${BLUE}=== 복원 정보 ===${NC}"
    cat "$RESTORE_INFO"
    echo ""
fi

# 확인
echo -e "${YELLOW}이 백업을 복원하시겠습니까? (y/N)${NC} "
read -r response

if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}❌ 취소되었습니다.${NC}"
    exit 0
fi

# 복원 시작
echo ""
echo -e "${YELLOW}📦 복원 중...${NC}"

# 포스트 파일 복원
for file in "$TRASH_DIR"/*.md; do
    if [ -f "$file" ]; then
        dest="_posts/$(basename "$file")"
        if [ -f "$dest" ]; then
            echo -e "${RED}⚠️  경고: 파일이 이미 존재합니다: ${dest}${NC}"
            echo -e "${YELLOW}덮어쓰시겠습니까? (y/N)${NC} "
            read -r overwrite
            if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
                echo -e "${BLUE}⊘ 건너뜀: ${dest}${NC}"
                continue
            fi
        fi
        cp "$file" "$dest"
        echo -e "${GREEN}✓${NC} 포스트 파일 복원: ${dest}"
    fi
done

# 이미지 디렉토리 복원
for dir in "$TRASH_DIR"/*/; do
    if [ -d "$dir" ] && [[ "$(basename "$dir")" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}- ]]; then
        dest="assets/images/$(basename "$dir")"
        if [ -d "$dest" ]; then
            echo -e "${RED}⚠️  경고: 폴더가 이미 존재합니다: ${dest}${NC}"
            echo -e "${YELLOW}병합하시겠습니까? (y/N)${NC} "
            read -r merge
            if [[ ! "$merge" =~ ^[Yy]$ ]]; then
                echo -e "${BLUE}⊘ 건너뜀: ${dest}${NC}"
                continue
            fi
        fi
        cp -r "$dir" "assets/images/"
        echo -e "${GREEN}✓${NC} 이미지 폴더 복원: ${dest}/"
    fi
done

# 메타데이터 복원
for meta in "$TRASH_DIR"/*.meta; do
    if [ -f "$meta" ]; then
        cp "$meta" ".backup/"
        echo -e "${GREEN}✓${NC} 메타데이터 복원"
    fi
done

# 성공 메시지
echo ""
echo -e "${GREEN}✅ 복원이 완료되었습니다!${NC}"
echo ""
echo -e "${YELLOW}💡 백업은 ${TRASH_DIR}/ 에 그대로 보관됩니다.${NC}"
echo -e "${YELLOW}   완전히 삭제하려면: rm -rf ${TRASH_DIR}${NC}"
echo ""
