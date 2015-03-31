# Kajiki

[![Gem Version](https://badge.fury.io/rb/kajiki.svg)](http://badge.fury.io/rb/kajiki)

A simple gem to build daemons.

It provides basic functions to start and stop a daemon process. It also parses command-line options.

## Requirements

- Ruby 2.0.0 <=

Kajiki has no gem dependencies. It uses [Trollop](https://rubygems.org/gems/trollop), but it's embedded.

## Getting Started

### Install

```
$ gem install kajiki
```

### Code

```ruby
require 'kajiki'

opts = Kajiki.preset_options(:minimal)
Kajiki.run(opts) do |command|
  case command
  when 'start'
    while true
      puts 'Are we there yet?'
      sleep(5)
    end
  when 'stop'
    puts 'Arrived!'
  end
end
```

### Use

To see help:

```
$ myapp -h
Usage: myapp [options] {start|stop}
  -d, --daemonize    Run in the background
  -p, --pid=<s>      Store PID to file
  -h, --help         Show this message
```

To start your app as a daemon:

```
$ myapp -d -p ~/myapp.pid start
```

To stop your app running as a daemon:

```
$ myapp -p ~/myapp.pid stop
```

### More

There are two ways to use Kajiki.

1. With preset command-line option parsing and auto daemonizing
2. Custom option parsing and semi-auto daemonizing
