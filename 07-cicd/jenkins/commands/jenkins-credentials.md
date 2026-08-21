# Jenkins — Credentials Management

## Adding Credentials via UI
Manage Jenkins → Credentials → System → Global credentials → Add Credentials

| Kind | Fields | Use case |
|------|--------|----------|
| Username with password | username, password | Docker Hub, generic auth |
| SSH Username with private key | username, private key | Git over SSH, remote hosts |
| Secret text | secret | API tokens (GitHub PAT, Slack webhook) |
| Secret file | file | kubeconfig, .npmrc, service account JSON |
| Certificate | keystore + password | mTLS, code signing |

## Using Credentials in Declarative Pipelines
```groovy
// Username/password
withCredentials([usernamePassword(
    credentialsId: 'docker-hub',
    usernameVariable: 'DOCKER_USER',
    passwordVariable: 'DOCKER_PASS'
)]) {
    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
}

// Secret text
withCredentials([string(credentialsId: 'slack-webhook', variable: 'SLACK_URL')]) {
    sh 'curl -X POST -d "{\\"text\\":\\"Build done\\"}" $SLACK_URL'
}

// SSH key
sshagent(['github-ssh-key']) {
    sh 'git clone git@github.com:org/repo.git'
}

// Secret file
withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
    sh 'kubectl get pods'
}
```

## Environment Block Shortcut
```groovy
environment {
    DOCKER_CREDS = credentials('docker-hub')   // exposes DOCKER_CREDS_USR / DOCKER_CREDS_PSW
}
```

## CLI Management
```bash
# List credentials (via credentials plugin CLI, if installed)
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token list-credentials-as-xml system::system::jenkins _

# Import credentials from XML
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token \
  create-credentials-by-xml system::system::jenkins _ < credential.xml
```

## Best Practices
- Never `echo` secrets or print them to console log — Jenkins auto-masks known credential IDs, but avoid the risk entirely.
- Scope credentials to the folder/job that needs them rather than Global whenever possible.
- Rotate long-lived tokens (GitHub PAT, Docker Hub tokens) regularly.
- Use `credentialsId`, never hardcode values in a Jenkinsfile committed to source control.
- Prefer short-lived / scoped tokens over personal account credentials for automation.
