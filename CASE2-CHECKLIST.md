# Case 2 test checklist

## Before dispatch

- [ ] `ARK_API_KEY` set in ark-onboarding-bot `.env`
- [ ] Workspace doctor green: `modeltest-modeltest-ark-onboarding-bot`
- [ ] `case2-debug-test` branch pushed on **ark-onboarding-bot** with failing probe test
- [ ] Dispatch uses **default/claude runtime** (not cursor)

## Dispatch

- [ ] Run `./scripts/dispatch-case2-test.sh`
- [ ] Record session id: `s-________________`

## Session failed correctly?

- [ ] Status: `failed`
- [ ] Stage: `verify` or `implement` (NOT `triage`)
- [ ] Error mentions test failure (NOT `986.js`)

## Ask Ark

- [ ] Timeline shows at top (plain text, no `##` headers)
- [ ] Badge: **Needs fix**
- [ ] Fix plan visible (summary, files, test steps)
- [ ] **Approve plan** and **Reject plan** buttons show

## Approve flow (optional)

- [ ] `ARK_DEFAULT_WORKSPACE` and `ARK_DEFAULT_COMPUTE` set
- [ ] Approve plan → fix session started
- [ ] PR link or “still running” message returned

## Reject flow

- [ ] Reject plan → no dispatch, clear message

## Cleanup

- [ ] Remove / skip intentional probe test
- [ ] Delete test branches when done
