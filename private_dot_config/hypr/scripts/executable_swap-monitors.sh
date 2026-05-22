#!/usr/bin/env zsh
# Hyprland script
# Swaps all windows from one monitor with the relative next

monitors=("${(@f)$(hyprctl monitors -j | jq -r '.[].name')}")
count=${#monitors}

((count < 2)) && {
  echo "Only one monitor detected." >&2
  exit 1
}

focused_name=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
focused_id=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .id')

idx=${monitors[(i)$focused_name]}
next_idx=$(((idx % count) + 1))
next_name=${monitors[$next_idx]}
next_id=$(hyprctl monitors -j | jq -r --arg n "$next_name" '.[] | select(.name == $n) | .id')

# Derive base workspace per monitor from actual workspace assignments
focused_base=$(hyprctl workspaces -j | jq --argjson id "$focused_id" '[.[] | select(.monitorID == $id) | .id] | min')
next_base=$(hyprctl workspaces -j | jq --argjson id "$next_id" '[.[] | select(.monitorID == $id) | .id] | min')

# Snapshot active window before any moves
active_addr=$(hyprctl activewindow -j | jq -r '.address')

# Snapshot all windows from both monitors at once, before any moves
# Include .monitor in snapshot to avoid deriving it from workspace math
wins=("${(@f)$(hyprctl clients -j | jq -r \
  --argjson fid "$focused_id" --argjson nid "$next_id" \
  '.[] | select(.monitor == $fid or .monitor == $nid) | "\(.monitor) \(.workspace.id) \(.address)"')}")

for entry in $wins; do
  mon_id=${entry%% *}
  rest=${entry#* }
  ws=${rest%% *}
  addr=${rest##* }

  if ((mon_id == focused_id)); then
    target=$((next_base + ws - focused_base))
  else
    target=$((focused_base + ws - next_base))
  fi
  hyprctl dispatch movetoworkspacesilent "${target},address:${addr}"
done
# Focus again the initial window
hyprctl dispatch focuswindow address:"$active_addr"
