# Day 15 — Interview Questions: Production Jenkins

1. How do you design role-based access control (RBAC) for a multi-team Jenkins instance?
2. What's Jenkins's story on high availability? Since there's no native multi-controller clustering, how do teams mitigate that gap?
3. What should a production backup strategy for Jenkins include beyond just `config.xml`?
4. How would you scale build capacity — static agents vs dynamic cloud/Kubernetes agents — and when would you choose each?
5. What is a Shared Library, and how does it improve governance/consistency across teams' pipelines?
6. How do you scope credentials so one team's pipeline can't access another team's secrets?
7. What metrics would you monitor to catch a Jenkins controller under strain before it becomes an incident?
8. Describe how you'd run a disaster recovery drill for Jenkins, and what "done" looks like.
9. What's the risk of leaving the Groovy sandbox unrestricted, and how do you manage script approvals safely?
10. How do you keep plugins up to date without breaking production pipelines?

<details><summary>Answer notes</summary>

- Q2: Mitigate via fast, tested backup/restore (treat RTO as the real HA metric), durable/replicated storage for JENKINS_HOME, and infrastructure-as-code to rebuild the controller quickly.
- Q6: Use folder-scoped credential stores instead of one Global store; combine with RBAC so teams can only see/use credentials within their folder.
- Q10: Stage plugin updates in a non-production instance first, update in batches with a rollback plan (snapshot beforehand), and monitor for deprecation warnings in logs.
</details>
