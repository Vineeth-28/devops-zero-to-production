# Jenkins CI Workflow — Day 11

## Basic CI
```text
Developer
   ↓
git push
   ↓
GitHub
   ↓
Jenkins Trigger
   ↓
Controller
   ↓
Agent
   ↓
Checkout
   ↓
Build
   ↓
Test
   ↓
Result
```

## Success
```text
Build ✅ → Test ✅ → Package/Docker → Registry → Deployment
```

## Failure
```text
Build/Test ❌
   ↓
Console Logs
   ↓
Identify Failure
   ↓
Fix
   ↓
Push Again
   ↓
Jenkins Runs Again
```

## Production Flow
```text
GitHub → Jenkins → Checkout → Build → Test → Docker Build → Docker Tag → Docker Push → Deployment
```
