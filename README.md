# brrr

`brrr` is the command line tool to install packages from the [freezer](https://github.com/SiegfriedEhret/freezer) repository.

## Installation

Download `brrr` from the [releases page](https://github.com/SiegfriedEhret/brrr/releases).

## Usage

Run `brrr` !

:warning: For now, you will have to add `~/.config/brrr/bin` to your PATH.

The following commands are available:

- (soon!) `brrr cache <something>`: to interact with the cache.
- `brrr config <args>`: to manage `brrr` configuration.
- (soon!) `brrr doctor`: to find what is wrong in your brrr files.
- `brrr install <args>`: to install one (or more) packages.
- `brrr help`: to display some help
- `brrr uninstall <args>`: to remove packages.
- (soon!) `brrr update <args?>`: to update everything or a specific package.
- `brrr version`: to display the current version.

### `brrr config <command> <key?> <value?>`

- `brrr config list` to list current configuration.
- `brrr config set <key> <value>`: to set a configuration options.

The available configuration options are:

- `arch`: supported values are `linux` or `macos`. 

### `brrr install <args>`

Examples: 

- To use the [freezer](https://github.com/SiegfriedEhret/freezer) repository, use `brrr install something` to install something.
- To use a local file, use `brrr install ./something.yaml` to install the `something` package.

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