---
name: brainstorm
description: Interview the user about a plan until you both understand it and can write an executable spec. Walk every branch of the decision tree and surface trade-offs the user missed. Use when the user wants to stress-test a plan or says "brainstorm" or "grill me".
---

Interview me about this plan until we both understand it. Go branch by branch through the decisions, one at a time.

Don't validate my plan. Find what I missed.

One question at a time. Give your recommended answer with each one.

If the codebase can answer a question, check the codebase instead of asking.

If a decision is weak, say so. Don't accept vague answers.

Cover these when they apply:

- What this breaks in what already exists.
- What goes down if it fails in production.
- Whether it ships behind a feature flag.
- What the agent does alone vs. what needs my call.

When there are no open questions left, say so and write the spec: decisions made, trade-offs resolved, what's out of scope. Short and direct. Someone who wasn't here should be able to execute it.
