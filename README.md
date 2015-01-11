# tmux-ut:  Runtime unit tests for tmux
## Introduction
This uses the [ts - test script](https://github.com/thinkerbot/ts) framework
to define a series of tests that can be run against tmux.

The idea is that this will form a series of tests to exercise problems and
help diagnose issues, both in terms of user issues and means to reproduce
segfaults, etc.  By augmenting these tests with those fixes and new
features, this should make tmux even better than it already is.

## Writing tests

Tests are broadly defined into sections (core, session, windows, panes,
etc.), with files contained under `tests/` directory within the `tmux-ut`
repository.  Each file contains tests appropriate to the part of tmux.

The tests themselves are written
[using ts(1)](https://github.com/thinkerbot/ts), with some helper functions
contained in `test_helper`; those functions being documented.

## Running tests

See `run-tests`

## Contact

Any questions, email me, or find me in `#tmux` on freenode (`thomas_adam`)

-- Thomas Adam
