# Ask Ark — Case 2 testing (planning sandbox)

Use **this repo** as the code Ark clones and fixes. Use **ark-onboarding-bot** only to run the Ask Ark chat UI locally.

## Do NOT merge the two repos

| Repo | Purpose |
|------|---------|
| **planning** (this repo) | Small repo Ark dispatches against — failing test lives here |
| **ark-onboarding-bot** | Ask Ark app — run `python -m src.web` here |

You do **not** need to copy ark-onboarding-bot into planning.

```
┌─────────────────────┐     paste session id      ┌──────────────────────┐
│  planning repo      │ ──── Ark clones & fails ──│  (Ark fleet)         │
│  tests/ fail here   │                           └──────────┬───────────┘
└─────────────────────┘                                      │
                                                               ▼
                                                    ┌──────────────────────┐
                                                    │ ark-onboarding-bot     │
                                                    │ Ask Ark reads session  │
                                                    │ python -m src.web      │
                                                    └──────────────────────┘
```

## What's in this repo

- `tests/test_case2_probe.py` — intentional failing test (Case 2 bait)
- `scripts/dispatch-case2-test.sh` — start an Ark session against this repo
- `CASE2-CHECKLIST.md` — step-by-step checklist
- `TEST-LOG.md` — record session ids

## Quick start

### 1. Push this branch (with the failing test)

```bash
cd ~/planning
git add tests/ scripts/ README.md
git commit -m "Add Case 2 probe test and dispatch script"
git push origin case2-debug-test
```

### 2. Dispatch an Ark session (clones planning)

```bash
source ~/ark-onboarding-bot/.env   # ARK_API_KEY
./scripts/dispatch-case2-test.sh
```

Copy the `s-...` session id. Wait until it fails at **verify/implement** (not triage).

### 3. Debug in Ask Ark (different folder)

```bash
cd ~/ark-onboarding-bot
source .venv/bin/activate
python -m src.web
```

Open http://127.0.0.1:8765 and paste the session id.

### 4. Approve plan (optional)

Set in `~/ark-onboarding-bot/.env`:

```bash
ARK_DEFAULT_WORKSPACE=...
ARK_DEFAULT_COMPUTE=aneetta-mac
```

## If dispatch fails

- **`flow: default` not found** — your tenant may need a different flow name; ask in #foundry-users or use a workspace that lists `aneettabiju/planning` as a repo.
- **Still fails at triage with `986.js`** — cursor/arkd issue on your Mac; do not use cursor runtime.
- **Case 3 instead of Case 2** — session died before tests ran; see checklist.

See [CASE2-CHECKLIST.md](./CASE2-CHECKLIST.md).
