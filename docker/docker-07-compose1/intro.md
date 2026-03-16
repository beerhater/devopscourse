# Docker Compose: \u0427\u0430\u0441\u0442\u044c 1\n\n\u0412\u044b \u0443\u043c\u0435\u0435\u0442\u0435 \u0437\u0430\u043f\u0443\u0441\u043a\u0430\u0442\u044c \u043e\u0442\u0434\u0435\u043b\u044c\u043d\u044b\u0435 \u043a\u043e\u043d\u0442\u0435\u0439\u043d\u0435\u0440\u044b. \u041d\u043e \u0440\u0435\u0430\u043b\u044c\u043d\u044b\u0435 \u043f\u0440\u0438\u043b\u043e\u0436\u0435\u043d\u0438\u044f \u2014 \u044d\u0442\u043e \u043d\u0435\u0441\u043a\u043e\u043b\u044c\u043a\u043e \u0441\u0435\u0440\u0432\u0438\u0441\u043e\u0432: \u0432\u0435\u0431-\u0441\u0435\u0440\u0432\u0435\u0440, \u0431\u0430\u0437\u0430 \u0434\u0430\u043d\u043d\u044b\u0445, \u043a\u0435\u0448, \u043e\u0447\u0435\u0440\u0435\u0434\u044c \u0441\u043e\u043e\u0431\u0449\u0435\u043d\u0438\u0439. \u041a\u0430\u0436\u0434\u044b\u0439 \u0440\u0430\u0437 \u0437\u0430\u043f\u0443\u0441\u043a\u0430\u0442\u044c \u0438\u0445 \u0432\u0440\u0443\u0447\u043d\u0443\u044e \u0447\u0435\u0440\u0435\u0437  \u2014 \u043d\u0435\u0443\u0434\u043e\u0431\u043d\u043e \u0438 \u043d\u0435\u043d\u0430\u0434\u0451\u0436\u043d\u043e.\n\n**Docker Compose** \u0440\u0435\u0448\u0430\u0435\u0442 \u044d\u0442\u0443 \u043f\u0440\u043e\u0431\u043b\u0435\u043c\u0443: \u0432\u044b \u043e\u043f\u0438\u0441\u044b\u0432\u0430\u0435\u0442\u0435 \u0432\u0441\u0451 \u043f\u0440\u0438\u043b\u043e\u0436\u0435\u043d\u0438\u0435 \u0432 \u043e\u0434\u043d\u043e\u043c \u0444\u0430\u0439\u043b\u0435  \u0438 \u0443\u043f\u0440\u0430\u0432\u043b\u044f\u0435\u0442\u0435 \u0438\u043c \u043e\u0434\u043d\u043e\u0439 \u043a\u043e\u043c\u0430\u043d\u0434\u043e\u0439.\n\n\u0412 \u044d\u0442\u043e\u043c \u043c\u043e\u0434\u0443\u043b\u0435 \u0432\u044b \u043e\u0441\u0432\u043e\u0438\u0442\u0435:\n\n- \u0421\u0442\u0440\u0443\u043a\u0442\u0443\u0440\u0443 \u0444\u0430\u0439\u043b\u0430 \n- **Usage:  docker compose [OPTIONS] COMMAND

Define and run multi-container applications with Docker

Options:
      --all-resources              Include all resources, even those not used by services
      --ansi string                Control when to print ANSI control characters ("never"|"always"|"auto")
                                   (default "auto")
      --compatibility              Run compose in backward compatibility mode
      --dry-run                    Execute command in dry run mode
      --env-file stringArray       Specify an alternate environment file
  -f, --file stringArray           Compose configuration files
      --parallel int               Control max parallelism, -1 for unlimited (default -1)
      --profile stringArray        Specify a profile to enable
      --progress string            Set type of progress output (auto, tty, plain, json, quiet)
      --project-directory string   Specify an alternate working directory
                                   (default: the path of the, first specified, Compose file)
  -p, --project-name string        Project name

Management Commands:
  bridge      Convert compose files into another model

