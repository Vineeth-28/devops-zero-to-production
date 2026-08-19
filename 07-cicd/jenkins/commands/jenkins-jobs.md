# Jenkins — Job Management Commands

## Freestyle Job (UI steps, for reference)
1. New Item → Freestyle project
2. Source Code Management → Git → repo URL + credentials
3. Build Triggers → GitHub hook trigger for GITScm polling (or Poll SCM)
4. Build Steps → Execute shell / Invoke Gradle / etc.
5. Post-build Actions → Archive artifacts, Email notification, etc.

## CLI Job Operations
```bash
# Create job from XML
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token create-job my-job < config.xml

# Copy an existing job
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token copy-job source-job new-job

# Delete a job
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token delete-job my-job

# Get job config XML
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token get-job my-job > config.xml

# Update job config
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token update-job my-job < config.xml

# Enable / disable
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token enable-job my-job
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token disable-job my-job
```

## Build Operations
```bash
# Trigger a build (with parameters)
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token build my-job -p ENV=staging

# Trigger and wait for completion
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token build my-job -s -v

# Console output
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token console my-job

# Get last build number
curl -s http://localhost:8080/job/my-job/lastBuild/buildNumber
```

## REST API Equivalents
```bash
# Trigger build via API
curl -X POST http://localhost:8080/job/my-job/build \
  --user user:api-token

# Trigger with parameters
curl -X POST "http://localhost:8080/job/my-job/buildWithParameters?ENV=staging" \
  --user user:api-token

# Get job status as JSON
curl -s http://localhost:8080/job/my-job/lastBuild/api/json | jq .result
```

## Multibranch Pipeline
1. New Item → Multibranch Pipeline
2. Branch Sources → GitHub → repo + credentials
3. Build Configuration → by Jenkinsfile (path: `Jenkinsfile`)
4. Scan Multibranch Pipeline Triggers → periodically if not using webhooks
