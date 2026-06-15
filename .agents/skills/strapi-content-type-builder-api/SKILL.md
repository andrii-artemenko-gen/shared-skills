---
name: strapi-content-type-builder-api
description: Plan, dry-run, apply, or review Strapi schemas when the user asks to change Strapi through the CTB admin API.
---

Use only for Strapi schema changes through internal CTB admin API. Never edit schema JSON. Use `assets/change-request.template.yaml`.

## Facts

- Verify installed routes: `GET /schema`, `POST /update-schema`, `GET /update-schema-status`.
- Payload: `{ "data": { "components": [], "contentTypes": [] } }`.
- Observed Strapi 5: component attrs cannot be dynamic zones.
- Component relations: one-way `oneToOne`/`oneToMany`; verify validation.
- Update trap: updated model `attributes` is final attrs. Omitted existing attrs are deleted.

## Input

Require YAML: `mode`, `apply_approved`, `strapi`, `components`, `content_types`, `expected_generated_files`, `expected_schema_assertions`, `verification_commands`, `risk_acknowledgements`. Secrets use env names.

## Workflow

1. Check Strapi root, `src/`, CTB package, `$BASE_URL/admin/init`, auth, `git status --short`. Stop on miss.
2. Check installed routes/validation; stop on drift.
3. Fetch live schema.
4. Build payload from live schema.
   - Creates: new attrs.
   - Deletes: removed models/attrs named in summary.
   - Updates: complete final attrs only. Kept=`update`; new=`create`; deleted=absent only after naming.
   - Sparse updates are forbidden.
5. Validate UIDs, categories, relation targets, `targetAttribute`, dynamic-zone UIDs, component relation limits, expected files/attrs.
6. Show creates/updates/deletes, final attrs per updated model, generated files, commands, risks.
7. Stop unless `mode: apply` and `apply_approved: true`. Dry-run prints payload/commands only.
8. POST once to `/content-type-builder/update-schema`.
9. Poll with bounded curl timeouts; Strapi may restart.
10. Refetch schema; assert changed model attrs match `expected_schema_assertions`.
11. Verify files; run commands exactly; report status.

## Failures

- 400: print error, keep payload, no blind retry.
- 401/403: stop for auth.
- 409: poll if applying; else stop.
- Restart timeout: report last status; no second POST.
- Missing kept attr after apply: report blocker; no unrelated fix.

## Gotchas

- `200 {}` is not proof. Refetch schema.
- Sparse update payloads delete untouched fields.
- Field rename can orphan data.
- Component relation `required` may not serialize; enforce via contract tests.
- Dynamic zones need component UIDs.
