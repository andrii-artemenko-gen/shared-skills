# shared-skills

Shared Codex skill repository.

Use this repo as the source of truth for globally reusable Codex skills. Keep project-specific, secret, or client-specific instructions out of this repository unless you intentionally want them available in every Codex project.

## Layout

```text
.agents/
  skills/                    # repository-native Codex skill folders
    <skill-name>/SKILL.md
scripts/init-links.sh        # links .agents/skills into Codex home
```

Do not create skills at the repo root. Codex discovers skills through:

```text
${CODEX_HOME:-$HOME/.codex}/skills/<skill-name>/SKILL.md
```

## Setup

Run from anywhere:

```bash
./scripts/init-links.sh
```

The script links this repo's `.agents/skills/` directory to:

```text
${CODEX_HOME:-$HOME/.codex}/skills
```

If that path already exists, the script stops unless it is already linked to this repo. Use `--replace` only when you intentionally want the script to move the existing path to a timestamped backup and create the link.

```bash
./scripts/init-links.sh --replace
```

## Managing Skills

- Add one folder per skill under `.agents/skills/`.
- Each skill folder must contain `SKILL.md`.
- Keep scripts, references, and assets inside the owning skill folder.
- Do not store secrets, private customer data, local memory, or project runtime state here.
- Keep reusable setup changes on `initial-setup`; put private or experimental skills on separate branches.

## Branches

- `initial-setup`: portable public setup only.
- Skill branches: private or scoped skill work.
