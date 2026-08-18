# Day 11 — Interview Questions: Jenkins Fundamentals

1. What is Jenkins, and what problem does it solve in a software delivery pipeline?
2. Explain the controller/agent (master/slave) architecture. Why shouldn't builds run on the controller in production?
3. What is `JENKINS_HOME` and what critical data does it contain?
4. What's the difference between a Freestyle project and a Pipeline job?
5. How do you install a plugin, and how do you handle plugin dependency conflicts?
6. What is an executor, and how does it relate to concurrent builds?
7. How would you back up and restore a Jenkins instance?
8. What are the two ways to install Jenkins covered in this module, and what are the trade-offs?
9. How do you recover access if you forget the Jenkins admin password?
10. What's stored in the `secrets/` directory, and why is it critical to back up?

<details><summary>Answer notes</summary>

- Q2: Running builds on the controller risks resource contention and security exposure (build code runs with controller-level trust). Agents isolate build execution.
- Q7: Tar/backup `JENKINS_HOME` (config.xml, jobs/, secrets/, plugins/); test restores regularly, not just backups.
- Q10: `secrets/` holds encryption keys used to decrypt stored credentials — losing them makes existing encrypted credentials unrecoverable even with a config backup.
</details>
