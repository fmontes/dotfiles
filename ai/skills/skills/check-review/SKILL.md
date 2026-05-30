---
name: check-review
description: Pull review comments from the current PR and triage each one against the actual diff. Use when the user wants to go through code review feedback.
---

Pull the review comments from the current PR with `gh pr view --comments` and read the diff.

For each comment, check it against the actual change and sort it into:

- Fix: valid, do it.
- Skip: wrong, outdated, or already handled. Say why in one line.
- Discuss: needs the user's call.

Go one comment at a time. Don't fix anything yet. List the triage first, then wait.
