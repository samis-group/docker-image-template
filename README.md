# docker-image-{image_name}

Docker image for {image_name}. It does what? It uses what tech? More info please.

[![Docker Image - {image_name}](https://github.com/samis-group/docker-image-{image_name}/actions/workflows/build-image.yaml/badge.svg)](https://github.com/samis-group/docker-image-{image_name}/actions/workflows/build-image.yaml)

## Testing Images Locally - Development Workflow

> Build the container

```bash
make {image_name}
```

> Obtain shell in the container

```bash
make {image_name}-shell
```

> Spin up the container's docker-compose stack

```bash
make {image_name}-compose-up
```

> Execute command inside container

```bash
make {image_name}-exec exec_command="echo Hello"
```

> Tear down the container's docker-compose stack

```bash
make {image_name}-compose-down
```

> Cleanup and remove all containers

```bash
make cleanup
```
