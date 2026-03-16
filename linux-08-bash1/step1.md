## Shebang и первый скрипт

Любой bash-скрипт начинается со строки **shebang**: `#!/bin/bash`
Она говорит системе: "Выполнять с помощью bash".

**Задание:**

1. Создайте файл `hello.sh`:

`echo '#!/bin/bash' > hello.sh`

`echo 'echo "Hello, DevOps!"' >> hello.sh`

2. Сделайте исполняемым: `chmod +x hello.sh`

3. Запустите: `./hello.sh`
