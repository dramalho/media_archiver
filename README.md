[![Gem Version](https://badge.fury.io/rb/media_archiver.svg)](http://badge.fury.io/rb/media_archiver)

# MediaArchiver

Utility that scans a given location for media files and,
based on Exif information and a set of rules copies the files over to
another location.


## Installation

### MAC OS X

You need `exiftool` to use this command. Simply do:

```bash
brew install exiftool
```

Then install the gem

```bash
gem install media_archiver
```

and you're done

## Usage

run `media_archiver` from the command line

```bash
Commands:
media_archiver copy [DIR] [OUTPUT_DIR]  # Scans a folder and archives media files
media_archiver help [COMMAND]           # Describe available commands or one specific command
```

## Configuration

Apart from the options you can set when running individual commands, the script will look for a `.media_archiver_conf.yml` file both in the current folder and on you home folder.

Configurations are prioritized like:

1. CLI options
1. Current folder configuration file
1. Home folder configuration file


```yaml
---
output_dir: ~/photos
recursive: true
output_template: :DateTimeOriginal/:Make/:Model
```

### `output_template`

Anything that starts with a colon the script will replace with the corresponding
EXIF tag (if set on the individual file), while anything thing else is taken
as-is and is placed directly on the output path.

Not all media files have the same EXIF tags and not all are commonly used. You
can check the [list of possible tags](http://owl.phy.queensu.ca/~phil/exiftool/TagNames/index.html)
and test around with your own files.

Also, any date/time values are currently transformed to a fixed date string.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/media_archiver/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