Commands:
  attach      Attach local standard input, output, and error streams to a service's running container
  build       Build or rebuild services
  commit      Create a new image from a service container's changes
  config      Parse, resolve and render compose file in canonical format
  cp          Copy files/folders between a service container and the local filesystem
  create      Creates containers for a service
  down        Stop and remove containers, networks
  events      Receive real time events from containers
  exec        Execute a command in a running container
  export      Export a service container's filesystem as a tar archive
  images      List images used by the created containers
  kill        Force stop service containers
  logs        View output from containers
  ls          List running compose projects
  pause       Pause services
  port        Print the public port for a port binding
  ps          List containers
  publish     Publish compose application
  pull        Pull service images
  push        Push service images
  restart     Restart service containers
  rm          Removes stopped service containers
  run         Run a one-off command on a service
  scale       Scale services 
  start       Start services
  stats       Display a live stream of container(s) resource usage statistics
  stop        Stop services
  top         Display the running processes
  unpause     Unpause services
  up          Create and start containers
  version     Show the Docker Compose version information
  volumes     List volumes
  wait        Block until containers of all (or specified) services stop.
  watch       Watch build context for service and rebuild/refresh containers when files are updated

Run 'docker compose COMMAND --help' for more information on a command.** \u2014 \u0437\u0430\u043f\u0443\u0441\u043a \u0438 \u043e\u0441\u0442\u0430\u043d\u043e\u0432\u043a\u0430 \u0441\u0442\u0435\u043a\u0430\n- **Usage:  docker compose [OPTIONS] COMMAND

Define and run multi-container applications with Docker

Options:
      --all-resources              Include all resources, even those not used by services
      --ansi string                Control when to print ANSI control characters ("never"|"always"|"auto")
                                   (default "auto")
      --compatibility              Run compose in backward compatibility mode
      --dry-run                    Execute command in dry run mode
      --env-file stringArray       Specify an alternate environment file
  -f, --file stringArray           Compose configuration files
      --parallel int               Control max parallelism, -1 for unlimited (default -1)
      --profile stringArray        Specify a profile to enable
      --progress string            Set type of progress output (auto, tty, plain, json, quiet)
      --project-directory string   Specify an alternate working directory
                                   (default: the path of the, first specified, Compose file)
  -p, --project-name string        Project name

Management Commands:
  bridge      Convert compose files into another model

Commands:
  attach      Attach local standard input, output, and error streams to a service's running container
  build       Build or rebuild services
  commit      Create a new image from a service container's changes
  config      Parse, resolve and render compose file in canonical format
  cp          Copy files/folders between a service container and the local filesystem
  create      Creates containers for a service
  down        Stop and remove containers, networks
  events      Receive real time events from containers
  exec        Execute a command in a running container
  export      Export a service container's filesystem as a tar archive
  images      List images used by the created containers
  kill        Force stop service containers
  logs        View output from containers
  ls          List running compose projects
  pause       Pause services
  port        Print the public port for a port binding
  ps          List containers
  publish     Publish compose application
  pull        Pull service images
  push        Push service images
  restart     Restart service containers
  rm          Removes stopped service containers
  run         Run a one-off command on a service
  scale       Scale services 
  start       Start services
  stats       Display a live stream of container(s) resource usage statistics
  stop        Stop services
  top         Display the running processes
  unpause     Unpause services
  up          Create and start containers
  version     Show the Docker Compose version information
  volumes     List volumes
  wait        Block until containers of all (or specified) services stop.
  watch       Watch build context for service and rebuild/refresh containers when files are updated

Run 'docker compose COMMAND --help' for more information on a command.** \u2014 \u0443\u043f\u0440\u0430\u0432\u043b\u0435\u043d\u0438\u0435 \u0438 \u043e\u0442\u043b\u0430\u0434\u043a\u0430\n- \u0421\u0435\u0442\u0438 \u0438 \u0442\u043e\u043c\u0430 \u0432 Compose\n- \u041f\u0435\u0440\u0435\u043c\u0435\u043d\u043d\u044b\u0435 \u043e\u043a\u0440\u0443\u0436\u0435\u043d\u0438\u044f \u0438  \u0444\u0430\u0439\u043b\u044b\n\n> \u041f\u0440\u043e\u0432\u0435\u0440\u044c\u0442\u0435 \u0432\u0435\u0440\u0441\u0438\u044e Compose: Docker Compose version v5.0.2{{execute}}\n