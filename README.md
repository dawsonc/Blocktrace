Blocktrace
==========

A Ruby command line tool for tracing Bitcoins from a given address through the blockchain.

Usage
-----

`blocktrace trace ADDRESS [OPTIONS]`

### Options

+ `--start_time` (`-s`): The time of the earliest transaction you want to track, in UNIX Epoch Time. Defaults to 0.
+ `--min_amonut` (`-a`): Transactions with a BTC value lower than this will be ignored. Defaults to 0.
+ `--depth` (`-d`): How many transaction levels to traverse. Defaults to 1.
  - 1 finds all addresses the original address sent BTC to.
  - 2 finds all the addresses 1 finds, plus any address *those* addresses sent BTC to.
  - etc.
+ `--verbose` (`-v`): Verbose mode


NOTE: Traces can take a while. You can use `--min_amount` and `--max_depth` to shorten the search time (at the expense of detail, however)

Installation
------------

```
git clone https://github.com/TheBritKnight/Blocktrace.git
chmod 755 ./.blocktrace
```

Note: requires [Thor](https://github.com/erikhuda/thor) (`gem install thor`)
