# Changelog

## [0.46368.144](https://github.com/nyrst/brrr/releases/tag/0.46368.144)

- :gift: allow more fields in templates

## [0.28657.144](https://github.com/nyrst/brrr/releases/tag/0.28657.144)

- :gift: nicer message on `brrr config`
- :gift: store the real url instead of the config file
- :gift: remove old way to handle package version in config (BREAKING)
- :gift: show real download url since it is removed from the freezer files

## [0.17711.144](https://github.com/nyrst/brrr/releases/tag/0.17711.144)

- :gift: nicer way to have the version in a template

## [0.10946.144](https://github.com/nyrst/brrr/releases/tag/0.10946.144)

- :gift: handle templates in package definitions
- :fire: remove doctor command

## [0.6765.89](https://github.com/nyrst/brrr/releases/tag/0.6765.89)

- :gift: allow multiple urls for a release
- :gift: add check for brrr version

## [0.4181.89](https://github.com/nyrst/brrr/releases/tag/0.4181.89)

- :gift: add support for macosarm

## [0.2584.89](https://github.com/nyrst/brrr/releases/tag/0.2584.89)

- :gift: extract script commands, allow to specify working dir for "run"
- :whale: build static binary with docker

## [0.1597.89](https://github.com/nyrst/brrr/releases/tag/0.1597.89)

- :gift: add list command
- refactor a few things

## [0.987.89](https://github.com/nyrst/brrr/releases/tag/v0.987.89)

- :gift: add `echo` (with a `message`) type for scripts to display a message
- :gift: add `run` (with a `command`) type for script to run a command
- :gift: update some logs for snowy messages :snowflake:

## [0.610.89](https://github.com/nyrst/brrr/releases/tag/v0.610.89)

- :gift: order packages by name in brrr outdated and brrr upgrade

## [0.610.55](https://github.com/nyrst/brrr/releases/tag/v0.610.55)

- :wrench: remove yaml_mapping
- :gift: show upgrade command for outdated packages
- :gift: add a message to brrr info when there is nothing to do

Also, add a few aliases:

- help: "h", "help"
- install: "add", "i", "install"
- uninstall: "remove", "rm", "u", "uninstall"
- upgrade: "up", "upgrade"
- version: "v", "version"

## [0.377.55](https://github.com/nyrst/brrr/releases/tag/v0.377.55)

- :bug: show package name when uninstalling
- :wrench: fix build on macos

## [0.377.34](https://github.com/nyrst/brrr/releases/tag/v0.377.34)

- :bug: fix display of version when installing something already installed
- :wrench: upgrade for crystal 0.35, use std log instead of dexter

## [0.377.21](https://github.com/nyrst/brrr/releases/tag/v0.377.21)

- :gift: add `brrr info` command.

## [0.233.21](https://github.com/nyrst/brrr/releases/tag/v0.233.21)

- :gift: add support for distributed package definitions
- :wrench: add logging dependency and add -v flag

## [0.144.21](https://github.com/nyrst/brrr/releases/tag/v0.144.21)

:bug: fix crash on not found package name.

## [0.144.13](https://github.com/nyrst/brrr/releases/tag/v0.144.13)

- :gift: allow to specify the package version to install
- :gift: suggest upgrade when installing an already installed package
- :bug: fix crash on uninstalling a non installed package

## [0.89.8](https://github.com/nyrst/brrr/releases/tag/v0.89.8)

- :bug: fix env variable handling

## [0.89.5](https://github.com/nyrst/brrr/releases/tag/v0.89.5)

:gift: allow to configure cache and config path with env variables

- `BRRR_CACHE_PATH` for cache directory
- `BRRR_CONFIG_PATH` for config directory

## [0.55.5](https://github.com/nyrst/brrr/releases/tag/v0.55.5)

- :gift: add `brrr outdated` command.

## [0.34.5](https://github.com/nyrst/brrr/releases/tag/v0.34.5)

- :gift: add `brrr reset` command.

## [0.21.5](https://github.com/nyrst/brrr/releases/tag/v0.21.5)

- Nothing much, a new way to handle post install scripts.

## [0.21.3](https://github.com/nyrst/brrr/releases/tag/v0.21.3)

- :gift: add `brrr doctor` command.

## [0.13.3](https://github.com/nyrst/brrr/releases/tag/v0.13.3)

- :bug: fix hash handling (again)

## [0.13.2](https://github.com/nyrst/brrr/releases/tag/v0.13.2)

- :bug: fix hash handling

## [0.13.1](https://github.com/nyrst/brrr/releases/tag/v0.13.1)

- :gift: add `brrr upgrade` command.

## [0.8.1](https://github.com/nyrst/brrr/releases/tag/v0.8.1)

- :truck: Switch to `nyrst` organization url.

## [0.5.1](https://github.com/nyrst/brrr/releases/tag/v0.5.1)

- :gift: Add `brrr cache clean`.
- :wrench: Some refactoring :smile:

## [0.3.1](https://github.com/nyrst/brrr/releases/tag/v0.3.1)

- :art: Update display of version
- :memo: Update cli docs

## [0.3.0](https://github.com/nyrst/brrr/releases/tag/v0.3.0)

- :gift: Add `uninstall` command.
- :art: Update some logs and error messages.

## [0.2.0](https://github.com/nyrst/brrr/releases/tag/v0.2.0)

- :gift: Allow to configure brrr (`brrr config list`, `brrr config set arch <value>`).
- :memo: Add logs for version and arch when incompatible.

## [0.1.0](https://github.com/nyrst/brrr/releases/tag/v0.1.0)

- :rocket: Initial version!
- :smile: It works on my computer :tm:.