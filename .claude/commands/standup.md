Summarize what I did this week for our weekly standup update. Use the linear CLI (`linear issue mine`) plus `git log` to gather what I worked on, then write the result to `UPDATE-<today's date in YYYY-M-D format, no leading zeros>.md` in the current directory.

## How to gather

1. Confirm linear is authed (`linear auth whoami`) and figure out the team key (`linear team list`).
2. Pull my tickets updated in the last 7 days across all states — include the ones I closed/merged and the ones still in progress:
   ```
   linear issue mine --all-states --updated-after <date 7 days ago YYYY-MM-DD> --sort priority --team <KEY> --no-pager
   ```
3. Cross-reference with `git log --author="<my git name>" --since="<7 days ago>" --pretty=format:"%h %s"` so I don't miss small commits that didn't have tickets.
4. For each completed ticket, run `linear issue view <ID>` to read the description, comments, and PR links — that's where the "why" and discoveries live. Note collaborators in the comments, so I can thank them.

## Format

Plain bullets — no `##` headings, no numbered list, no emojis (looks unprofessional). Indent tickets two spaces under each product. Wrap each ticket ID in a markdown link to `https://linear.app/<organization>/issue/<ID>`.

```
# Weekly Update — YYYY-MM-DD

- Product 1
  - **[WEB-XXXX](link)** — Short description of what shipped, lead with the outcome not the ticket title. Add a sentence on discoveries / why / what was tricky if relevant. Status (Merged / Done / Closed). _Thanks <name> for <reason>._ if anyone else was involved.
  - ...
- Product 2
  - ...
- <Other product if applicable>
  - ...
- Up next
  - **[WEB-XXXX](link)** — Brief.
  - Backlog stuff I've been grooming: <quick list>.
```

## Tone

Human standup voice — short sentences, casual but specific. Lead with what shipped or what happened, not the ticket title. Drop long URLs and verbose Linear descriptions. Group related polish into a single "Small stuff" bullet (scroll fixes, styling tweaks, lint hooks, etc.) rather than padding the list. If a ticket was closed without a fix (e.g. couldn't repro), say so.

Add a "Thanks <name> for <reason>" line on tickets where someone else was meaningfully involved — bug reporter (like thanks for reporting), infra setup, code review pairing. Skip the thanks line when it was solo work.

After writing the file, ask me if there's anyone outside Linear (Slack / calls) I want to credit that the tools wouldn't have surfaced.

For "status", use some colored circle emojis i.e. "Status: 🟢 Merged" or "Status: 🟡 In Progress", whatever's appropriate.
