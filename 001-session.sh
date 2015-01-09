#!/bin/bash
#
# Copyright (c) 2015, Thomas Adam <thomas@xteddy.org>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
# SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
# OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
# CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

# Tests for sessions

. test_helper

win_limit=$((RANDOM % 20))

test_create_a_default_session()
{
	$TMUX_BINARY new-session -d
	assert_status 0 $? "Session not created"
}

test_can_create_a_named_session()
{
	$TMUX_BINARY new-session -d -s"$TMUX_TEST_SESSION"
	check_session_exists "test_session"
}

test_can_add_windows_to_session()
{
	for win in $(eval echo {1..$win_limit})
	do
		$TMUX_BINARY neww -d -t"$TMUX_TEST_SESSION"
		assert_status 0 $? "Couldn't create window $win"
	done
}

test_windows_in_session_totals()
{
	local output=$($TMUX_BINARY display -t"$TMUX_TEST_SESSION" \
		-pF'#{session_windows}')
	# The win_limit won't include the first window created when the
	# test_session was, so increment it to 1, and test against the output
	# from tmux.
	((win_limit++))
	assert_output "$win_limit" "$output"
}

. ts
