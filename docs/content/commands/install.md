---
title: install
date: 2020-12-18
---

To install one or more packages.

Usage: `brrr install <package names>`

Examples: 

- To use the [freezer](https://github.com/SiegfriedEhret/freezer) repository, use `brrr install something` to install something. You can specify the version: `brrr install something@1.0.0`.
- To use a local file, use `brrr install ./something.yaml` to install the `something` package.
- Since [0.233.21](https://github.com/nyrst/brrr/releases/tag/v0.233.21), `brrr` supports installing package from a different url than the main registry. For example, to install [`beulogue`](https://github.com/SiegfriedEhret/beulogue/), use `brrr install https://raw.githubusercontent.com/SiegfriedEhret/beulogue/master/brrr.yaml`

Aliases: `add`, `i`