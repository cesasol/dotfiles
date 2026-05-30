#!/bin/zsh
# ── config.zsh ──
# Core zsh options, history settings, and completion styling.
# Sourced by .zshrc for interactive shells.
#
# Reference: https://wiki.zshell.dev/docs/guides/customization#zsh-option-setopt


# ═══════════════════════════════════════════════════════════════════════════════
# Display
# ═══════════════════════════════════════════════════════════════════════════════

# Enable 24-bit truecolor support if the terminal claims it.
[[ $COLORTERM == *(24bit|truecolor)* ]] || zmodload zsh/nearcolor


# ═══════════════════════════════════════════════════════════════════════════════
# Globbing
# ═══════════════════════════════════════════════════════════════════════════════

setopt extended_glob  # Enable extended glob patterns: ^, ~, #, etc.
setopt dot_glob       # Include hidden files in glob results.


# ═══════════════════════════════════════════════════════════════════════════════
# History
# ═══════════════════════════════════════════════════════════════════════════════

setopt append_history         # Multiple sessions append to the same history file.
setopt extended_history       # Record timestamp for each entry.
setopt inc_append_history     # Write to file immediately, not on shell exit.
setopt share_history          # Share history across concurrent shells.

setopt hist_expire_dups_first # Trim oldest duplicates first when history overflows.
setopt hist_find_no_dups      # Skip duplicate results during history search.
setopt hist_ignore_all_dups   # Remove older duplicates when a new duplicate is added.
setopt hist_ignore_dups       # Do not record the same command twice in a row.
setopt hist_ignore_space      # Skip commands that start with a leading space.
setopt hist_reduce_blanks     # Collapse unnecessary whitespace before saving.
setopt hist_save_no_dups      # Avoid writing duplicate entries to the history file.
setopt hist_verify            # Show expanded history before executing (safety net).
setopt hist_beep              # Beep when a history search finds nothing.


# ═══════════════════════════════════════════════════════════════════════════════
# Directory Navigation
# ═══════════════════════════════════════════════════════════════════════════════

setopt auto_cd           # Type a directory name to cd into it.
setopt auto_pushd        # cd pushes the old directory onto the stack.
setopt pushd_ignore_dups # Avoid duplicate entries on the directory stack.
setopt pushd_minus       # Reverse the meaning of cd +1 / cd -1.
setopt cdable_vars       # cd into a path stored in a variable.


# ═══════════════════════════════════════════════════════════════════════════════
# Shell Behaviour
# ═══════════════════════════════════════════════════════════════════════════════

setopt prompt_subst         # Expand parameters inside $PS1 every redraw.
setopt interactive_comments # Allow comments in interactive shell input.
setopt multios              # Implicit tee/cat when multiple redirections are used.
setopt no_beep              # Silent mode on errors.
unsetopt clobber            # Require >! and >>! to overwrite existing files.


# ═══════════════════════════════════════════════════════════════════════════════
# Completion System (zstyle)
# ═══════════════════════════════════════════════════════════════════════════════

# ── Fuzzy matching ──
zstyle ':completion:*' completer _extensions _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*:approximate:*' max-errors \
  'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'

# ── Grouping & descriptions ──
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# ── Case-insensitive & partial-word matching ──
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*'

# ── Cache & rehash ──
zstyle ':completion:*' use-cache true
zstyle ':completion:*' rehash true

# ── Menu selection ──
zstyle ':completion:*' menu select

# ── Function name filtering ──
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# ── sudo: preserve root env ──
zstyle ':completion:*:sudo::' environ \
  PATH="/sbin:/usr/sbin:$PATH" HOME="/root"

# ── Colorize completion lists (populated by LS_COLORS later) ──
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"


# ═══════════════════════════════════════════════════════════════════════════════
# Plugin Build Flags (zgdbm)
# ═══════════════════════════════════════════════════════════════════════════════

zstyle ":plugin:zgdbm" cppflags "-I/usr/local/include"
zstyle ":plugin:zgdbm" cflags "-Wall -O2 -g"
zstyle ":plugin:zgdbm" ldflags "-L/usr/local/lib"
