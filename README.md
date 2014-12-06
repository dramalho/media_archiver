[![Gem Version](https://badge.fury.io/rb/media_archiver.svg)](http://badge.fury.io/rb/media_archiver)

# MediaArchiver

Utility that scans a given location for media files and,
based on Exif information and a set of rules copies the files over to
another location.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'media_archiver'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install media_archiver

## Usage

run `media_archiver` from the command line

```
Commands:
media_archiver copy [DIR] [OUTPUT_DIR]  # Scans a folder and archives media files
media_archiver help [COMMAND]           # Describe available commands or one specific command
media_archiver scan [PATH]              # Scans a folder for media files and returns info
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/media_archiver/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
