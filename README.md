# brrr

`brrr` is the command line tool to install packages from the [freezer](https://github.com/SiegfriedEhret/freezer) repository (and more).

## Installation

Download `brrr` from the [releases page](https://github.com/SiegfriedEhret/brrr/releases).

:warning:

- You need to have `tar` and `unzip` installed.
- For now, you will have to add `~/.config/brrr/bin` to your PATH.

### :construction: Run with Docker

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

## Documentation

Visit [https://brrr.nyrst.tools](https://brrr.nyrst.tools) or browse the [./docs/content/](./docs/content/) folder!
