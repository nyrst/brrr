# brrr

`brrr` is the command line tool to install packages from the [freezer](https://github.com/SiegfriedEhret/freezer) repository.

## Installation

Download `brrr` from the [releases page](https://github.com/SiegfriedEhret/brrr/releases).

## Usage

Run `brrr` !

:warning:

- You need to have `tar` and `unzip` installed.
- For now, you will have to add `~/.config/brrr/bin` to your PATH.

The following commands are available:

### `brrr cache <command>`

To interact with the cache.

The following commands are available:

- `clean`: to remove uninstalled packages and binaries from installed packages. YAML files are preserved for installed packages.

### `brrr config <command> <key?> <value?>`

- `brrr config list` to list current configuration.
- `brrr config set <key> <value>`: to set a configuration options.

The available configuration options are:

- `arch`: supported values are `linux` or `macos`. 

### `brrr install <package names>`

To install one or more packages.

Examples: 

- To use the [freezer](https://github.com/SiegfriedEhret/freezer) repository, use `brrr install something` to install something.
- To use a local file, use `brrr install ./something.yaml` to install the `something` package.


### `brrr help`

To display some help with the available commands.

### `brrr uninstall <package names>`

The opposite of `install`!

### `brrr upgrade <package names>`

To upgrade everything or a specific package.

- Use `brrr upgrade` to start the upgrade process on all your packages.
- Use `brrr <package names>` to start the upgrade process on given packages.

### `brrr version`

To display the current version.

### Soon

- `brrr doctor`: to find what is wrong in your brrr files.

## Cache and configuration

The cache is in `~/.cache/brrr` and contains yaml definitions and downloaded packages.

The configuration is in `~/.config/brrr` and contains 2 subfolders:

- `bin`: symbolic links to packages executables.
- `packages`: the unarchived packages or binaries.

## Development

### Contributing

1. Fork it (<https://github.com/SiegfriedEhret/brrr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

### Contributors

- [Siegfried Ehret](https://github.com/SiegfriedEhret) - creator and maintainer

### License

This library is distributed under the MIT license. Please see the [LICENSE](./LICENSE) file.