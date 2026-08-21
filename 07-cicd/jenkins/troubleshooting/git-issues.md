# Jenkins — Git / SCM Troubleshooting

## "Failed to connect to repository" / authentication failed
- Verify the credential type matches the URL scheme:
  - `https://` URLs → username/password or PAT credential
  - `git@` (SSH) URLs → SSH private key credential
- Test manually from the agent:
```bash
git ls-remote https://github.com/org/repo.git
ssh -T git@github.com
```

## "Host key verification failed" (SSH)
- Add GitHub's host key to the Jenkins user's `known_hosts`, or
- `Manage Jenkins → Security → Git Host Key Verification Configuration` → set to "Accept first connection" (dev only) or manually manage known hosts (recommended for production)

## Webhook not triggering builds
- Check GitHub repo → Settings → Webhooks → Recent Deliveries for the response code
- 403/404 → check the payload URL and that "GitHub hook trigger for GITScm polling" is enabled on the job
- Behind a firewall/NAT → Jenkins must be reachable from GitHub's servers, or use a tool like `smee.io` for local dev

## Detached HEAD / wrong branch checked out
- Freestyle/Pipeline "lightweight checkout" can check out a specific SHA rather than a branch ref
- For Multibranch Pipelines this is expected and normal (each build pins to the triggering commit)

## Merge conflicts breaking PR builds
- Ensure the PR discovery strategy includes "Merging the pull request with the current target branch base" if you want to test the merged result, not just the source branch

## Shallow clone missing history (e.g., for `git log`-based versioning)
```groovy
checkout([$class: 'GitSCM',
    branches: [[name: '*/main']],
    extensions: [[$class: 'CloneOption', shallow: false, depth: 0]],
    userRemoteConfigs: [[url: 'https://github.com/org/repo.git']]
])
```
