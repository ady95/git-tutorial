#!/usr/bin/env bash
# 저장소 내용 검사 스크립트
# 사용법: bash scripts/check.sh
# 문제가 하나라도 있으면 내용을 출력하고 종료 코드 1로 끝냅니다.

# 한글을 바이트 단위로 그대로 비교하도록 로케일을 고정합니다.
export LC_ALL=C

# 어느 폴더에서 실행해도 저장소 최상위를 기준으로 검사합니다.
cd "$(dirname "$0")/.." || exit 1

errors=0

fail() {
  echo "  [실패] $1"
  errors=$((errors + 1))
}

# 파일 내용을 읽을 때 Windows 줄바꿈(\r)을 지웁니다.
read_lines() {
  tr -d '\r' < "$1"
}

# .md의 글자를 HTML에 쓰인 모양으로 바꿉니다. (& < > 이스케이프)
to_html() {
  printf '%s' "$1" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
}

# 글자가 index.html의 한 요소 전체 내용(>글자<)으로 들어 있는지 확인합니다.
in_index() {
  grep -qF ">$(to_html "$1")<" index.html
}

for f in index.html hobby.md todo.md books.md README.md; do
  if [ ! -f "$f" ]; then
    echo "[실패] $f 파일이 없습니다."
    exit 1
  fi
done

# 1. index.html이 외부 주소를 불러오지 않는지 확인
echo "1. index.html 외부 주소 불러오기 검사"
q="[\"'\`]?"
patterns=(
  "src[[:space:]]*=[[:space:]]*${q}(https?:)?//"
  "<link[^>]*href[[:space:]]*=[[:space:]]*${q}(https?:)?//"
  "url\([[:space:]]*${q}(https?:)?//"
  "@import[[:space:]]+${q}(https?:)?//"
  "(fetch|import)[[:space:]]*\([[:space:]]*${q}(https?:)?//"
)
for p in "${patterns[@]}"; do
  while IFS= read -r hit; do
    [ -n "$hit" ] || continue
    fail "index.html ${hit%%:*}번째 줄에서 외부 주소를 불러옵니다: $(printf '%s' "${hit#*:}" | sed 's/^[[:space:]]*//')"
  done <<< "$(read_lines index.html | grep -niE "$p")"
done

# 2. 원본 .md의 항목이 index.html에 모두 있는지 확인
echo "2. 원본 문서 항목이 index.html에 있는지 검사"

# hobby.md: '## 제목' 줄
while IFS= read -r title; do
  [ -n "$title" ] || continue
  in_index "$title" || fail "hobby.md의 취미 '$title'이(가) index.html에 없습니다."
done <<< "$(read_lines hobby.md | sed -n 's/^## *//p' | sed 's/[[:space:]]*$//')"

# todo.md: '- [ ] 할 일' 또는 '- [x] 할 일' 줄
while IFS= read -r item; do
  [ -n "$item" ] || continue
  in_index "$item" || fail "todo.md의 할 일 '$item'이(가) index.html에 없습니다."
done <<< "$(read_lines todo.md | sed -n 's/^- \[[ xX]\] *//p' | sed 's/[[:space:]]*$//')"

# books.md: '- 제목 (저자)' 줄에서 제목만
while IFS= read -r book; do
  [ -n "$book" ] || continue
  in_index "$book" || fail "books.md의 책 '$book'이(가) index.html에 없습니다."
done <<< "$(read_lines books.md | sed -n 's/^- *//p' | sed -e 's/ *(.*$//' -e 's/[[:space:]]*$//')"

# 3. 최상위 파일이 모두 README.md 파일 표에 있는지 확인
#    폴더와 .gitignore로 제외된 파일(.env 등)은 검사하지 않습니다.
echo "3. 최상위 파일이 README.md 파일 표에 있는지 검사"
listed=$(read_lines README.md | sed -n 's/^| *\[\([^]]*\)\].*/\1/p')
shopt -s dotglob nullglob
for f in *; do
  [ -f "$f" ] || continue
  if git check-ignore -q -- "$f" 2>/dev/null; then
    continue
  fi
  grep -qxF -- "$f" <<< "$listed" || fail "최상위 파일 '$f'이(가) README.md의 파일 표에 없습니다."
done

echo
if [ "$errors" -gt 0 ]; then
  echo "검사 실패: 문제 ${errors}개"
  exit 1
fi
echo "검사 통과: 문제 없음"
