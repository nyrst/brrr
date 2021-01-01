---
title: Package definition
date: 2021-01-01
---

## Example

An example can help, right? The package definition for [exa](https://github.com/nyrst/freezer/blob/main/exa.yaml) is a good way to start.

## Definition

A package is a yaml file with the following mandatory properties:

- `brrr` (`String`): the url of the definition file.
- `latest_version` (`String`): the latest available version (used later in `versions`).
- `name` (`String`): the name of the package.
- `tags` (`Array(String)`): an array of tags related to the project.
- `url` (`String`): the url of the package repository.
- `versions` (`Hash(VersionId, Version)`): the real deal, where versions are described.

And optional properties:

- `brrr_version` (`String`): the minimal brrr version to use (compatible if not present). 
- `releases_feed` (`String`): the rss feed to get new versions information. Useful to update the content of this repository.

### versions

The type for `versions` is `Hash(VersionId, Version)`

- Key: `VersionId` (`String`, mandatory): the version identifier, often a Semantic Version or a date.
- Value: `Version` (`VersionBinary | WithTemplate`):
  - a `VersionBinary` (`Hash(Arch, Binary | Array(Binary))`): either a Binary or an array of Binary, in an object with available architectures as keys. See below for the Binary definition.
  - a `WithTemplate`, see below for its definition.

A Binary has the following properties:

- `binary_type` (`String`, mandatory): the type of binary file. Supported values: `binary`, `tar`, `zip`.
- `url` (`String`, mandatory): the url of the binary to download.
- `hash_<hash type>` (`String?`, optional): the hash for the file from the `url`. Supported values for `<hash type>` are: `md5`,`sha1`.
- `post_install` (`Array(PostInstall)`, mandatory): see what is a `PostInstall` just below.

A WithTemplate has the following properties:


- `use_template` (`String`): the version of the template to use

This requires another root property in your yaml: `templates`. The type is `Hash(VersionId, Hash(Arch, Binary | Array(Binary)))`.

### PostInstall

A PostInstall has the following properties:

- `type` (`String`, mandatory): the type of the post install thing to run. Supported values: `echo`, `move`, `run`, `symlink`.

For the `echo` type, use the following property:

- `message`: the message to display.

For the `move` type, use the following properties:

- `source`: the path to the binary/folder to move.
- `target`: the target folder to move the source into.

For the `run` type, use the following property:

- `command`: the command to execute. If an error occurs, it will be logged. Otherwise, the command output will be logged.
- `working_directory`: the command to run, relative to the current package directory (:warning: use with caution, there are no checks on where things are executed!)

For the `symlink` type, use the following properties:

- `source`: the path to the executable.
- `target`: the name of the symlink (see the exa example).