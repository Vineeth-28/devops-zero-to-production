# Docker Registry Troubleshooting

Common Docker Registry problems, their causes, diagnosis, and solutions for Docker Hub and private registries.

---

# 🎯 Objective

Learn how to troubleshoot Docker Registry issues related to image building, tagging, authentication, pushing, pulling, versioning, and repository management.

---

# 🔍 Troubleshooting Workflow

```text
Image Issue
      │
      ▼
docker images
      │
      ▼
docker login
      │
      ▼
docker tag
      │
      ▼
docker push / docker pull
      │
      ▼
Verify Repository
      │
      ▼
Problem Solved
```

---

# 🚨 Problem 1 — Push Access Denied

## Error

```text
denied: requested access to the resource is denied
```

---

## Possible Causes

- Not logged in
- Wrong Docker Hub username
- Repository does not exist
- No permission to push

---

## Diagnosis

Check login

```bash
docker login
```

Verify image

```bash
docker images
```

---

## Solution

Login again

```bash
docker login
```

Retag the image correctly

```bash
docker tag backend:v1.0 username/backend:v1.0
```

Push again

```bash
docker push username/backend:v1.0
```

---

# 🚨 Problem 2 — Image Not Found

## Error

```text
pull access denied
```

or

```text
repository does not exist
```

---

## Possible Causes

- Wrong repository name
- Wrong image tag
- Private repository without authentication

---

## Diagnosis

Verify image name

```bash
docker images
```

Check repository on Docker Hub.

---

## Solution

Use the correct repository.

Example

```bash
docker pull username/backend:v1.0
```

---

# 🚨 Problem 3 — Wrong Image Tag

## Symptoms

Docker cannot find the requested version.

---

## Diagnosis

List local images

```bash
docker images
```

---

## Solution

Retag the image

```bash
docker tag backend:v1.0 username/backend:v1.0
```

---

# 🚨 Problem 4 — Forgot to Tag Image

## Symptoms

Running

```bash
docker push backend:v1.0
```

fails.

---

## Cause

Docker Hub requires:

```text
username/repository:tag
```

---

## Solution

```bash
docker tag backend:v1.0 username/backend:v1.0

docker push username/backend:v1.0
```

---

# 🚨 Problem 5 — Authentication Failed

## Error

```text
unauthorized
```

---

## Possible Causes

- Wrong username
- Wrong password
- Expired access token

---

## Solution

Logout

```bash
docker logout
```

Login again

```bash
docker login
```

---

# 🚨 Problem 6 — Using latest Tag

## Symptoms

Unexpected version deployed.

---

## Cause

`latest` changes over time.

---

## Solution

Use versioned tags.

Example

```text
backend:v1.0.0
backend:v1.0.1
backend:v1.1.0
```

---

# 🚨 Problem 7 — Large Image Upload

## Symptoms

Push operation takes a long time.

---

## Possible Causes

- Large image
- Development dependencies
- No multi-stage build

---

## Solution

- Use Multi-stage Builds
- Use Alpine images
- Optimize Dockerfile

---

# 🚨 Problem 8 — Pulling Old Version

## Cause

Server is pulling an outdated image.

---

## Solution

Specify the exact version.

```bash
docker pull username/backend:v2.0
```

Avoid relying on `latest`.

---

# 🚨 Problem 9 — Private Repository Access Denied

## Cause

User is not authorized.

---

## Solution

- Verify permissions
- Login using correct credentials
- Confirm repository visibility

---

# 🚨 Problem 10 — Wrong Registry

## Symptoms

Image pushed to the wrong registry.

---

## Diagnosis

Inspect image tag.

```bash
docker images
```

---

## Solution

Retag image.

```bash
docker tag backend:v1.0 username/backend:v1.0
```

or

```bash
docker tag backend:v1.0 \
<ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/backend:v1.0
```

---

# 🛠 Useful Commands

Login

```bash
docker login
```

Logout

```bash
docker logout
```

Build

```bash
docker build -t backend:v1.0 .
```

Tag

```bash
docker tag backend:v1.0 username/backend:v1.0
```

Push

```bash
docker push username/backend:v1.0
```

Pull

```bash
docker pull username/backend:v1.0
```

Images

```bash
docker images
```

Inspect

```bash
docker image inspect IMAGE_NAME
```

History

```bash
docker history IMAGE_NAME
```

---

# 🏭 Production Checklist

Before pushing an image verify:

- ✅ Docker build successful
- ✅ Correct repository name
- ✅ Correct image tag
- ✅ Logged into registry
- ✅ Version tag used
- ✅ Multi-stage build completed
- ✅ Optimized image size
- ✅ Repository exists
- ✅ Correct permissions

---

# 🎤 Interview Questions

### Why do we tag images before pushing?

To associate the image with a specific registry repository and version.

---

### Why avoid using latest?

Because it is mutable and can result in unpredictable deployments.

---

### Why use version tags?

- Predictable deployments
- Easy rollback
- Better release management

---

### Difference between Docker Hub and AWS ECR?

Docker Hub is a public/general-purpose registry, while AWS ECR is a managed private container registry integrated with AWS services.

---

### Why do push operations fail?

Common reasons:

- Not logged in
- Wrong repository name
- Incorrect tag
- No permissions

---

# 🎯 Summary

Docker Registry troubleshooting mainly involves checking:

- Authentication
- Repository names
- Image tags
- Registry permissions
- Image optimization
- Versioning strategy

Following proper tagging and versioning practices ensures reliable image storage and predictable production deployments.