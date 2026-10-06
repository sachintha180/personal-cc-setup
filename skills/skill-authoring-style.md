# Skill authoring style

Applies whenever writing or converting a Claude Code skill file (`SKILL.md`
and any `references/` docs), in any project.

1. Write in ASD-STE100 Simplified Technical English. Short sentences, one
   idea per sentence, plain words, no em dashes, no non-ASCII characters, no
   emojis, no marketing or LinkedIn-style language. Encyclopedic and
   informative tone, never persuasive or descriptive filler.

2. When asked to generalize a skill or make its content portable, do not
   invent a new placeholder example domain. Keep the source codebase's real
   vocabulary (its actual module names, field names, and route names) as the
   illustrative examples. Strip only what is actually non-portable, such as
   a literal file:line citation to a specific repo state, not the
   vocabulary itself. Use "Example:" for an illustrative code location and
   reserve "Source:" for a citation to real external documentation.

3. Hard-wrap prose at 80 columns. Leave tables, code blocks, and the
   frontmatter `description` line unwrapped.

4. Keep the `description` at 300 characters or fewer. State the scope in
   one sentence. Add two or three trigger phrases. Put detail in the body,
   which loads only when the skill triggers.

5. Name a skill in kebab case as `domain-subject-kind`. The domain is the
   area of work the skill serves. The subject is the technology or task it
   covers. The kind is the form of guidance it gives. Example:
   `backend-fastapi-testing`. The folder name equals the `name` field.
