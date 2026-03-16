# Автотесты в пайплайне

В предыдущих модулях мы запускали тесты через `python3 tests.py` — простой скрипт. В реальных проектах используют **тест-фреймворки**: они собирают отчёты, измеряют покрытие, запускают тесты параллельно и интегрируются с CI.

## Что изучим

- **pytest** — стандарт для Python: fixtures, parametrize, coverage
- **go test** — встроенный раннер Go: benchmarks, race detector, coverage
- **JUnit XML** — универсальный формат отчётов, понимается и GitHub Actions и GitLab CI
- **HTML Coverage Report** — визуальный отчёт с подсветкой непокрытых строк
- **Параллельный запуск** — тесты в нескольких потоках или джобах
- **Fail-fast** — останавливаться на первой ошибке или гонять все тесты

> Проверить инструменты: `python3 --version && pip3 --version`{{execute}}

> Установить pytest: `pip3 install pytest pytest-cov pytest-xdist pytest-html 2>/dev/null | tail -3`{{execute}}

> Рабочая директория: `mkdir -p /opt/autotests-demo && cd /opt/autotests-demo`{{execute}}
