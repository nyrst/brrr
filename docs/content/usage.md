---
title: Usage
date: 2020-12-18
description: How to run brrr
---

Run `brrr` !

:warning:

- You need to have `tar` and `unzip` installed.
- For now, you will have to add `~/.config/brrr/bin` to your PATH.

Next steps: explore the commands, for example:

=> {{ ref("./commands/config.md") }}<br>
=> {{ ref("./commands/list.md") }}<br>
=> {{ ref("./commands/install.md") }}

## :construction: Run with Docker

`brrr` is available as a [Docker image](https://hub.docker.com/r/nyrst/brrr). This is experimental!

Run it:

```shell
docker run --rm -it nyrst/brrr info atom
```

To generate freezer data with [Fish](https://fishshell.com/):

```shell
docker run --rm -it -v {$PWD}:/workspace -w /workspace nyrst/brrr info atom
```

Or with bash:

```shell
docker run --rm -it -v ${PWD}:/workspace -w /workspace nyrst/brrr info atom
```
