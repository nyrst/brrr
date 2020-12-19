---
title: Cache and configuration
date: 2020-12-18
---

The cache is in `~/.cache/brrr` and contains yaml definitions and downloaded packages.

The configuration is in `~/.config/brrr` and contains 2 subfolders:

- `bin`: symbolic links to packages executables.
- `packages`: the unarchived packages or binaries.

If needed, the cache and config directories can be set using environment variables:

- `BRRR_CACHE_PATH` for cache directory
- `BRRR_CONFIG_PATH` for config directory
