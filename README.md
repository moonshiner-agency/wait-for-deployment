# wait-for-deployment

Polls a JSON endpoint until a field reports the expected value, so the next job only runs once the new version is live.

Every attempt logs the value it saw, so a stuck rollout is visible in the job log without debug logging.

## Usage

```yaml
- uses: moonshiner-agency/wait-for-deployment@<commit-sha> # vX.Y.Z
  with:
    url: https://app.example.com/api/version
    expected: ${{ github.sha }}
```

Pin to a full commit SHA rather than a tag, especially in jobs with `id-token: write` or access to secrets. To get the SHA of a release:

```sh
git ls-remote https://github.com/moonshiner-agency/wait-for-deployment 'refs/tags/vX.Y.Z^{}'
```

## Inputs

| Input      | Required | Default              | Description                                              |
| ---------- | -------- | -------------------- | -------------------------------------------------------- |
| `url`      | yes      |                      | JSON endpoint to poll                                    |
| `expected` | yes      |                      | Value the field must report                              |
| `field`    | no       | `active_commit_hash` | Field to compare; use dots for nested fields (`a.b.c`)   |
| `timeout`  | no       | `600`                | Seconds before the step fails                            |
| `interval` | no       | `30`                 | Seconds between attempts                                 |

Requests that fail or time out (10 s each) count as attempts and are retried until `timeout`.

## Requirements

`bash`, `curl` and `jq` on the runner. GitHub-hosted runners have all three.

## Releasing

Tag the commit `vX.Y.Z` and move the major tag to it. Tags under `v*` are protected, so only repository admins can push them.

```sh
git tag -m v1.0.1 v1.0.1 && git tag -f -m v1 v1 && git push origin v1.0.1 && git push -f origin v1
```
