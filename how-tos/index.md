---
layout: page
title: "How-Tos"
date: 
modified:
excerpt: "How-tos on using Kajiki"
tags: []
---

There are couple ways to use Kajiki.

1. [The easier way](#easy-way): use preset option parser and daemonization.
2. [The harder way](#hard-way): semi-DIY

<a id="easy-way"></a>
## The Easier Way

The `.preset_options(preset)` method sets up a predefined command-line option parser. Possible options for `preset` are: `:minimal`, `:simple`, and `:server`. It also parses a command; either `start` or `stop`.

Pass the options object from above and a block to the `.run(opts)` method to kick things off. The block should evaluate the command and do things accordingly. The block is executed after all the options are processed for the `start` command; for the `stop` command, the block is executed prior to termination.

### A Sinatra Based Server

A example of a Sinatra modular server that responds with current time.

```ruby
require 'kajiki'
require 'sinatra/base'

class Server < Sinatra::Base
  get '/time' { Time.now.to_s }
end

opts = Kajiki.preset_options(:server)
Kajiki.run(opts) do |command|
  case command
  when 'start'
    Server.run!(bind: opts[:address], port: opts[:port])
  when 'stop'
    puts "Terminating PID #{IO.read(opts[:pid])}..."
  end
end
```

Help would look like this.

```
$ ruby server.rb -h
Usage: server.rb [options] {start|stop}
  -a, --address=<s>    Bind to address (default: 0.0.0.0)
  -d, --daemonize      Run in the background
  -e, --error=<s>      Output error to file
  -g, --group=<s>      Group to run as
  -l, --log=<s>        Log output to file
  -P, --pid=<s>        Store PID to file
  -p, --port=<i>       Use port (default: 4567)
  -u, --user=<s>       User to run as
  -h, --help           Show this message
```

Running the server with some options. The command can be anywhere.

```
$ ruby server.rb -d -e ~/server.error -l ~/server.log -P ~/server.pid -p 7777 start
$ curl http://127.0.0.1:7777/time
2015-02-24 22:56:34 -0800
```

To stop the server, only the PID file is essential.

```
$ ruby server.rb -P ~/server.pid stop
```

### Toggling Options

Some options can be toggled from the default by calling the method like this.

```ruby
Kajiki.preset_options(:server, {config: true, error: false, user: false})
```

This would produce a slightly different help from the above.

```
$ ruby server.rb -h
Usage: server.rb [options] {start|stop}
  -a, --address=<s>    Bind to address (default: 0.0.0.0)
  -c, --config=<s>     Load config from file
  -d, --daemonize      Run in the background
  -l, --log=<s>        Log output to file
  -P, --pid=<s>        Store PID to file
  -p, --port=<i>       Use port (default: 4567)
  -h, --help           Show this message
```

<a id="hard-way"></a>
## The Harder Way

Coming soon.
