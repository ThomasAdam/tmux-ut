#!/bin/bash

. test_helper

# If we're running this time-after-time, try to tear-down then existing tmux
# server before anything else; skipping this test in the case where no such
# server exists.
test_destroy_server()
{
	if [ ! -e "$TMUX_TMPDIR/$TMUX_SOCK_NAME" ]; then
		true
	fi

	$TMUX_BINARY kill-server || rm "$TMUX_TMPDIR/$TMUX_SOCK_NAME"
}

test_start_server()
{
	$TMUX_BINARY start
	assert_status 0 $?
}

. ts
