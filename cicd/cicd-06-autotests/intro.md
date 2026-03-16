# Autotests in Pipeline

In previous modules we ran tests with `python3 tests.py`. Real projects use **test frameworks**: they collect reports, measure coverage, run tests in parallel, and integrate with CI.

## What we will study

- **pytest** — Python standard: fixtures, parametrize, coverage
- **go test** — Go built-in runner: benchmarks, race detector, coverage
- **JUnit XML** — universal report format understood by GitHub Actions and GitLab CI
- **HTML Coverage Report** — visual report with uncovered lines highlighted
- **Parallel execution** — tests in multiple threads or jobs
- **Fail-fast** — stop on first failure or run everything

> Check tools: `python3 --version && pip3 --version`{{execute}}

> Install pytest: `pip3 install pytest pytest-cov pytest-xdist pytest-html 2>/dev/null | tail -3`{{execute}}

> Working directory: `mkdir -p /opt/autotests-demo && cd /opt/autotests-demo`{{execute}}
