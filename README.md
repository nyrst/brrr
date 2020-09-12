# brrr

`brrr` is the command line tool to install packages from the [freezer](https://github.com/SiegfriedEhret/freezer) repository (and more).

## Installation

Download `brrr` from the [releases page](https://github.com/SiegfriedEhret/brrr/releases).

## Usage

Run `brrr` !

:warning:

- You need to have `tar` and `unzip` installed.
- For now, you will have to add `~/.config/brrr/bin` to your PATH.

### Basic commands

#### `brrr config <command> <key?> <value?>`

- `brrr config list` to list current configuration.
- `brrr config set <key> <value>`: to set a configuration options.

The available configuration options are:

- `arch`: supported values are `linux` or `macos`. 

#### `brrr info <package names>`

Show info for given package.

Example, here with `broot` not installed, and `beulogue` previously installed from a custom location:

```
❯ brrr info atom broot beulogue
broot
—————
Definition: https://nyrst.github.io/freezer/broot.yaml
Available versions: 0.13.6, 0.14.2
Latest version: 0.14.2

beulogue
————————
Definition: https://github.com/SiegfriedEhret/beulogue/raw/master/brrr.yaml
Available versions: 3.0.1
Latest version: 3.0.1
Installed version: 3.0.1
```

#### `brrr install <package names>`

To install one or more packages.

Examples: 

- To use the [freezer](https://github.com/SiegfriedEhret/freezer) repository, use `brrr install something` to install something. You can specify the version: `brrr install something@1.0.0`.
- To use a local file, use `brrr install ./something.yaml` to install the `something` package.
- Since [0.233.21](https://github.com/nyrst/brrr/releases/tag/v0.233.21), `brrr` supports installing package from a different url than the main registry. For example, to install [`beulogue`](https://github.com/SiegfriedEhret/beulogue/), use `brrr install https://raw.githubusercontent.com/SiegfriedEhret/beulogue/master/brrr.yaml`

Aliases: `add`, `i`

#### `brrr outdated`

To list installed packages and next available versions.

#### `brrr upgrade <package names>`

To upgrade everything or a specific package.

- Use `brrr upgrade` to start the upgrade process on all your packages.
- Use `brrr <package names>` to start the upgrade process on given packages.

Alias: `up`

#### `brrr uninstall <package names>`

The opposite of `install`!

Aliases: `remove`, `rm`, `u`, `uninstall`

### Utility commands

#### `brrr cache <command>`

To interact with the cache.

The following commands are available:

- `clean`: to remove uninstalled packages and binaries from installed packages. YAML files are preserved for installed packages.

#### `brrr doctor`

To find what is wrong in your brrr files.

#### `brrr help`

To display some help with the available commands.


Alias: `h`

#### `brrr reset`

Remove all installed packages (like `uninstall` but shorter).

#### `brrr version`

To display the current version.

Alias: `v`

## Cache and configuration

The cache is in `~/.cache/brrr` and contains yaml definitions and downloaded packages.

The configuration is in `~/.config/brrr` and contains 2 subfolders:

- `bin`: symbolic links to packages executables.
- `packages`: the unarchived packages or binaries.

If needed, the cache and config directories can be set using environment variables:

- `BRRR_CACHE_PATH` for cache directory
- `BRRR_CONFIG_PATH` for config directory

## FAQ

**How to list available packages?**

The package list is available on [Freezer](https://github.com/nyrst/freezer).
I have a few things to make package discovery a nice experience.

**Why this?**

I want a simple and quick way to install packages, and [brew](https://brew.sh/) is spending to much time upgrading itself or its package catalog.

**What is this `nyrst` thing?**

It all started because of `brew`. I wanted a name like `brew` but different and I chose `brrr`. Like when it is cold.
Then came the package repository, I called it `freezer`.
All this happened on my personal GitHub account, and I decided to move it to an organization.
I spend a lot of time looking for a name around the themes of "cold", "ice", "north" etc.
I came into the word `nyrst` totally randomly.

This is absolutely not affiliated with [Nyrst](https://www.youtube.com/watch?v=X7KqqGRe8-I), a black metal band from Iceland. They have a [bandcamp page](https://nyrst.bandcamp.com/). Check them out!
