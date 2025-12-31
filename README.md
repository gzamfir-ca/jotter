# Jotter

A tool that helps to quickly create text notes using the markdown syntax and a predefined template.

## Installation

After checking out the repo, run `bin/setup` to install all the required dependencies. Then, run `bundle exec rake build` to build jotter.gem into the pkg directory. Finally run `bundle exec rake install` to install jotter.gem into the system gems.

## Usage

Next run `tip` to get a description of the available _tip_ commands:

```shell
❯ tip
Commands:
  tip help [COMMAND]  # Describes cli command
  tip new NOTE        # Creates a new MD note
  tip version         # Prints version number
```

By default the notes will be created into the **~/Documents/Markdown/note-repository** folder. The default location can be overwritten using the _path_ option as described below:

```shell
❯ tip help new
Usage:
  tip new NOTE

Options:
  -p, [--path=PATH]  # Path to note location

Creates a new MD note
```

## Development

After checking out the repo, run `bin/setup` to install all the required dependencies. Then, run `bundle exec rake` to run both tests and linting. You can also run `bin/console` for an interactive prompt that will allow you to experiment further.

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/gzamfir-ca/jotter>.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
