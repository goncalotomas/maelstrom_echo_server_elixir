# What is this?

It's a Elixir CLI tool that runs an echo server which can be tested using [maelstrom](https://github.com/jepsen-io/maelstrom).

## Installation

Install Elixir on your system and follow [maelstrom's instructions](https://github.com/jepsen-io/maelstrom/blob/main/doc/01-getting-ready/index.md) on how to get ready for testing.

## Running

Run this from the root directory of this repository:
```
mix escript.build
```

This will generate an `echo_server` binary which can then be used by maelstrom. Copy this binary to your local maelstrom installation directory and run:

```
./maelstrom test -w echo --bin echo_server --time-limit 5
```
