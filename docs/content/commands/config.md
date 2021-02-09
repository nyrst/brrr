---
title: config
date: 2020-12-18
---

To change the configuration.

Usage: `brrr config <command> <key?> <value?>`

- `brrr config list` to list current configuration.
- `brrr config set <key> <value>`: to set a configuration options.

The available configuration options are:

- `arch`: supported values are `linux`, `macos` or `macosarm`
- `repository`: the base url for the repository. Defaults to "http://nyrst.github.io/freezer/"