#!/usr/bin/env bash
#
# Put a team repo back to an earlier commit.
# Deletes only the branches whose work is NOT already in that commit -
# branches that existed and were merged by then are left alone.
#
# Run from inside the team's project folder.
#
#   bash reset.sh            lists the commits
#   bash reset.sh 8672116    resets to that commit
#
set -e

git rev-parse --is-inside-work-tree >/dev/null 2>&1 \
  || { echo "Not a git repo - cd into the team's project folder."; exit 1; }

git fetch --prune origin >/dev/null 2>&1 || true

if [ -z "${1:-}" ]; then
  git --no-pager log --oneline -n 20
  echo ""
  echo "Run again with the commit:   bash reset.sh <commit>"
  exit 0
fi

git rev-parse --verify --quiet "$1^{commit}" >/dev/null \
  || { echo "'$1' is not a commit in this repo. Nothing changed."; exit 1; }
TARGET=$(git rev-parse "$1^{commit}")

# Sort the branches on GitHub into keep and delete.
DELETE=""
while read -r SHA REF; do
  b=${REF#refs/heads/}
  [ "$b" = "main" ] && continue
  if git merge-base --is-ancestor "$SHA" "$TARGET" 2>/dev/null; then
    echo "keeping  $b   (already part of that commit)"
  else
    echo "deleting $b   (added after it)"
    DELETE="$DELETE $b"
  fi
done <<EOF
$(git ls-remote --heads origin)
EOF

git reset --hard "$TARGET"
git push --force origin main
if [ -n "$DELETE" ]; then
  git push origin --delete $DELETE
fi

echo ""
echo "Done. Repo is at:"
git --no-pager log --oneline -n 1
