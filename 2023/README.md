# Advent of Code 2023

Doing this in Roc!

## How to Run

Put your test data into `test.in` and full data into `data.in`, and then you can
do

```shell
$ roc run dayN.roc < test.in
$ roc run dayN.roc < data.in
```

There's a warning about Stdin not being used, but that's just a bug I presume.
The `Util.roc` file depends on it and uncommenting it from the dayN files gives
the error

```
── MODULE NOT IMPORTED ────────────────────────────────────────────── Util.roc ─

The `Stdin` module is not imported:

24│       cur <- Task.await Stdin.line
                            ^^^^^^^^^^

Did you mean to import it?
```

so yeah, I'm just ignoring it for now.

## Version

Since there's no backwards compatible guarantees, here's what I'm running

```
roc nightly pre-release, built from commit a56d7ad on Fr 01 Dez 2023 09:08:29 UTC
```
