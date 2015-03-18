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

# Tests for windows

. test_helper

win_limit=$((RANDOM % 20))

test_can_add_windows_to_session()
{
	for win in $(eval echo {1..$win_limit})
	do
		tmux neww -d -t"$TMUX_TEST_SESSION"
		assert_status 0 $? "Couldn't create window $win"
	done
}

test_windows_in_session_totals()
{
	output=$(tmux display -t"$TMUX_TEST_SESSION" \
		-pF'#{session_windows}')
	# The win_limit won't include the first window created when the
	# test_session was, so increment it to 1, and test against the output
	# from tmux.
	((win_limit++))
	assert_output "$win_limit" "$output"
}

test_window_creation_at_end()
{

	before="$(tmux list-windows -F'#{window_index}' -t"$TMUX_TEST_SESSION")"
	wl="$(tmux new-window -d -PF '#{window_index}')"
	after="$(tmux list-window -F'#{window_index}' -t"$TMUX_TEST_SESSION")"

	# Get the intersection between before and after; that is, the
	# newly-created winlink.
	intersec="$(comm -13 <(echo "$before") <(echo "$after"))"

	assert_output "$wl" "$intersec"
}

test_window_can_be_killed()
{
	win_totals=$(tmux display -t"$TMUX_TEST_SESSION" \
		-pF '#{session_windows}')

	tmux neww -k

	new_win_totals=$(tmux display -t"$TMUX_TEST_SESSION" \
		-pF '#{session_windows}')

	# In terms of comparison, add one, so that the numbers match.
	((win_totals++))
	assert_output "$win_totals" "$new_win_totals"
}

test_window_can_be_renamed()
{
	local new_win="neww"
	tmux rename-window "$new_win"
	local win_name="$(tmux display -pF'#{window_name}')"

	assert_output "$new_win" "$win_name"
}

. ts
