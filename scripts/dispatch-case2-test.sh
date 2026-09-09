#!/usr/bin/env bash
# Dispatch an Ark session against THIS repo (planning) with a fixable test failure.
#
# Prerequisites:
#   - Push branch case2-debug-test to github.com/aneettabiju/planning first
#   - ARK_API_KEY exported (or in ../ark-onboarding-bot/.env)
#   - Avoid cursor runtime until arkd 986.js is fixed on your Mac
#
# Usage:
#   ./scripts/dispatch-case2-test.sh

set -euo pipefail
cd "$(dirname "$0")/.."

if [[ -f "$HOME/ark-onboarding-bot/.env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "$HOME/ark-onboarding-bot/.env"
  set +a
elif [[ -f .env ]]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
fi

: "${ARK_API_KEY:?Set ARK_API_KEY (e.g. source ~/ark-onboarding-bot/.env)}"

ARK_API_URL="${ARK_API_URL:-https://ark.internal.ap-south-1.platform.mlops.pai.mypaytm.com/api/rpc}"
COMPUTE="${ARK_DEFAULT_COMPUTE:-aneetta-mac}"
REPO="${CASE2_REPO_URL:-https://github.com/aneettabiju/planning.git}"
BRANCH="${CASE2_REPO_BRANCH:-case2-debug-test}"
SUMMARY="${1:-Case2 debug: fix test in planning repo}"

PROMPT=$(cat <<'EOF'
This is a controlled Case 2 debug test for Ask Ark.

Repo: the planning sandbox (this checkout).
Branch: case2-debug-test.

Steps:
1. Run: python3 -m unittest discover -s tests -v
2. tests/test_case2_probe.py should fail with "Intentional Case 2 probe failure"
3. Fix that test so it passes (change the assertion)
4. Re-run the full suite until green
5. Do not change unrelated files
EOF
)

payload=$(REPO="$REPO" BRANCH="$BRANCH" COMPUTE="$COMPUTE" SUMMARY="$SUMMARY" PROMPT="$PROMPT" python3 - <<'PY'
import json
import os

print(
    json.dumps(
        {
            "jsonrpc": "2.0",
            "id": 1,
            "method": "session/lifecycle",
            "params": {
                "op": "start",
                "flow": "default",
                "repo": os.environ["REPO"],
                "compute": os.environ["COMPUTE"],
                "summary": os.environ["SUMMARY"],
                "autonomy": "execute",
                "prompt": os.environ["PROMPT"],
                "params": {"branch": os.environ["BRANCH"]},
            },
        }
    )
)
PY
)

echo "Dispatching against planning repo..."
echo "  repo:    $REPO"
echo "  branch:  $BRANCH (via params.branch — confirm your flow reads this)"
echo "  compute: $COMPUTE"
echo ""

response=$(curl -s "$ARK_API_URL" \
  -H "Authorization: Bearer $ARK_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$payload")

echo "$response" | python3 -m json.tool 2>/dev/null || echo "$response"

session_id=$(echo "$response" | python3 -c "
import json, sys
d = json.load(sys.stdin)
r = d.get('result') or {}
print(r.get('sessionId') or r.get('session_id') or '')
" 2>/dev/null || true)

if [[ -n "$session_id" ]]; then
  echo ""
  echo "Session started: $session_id"
  echo "Paste into Ask Ark (run from ~/ark-onboarding-bot):  $session_id"
else
  echo ""
  echo "No session id — if flow 'default' is rejected, ask #foundry-users"
  echo "or dispatch with your team's workspace that clones this repo."
  exit 1
fi
