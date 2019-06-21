#!/bin/sh
#
# The first pane set at 65%, split horizontally, set to api root and running vim
# pane 2 is split at 25% and running redis-server
# pane 3 is set to api root and bash prompt.
#
session="dashboard"

tmux start-server
tmux new-session -d -s $session

tmux select-window -t $session:0
tmux rename-window jira-carry-over
tmux send-keys "~/projects/jira-carry-over/.virtualenv/bin/python ~/projects/jira-carry-over/jira-carry-over.py report --board 446 --since 2019-01-01" C-m

# create a new window called diffs
tmux new-window -t $session:2 -n code-review
tmux select-window -t $session:2
tmux send-keys "cd /Users/cseibert/projects/differential-comments; ./.virtualenv/bin/python differential-comments.py --days 10 --comment-days 1" C-m

tmux new-window -t $session:3 -n git-stats
tmux select-window -t $session:3
tmux send-keys "cd /Users/cseibert/src/server; gf origin; cd /Users/cseibert/projects/git-stats; python git-stats.py --path /Users/cseibert/src/server --days 30 --just-totals" C-m

# return to main vim window
tmux select-window -t $session:0

# Finished setup, attach to the tmux session!
tmux attach-session -t $session
