# Day 11 — Jenkins Fundamentals

**Status:** ✅ Complete

## Objectives
- Understand Jenkins architecture: controller, agents, executors
- Install Jenkins (via apt and via Docker) and complete initial setup
- Navigate the Jenkins UI and understand core concepts
- Install and manage plugins
- Create your first Freestyle job

## Lab Steps

1. **Install Jenkins locally**
   - Install via apt on Ubuntu, unlock with `initialAdminPassword`
   - Complete the setup wizard, install suggested plugins
   - Create your first admin user

2. **Install Jenkins via Docker (alternative)**
   - Run `jenkins/jenkins:lts` with a named volume for persistence
   - Compare pros/cons vs a native install

3. **Explore the UI**
   - Dashboard, Manage Jenkins, Build History, Blue Ocean (if installed)
   - Global Tool Configuration (JDK, Git, Maven/Node versions)

4. **Create a Freestyle Job**
   - New Item → Freestyle project named `hello-jenkins`
   - Add a build step: `echo "Hello from Jenkins"`
   - Run the build, inspect console output

5. **Add an agent (optional, for HA understanding)**
   - Add a permanent agent node via SSH
   - Restrict the `hello-jenkins` job to that node using labels

## Key Takeaways
- Jenkins is controller/agent based — the controller should ideally not run builds directly in production
- Plugins extend nearly everything: SCM, notifications, build tools, security
- `JENKINS_HOME` holds all state — back it up

## Checklist
- [x] Jenkins installed and accessible on port 8080
- [x] Initial admin user created
- [x] Suggested plugins installed
- [x] First Freestyle job created and run successfully
