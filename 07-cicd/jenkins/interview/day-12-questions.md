# Day 12 — Interview Questions: Jobs & Pipelines

1. What's the difference between Declarative and Scripted pipeline syntax?
2. Why are Declarative pipelines validated before any stage runs, and what's the practical benefit?
3. How do you pass parameters into a pipeline, and how do you access them in stages?
4. Explain the `environment {}` block — when do those variables become available?
5. What does the `when` directive do? Give three example conditions.
6. How do you run stages in parallel, and when would you do so?
7. What's the purpose of the `post {}` block, and what conditions can it react to (`success`, `failure`, `always`, etc.)?
8. How would you retry a flaky step without failing the whole pipeline?
9. What does `agent any` vs `agent { docker { image '...' } }` change about where a stage runs?
10. How do Shared Libraries help avoid duplicated pipeline code across projects?

<details><summary>Answer notes</summary>

- Q1: Declarative is structured/opinionated and linted upfront; Scripted is raw Groovy inside `node {}`, more flexible but errors surface at runtime.
- Q6: Use a `parallel {}` block inside a stage — useful for independent tasks like lint + unit tests to cut wall-clock time.
- Q8: Wrap the step in `retry(n) { ... }`.
</details>
