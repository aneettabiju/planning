# Ask Ark — Case 2 testing (session debug)

This branch is your **testing sandbox** for Ask Ark Case 2: diagnosis → fix plan → approve → dispatch.

## What Case 2 needs

A failed Ark session that:

1. Gets **past triage** (agent actually runs)
2. Fails on a **code/test error** (not arkd / `986.js` infra crash)
3. Ask Ark classifies as **needs_fix** and shows **Approve plan**

## Repos involved

| Repo | Branch | Purpose |
|------|--------|---------|
| **aneettabiju/planning** | `case2-debug-test` | This playbook + checklist |
| **ark-onboarding-bot** | `case2-debug-test` | Intentional failing test + Ask Ark code |

## Quick start

### 1. Fix or bypass triage failures

Your Mac sessions fail at triage with:

```text
Cannot find module './986.js' from '/$bunfs/root/ark-darwin-arm64'
```

That is **Case 3 (infra)**, not Case 2. Do **not** use Cursor runtime until arkd is fixed.

When dispatching, omit `--runtime cursor` / do not set cursor as launch executor.

### 2. Enable the probe test (ark-onboarding-bot)

On `ark-onboarding-bot` branch `case2-debug-test`, edit `tests/test_case2_probe.py` and remove the `@unittest.skipUnless` decorator so the test always fails.

Push that branch to the repo your Ark workspace clones.

### 3. Dispatch a test session

From `ark-onboarding-bot`:

```bash
source .env   # ARK_API_KEY required
./scripts/dispatch-case2-test.sh
```

Copy the `s-...` session id. Wait until status is `failed` at stage **verify** or **implement** (not triage).

### 4. Test in Ask Ark

```bash
cd ~/ark-onboarding-bot
source .venv/bin/activate
python -m src.web
```

Paste the session id → expect **Needs fix** + fix plan + **Approve plan** button.

### 5. Approve plan (optional)

In `ark-onboarding-bot` `.env`:

```bash
ARK_DEFAULT_WORKSPACE=modeltest-modeltest-ark-onboarding-bot
ARK_DEFAULT_COMPUTE=aneetta-mac
ARK_FIX_FLOW=ark-feature
```

Click **Approve plan** to dispatch a fix session.

## Checklist

See [CASE2-CHECKLIST.md](./CASE2-CHECKLIST.md).

## Status log

Use [TEST-LOG.md](./TEST-LOG.md) to record session ids and results.
