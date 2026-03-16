# Congratulations!

You completed the **Autotests in Pipeline** module!

## What you learned

- **pytest**: fixtures, test classes, `@pytest.mark.parametrize`, markers
- **Coverage**: `--cov`, `--cov-fail-under`, HTML/XML/term reports, GitLab UI integration
- **JUnit XML**: `--junitxml`, XML parsing, integration with GitHub/GitLab MR UI
- **HTML reports**: `--html --self-contained-html`, artifacts in CI
- **go test**: table-driven tests, `t.Run` subtests, benchmarks, race detector, coverage
- **Parallel execution**: `pytest-xdist -n auto`
- **Fail-fast vs full run**: `-x` for development, matrix builds for compatibility
- **Smart pipelines**: unit tests on every push, coverage + matrix only for MR

## Quick reference

```bash
python3 -m pytest   -n auto   --tb=short   --cov=mymodule   --cov-fail-under=80   --cov-report=xml   --junitxml=report.xml
```

## What is next

| Module | Status |
|--------|--------|
| CI/CD 01-05: CI/CD basics | Done |
| CI/CD 06: Autotests | Done |
| CI/CD 07: Deploy strategies | Next |
