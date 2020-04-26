# brrr

`brrr` is the command line tool to install packages from the [freezer](https://github.com/SiegfriedEhret/freezer) repository.

## Installation

Download `brrr` from the [releases page](https://github.com/SiegfriedEhret/brrr/releases).

## Usage

Run `brrr` !

The following commands are available:

- `brrr install <args>`: to install one (or more) packages.
- `brrr help`: to display some help
- `brrr version`: to display the current version.

### `brrr install <args>`

Example: 

- a name from the [freezer](https://github.com/SiegfriedEhret/freezer) repository. Use `brrr install exa` to install [exa](https://github.com/ogham/exa)
- a local file. Use `brrr install ./something.yaml` to install the `something` package.

### In the near future:

- `brrr cache <something>`: to interact with the cache.
- `brrr configure`: to manage `brrr` options.
- `brrr remove <args>`: to remove packages.
- `brrr update <args?>`: to update everything or a specific package.

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