# Поздравляем! Модуль «Автотесты в пайплайне» завершён! 🎉

## Что изучили

- **pytest**: fixtures, классы тестов, `@pytest.mark.parametrize`, маркеры
- **Coverage**: `--cov`, `--cov-fail-under`, HTML/XML/term отчёты, интеграция в GitLab UI
- **JUnit XML**: `--junitxml`, парсинг XML, отображение в GitHub/GitLab MR
- **HTML отчёты**: `--html --self-contained-html`, артефакты в CI
- **go test**: table-driven тесты, `t.Run` подтесты, бенчмарки, race detector, coverage
- **Параллельный запуск**: `pytest-xdist -n auto`
- **Fail-fast vs полный прогон**: `-x` для разработки, matrix builds для совместимости
- **Умные пайплайны**: unit тесты на каждый push, coverage + matrix только для MR

## Шпаргалка

```bash
python3 -m pytest \
  -n auto \
  --tb=short \
  --cov=mymodule \
  --cov-fail-under=80 \
  --cov-report=xml \
  --junitxml=report.xml
```

## Следующий модуль

| Модуль | Статус |
|--------|--------|
| CI/CD 01-05: Основы CI/CD | ✅ Готово |
| CI/CD 06: Автотесты | ✅ Готово |
| CI/CD 07: Стратегии деплоя | → Следующий |
