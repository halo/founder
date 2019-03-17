![](https://img.shields.io/circleci/project/github/halo/founder/master.svg)
![](https://img.shields.io/github/license/halo/founder.svg?color=blue)

## TL; DR

`gem install bundler` is much to ask for on freshly set up operating system or from an unexperienced user. Founder will *on-the-fly* download and run bundler so that your code gets all dependencies it needs.

That means `git clone` and `bin/yourexecutable` is all your end-users need to know.

## Your intention

Founder was created for the following use case:

* You created a CLI tool written in Ruby and you want to share it with the world.

* Your code has a Gemfile and depends on some gems.

* You expect someone to be able to clone your repository and run the executable.

In other words, you want to create an out-of-the-box experience running your tool (for non-Rubyist and on pristine operating systems).

Good examples are running chef, dotfiles or similar bootstrapping kind of scripts on unprepared machines.

## The Problem

When someone wants to use your code, they'd first have to run `gem install bundler` and `bundle install`.

Unfortunately, that's doomed to fail on most operating systems (I won't go into the details why).

macOS: `ERROR:  While executing gem ... (Gem::FilePermissionError)`

Debian/Ubuntu: `-bash: bundle: command not found`

That's dissatisfactory and, in the worst case, leaves a bad impression for both Ruby and your tool.

## The solution

Ruby ships with the operating system, it's just not at your finger tips in the shell.

Programmatically, you *could* download bundler and use it to download your gem dependencies.

That's what Founder intends to do for you **under the hood**:

1. Given the basic Ruby interpreter, a gem can be downloaded using `Gem::Commands::InstallCommand`, that's how we obtain the Bundler gem.

1. Once Bundler is available, we use `Bundler::CLI` to process your `Gemfile` and download all relevant gems.

1. Using `Bundler.setup` these gems will be added to your `$LOAD_PATH`.


## Requirements

If you're targeting experienced Ruby users, who already have Ruby set up properly and installed the Bundler gem, you wouldn't need Founder.

But if you target a wider audience, you should use a Ruby interpreter that exists on the target system, such as `#!/usr/bin/ruby`

You won't have a cutting edge version, but most likely

* `2.3.7p456` on [macOS](https://apple.stackexchange.com/a/257629)
* `2.3.3p222` on [Debian](https://packages.debian.org/stretch/ruby)
* at least the same on [Ubuntu](https://askubuntu.com/questions/918838/which-ruby-version-is-included-in-ubuntu-16-04).

That should be good enough for most use cases. Founder itself is tested on Ruby `2.3.3`.

## Setup

1. Copy-and-paste the file `founder.rb` into your `lib` directory.

   > It doesn't have to be the `lib` directory, but that's ususally where your Ruby code goes. You'll always find the latest version of `founder.rb` in this Github repository.

1. Create a `Gemfile` and `Gemfile.lock` in the usual way.

   > I strongly recommend placing both of them into a subdirectoy `vendor`, because all the gems will be downloaded into the same directory where the `Gemfile` is located. By default, Founder looks it in `vendor/Gemfile`.

## Usage

1. `require 'founder'`

   > This is assuming that your executable set up the `$LOAD_PATH` in a way that `founder.rb` can be required via your `lib` directory. You might use `require_relative` instead.

1. Run `Founder.install`

   > This will download all gems specified in the `Gemfile` and append them to your `$LOAD_PATH`.

1. Now you can `require` any gem you specified in your `Gemfile`.

   > That means that you now can continue your code execution as usual, now having all relevant gems at your disposal.

## Configuration

Before running `Founder.install` you might want to configure its behavior:

```ruby
Founder.configure do |config|

  # The full path to the Gemfile (and Gemfile.lock).
  # Defaults to `../vendor/Gemfile` relative to `founder.rb` like so:
  config.gemfile_path = ::File.expand_path('../vendor/Gemfile', __dir__)

  # Where all gems will be installed to.
  # Defaults to `../vendor` relative to `founder.rb` like so:
  config.download_path = config.gemfile_path.parent

  # Which version of Bundler to download.
  # Defaults to something recent.
  config.bundler_version = '2.0.1'

  # Whether or not to show extra logging output.
  # Defaults to true if `--debug` or DEBUG=1 is provided.
  config.debug = ARGV.dup.delete('--debug') || ENV['DEBUG']

  # Which logger to use.
  # Defaults to `/dev/null`.
  # Defaults to `STDOUT` if `config.debug` is true.
  config.logger = config.debug ? ::Logger.new($stdout) : ::Logger.new('/dev/null')
end
```

`Founder.install` downloads bundler, installs the gems, and adds them to your load path. All in one go.

You can use `Founder.download` to only download bundler and the specified gems. You can then run `Founder.setup` to add them to your load path.

## The future

Eventually RubyGems and Bundler [will become one](https://github.com/rubygems/rubygems/issues/1681) and recent versions of Ruby [already include Bundler](https://bugs.ruby-lang.org/issues/12733). That will make things a lot easier, but until then, it's useful to resort to Founder.

## License

MIT (see header in `founder.rb`)
