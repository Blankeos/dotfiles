---
description: Review PR against main and create review document
agent: build
---

Can you review this PR/Branch w/ main and write it in `PR_REVIEW_{TIMESTAMP}.md`

1. If you can, try using the `gh pr view --json number,title,headRefName` command to get the current PR for the current branch. In case it exists to help you with current context.
2. State the branch -> branch in the beginning.
3. I want to see a X/5 merge confidence rating in the beginning.
4. I want to see a small body description since I'll be commenting on github prs.
5. Are there any regressions?
6. Lastly... Does it need to do any migrations? Any checklists before I merge?
7. If you can do the checks yourself, do it. As long as they don't mutate anything.
