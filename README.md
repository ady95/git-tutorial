# git-tutorial

위키독스 「AI 에이전트 시대의 Git, GitHub 따라하기」의 실습 예제 저장소입니다.

- 책: [https://wikidocs.net/book/21446](https://wikidocs.net/book/21446)

## 폴더 구성

폴더 이름은 책의 페이지 번호와 같습니다. 1~2부 실습은 각자 만든 `git-practice` 저장소에서 진행하므로, 이 저장소에서는 필요한 파일만 내려받아 씁니다.

| 폴더 | 페이지 | 들어 있는 것 |
|---|---|---|
| `02-2/` | 02-2 실습: AI가 수정한 소개 문서 검토하기 | `README.md` — 실습 시작 상태 (띄어쓰기가 틀린 원본) |
| `02-3/` | 02-3 서로 다른 작업을 나누어 기록하기 | `hobby.md`, `todo.md` — AI 도구가 없는 독자를 위한 "AI가 만든 새 파일" (실측 당시 Claude Code가 만든 결과 그대로) |
| `02-4/` | 02-4 실습: 필요한 수정은 남기고 잘못된 수정만 취소하기 | `README.md`, `profile.md`, `hobby.md`, `todo.md` — AI 도구가 없는 독자를 위한 "AI 수정 결과" (실측 당시 Claude Code가 만든 결과 그대로) |
| `04-1/` | 04-1 실습: 소개 페이지 추가 작업을 별도 브랜치에서 진행하기 | `index.html` — AI 도구가 없는 독자를 위한 "AI가 만든 소개 웹페이지" (실측 당시 Claude Code가 만든 결과 그대로) |
| `06-3/` | 06-3 실습: 예제 프로젝트에 간단한 자동 검사 추가하기 | `check.sh`(→ `scripts/check.sh`), `check.yml`(→ `.github/workflows/check.yml`) — 실측 당시 Claude Code가 만든 검사 스크립트와 워크플로. 워크플로의 actions/checkout 버전만 사람이 v7로 고친 상태 |

## 파일 내려받기

GitHub에서 파일을 연 뒤 오른쪽 위의 **Download raw file** 버튼을 누르면 파일 하나를 내려받을 수 있습니다. 내려받은 파일을 내 `git-practice` 폴더의 같은 이름 파일에 덮어쓴 뒤 실습을 이어 갑니다.

저장소 전체를 가져오는 방법(`git clone`)은 책의 03-2에서 다룹니다.

## 라이선스

이 저장소의 예제 코드와 파일은 [Apache License 2.0](LICENSE)으로 배포합니다. 출처와 라이선스 고지를 유지하면 자유롭게 사용·수정·배포할 수 있습니다.
