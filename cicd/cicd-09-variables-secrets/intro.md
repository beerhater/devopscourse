## Variables и Secrets

В любом CI/CD рано или поздно появляются:

- environment variables;
- credentials;
- токены;
- разные значения для `dev/stage/prod`.

Главное правило: секреты не хардкодить в workflow-файлах.
