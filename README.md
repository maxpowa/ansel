# ANSEL

TODO: Write a description here

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  ansel:
    github: maxpowa/ansel
```


## Usage


```crystal
require "ansel"

ANSEL::Converter.convert("UTF-8 string") # Outputs String of ANSEL bytes
ANSEL::Converter.convert("String of ANSEL bytes", to_charset: "UTF-8") # Outputs String of UTF-8 bytes
ANSEL::Converter.convert("UTF-8 string", output_io: STDOUT) # Outputs ANSEL bytes to STDOUT
ANSEL::Converter.convert("String of ANSEL bytes", output_io: STDOUT, to_charset: "UTF-8") # Outputs UTF-8 bytes to STDOUT
```

## Development

Don't?

## Contributing

1. Fork it ( https://github.com/maxpowa/ansel/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [maxpowa](https://github.com/maxpowa) Max Gurela - creator, maintainer
- [RX14](https://github.com/RX14) Chris Hobbes - moral support
