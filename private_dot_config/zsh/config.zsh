# https://wiki.zshell.dev/docs/guides/customization#zsh-option-setopt

# Basic zsh
[[ $COLORTERM = *(24bit|truecolor)* ]] || zmodload zsh/nearcolor

setopt extended_glob
setopt dot_glob
setopt prompt_subst

# History managment
setopt append_history         # Allow multiple sessions to append to one Zsh command history.
setopt extended_history       # Show timestamp in history.
setopt hist_expire_dups_first # Expire A duplicate event first when trimming history.
setopt hist_find_no_dups      # Do not display a previously found event.
setopt hist_ignore_all_dups   # Remove older duplicate entries from history.
setopt hist_ignore_dups       # Do not record an event that was just recorded again.
setopt hist_ignore_space      # Do not record an Event Starting With A Space.
setopt hist_reduce_blanks     # Remove superfluous blanks from history items.
setopt hist_save_no_dups      # Do not write a duplicate event to the history file.
setopt hist_verify            # Do not execute immediately upon history expansion.
setopt inc_append_history     # Write to the history file immediately, not when the shell exits.
setopt share_history          # Share history between different instances of the shell.
setopt hist_beep              # Beep when accessing non-existent history.

# Directory managment
setopt auto_cd              # Use cd by typing directory name if it's not a command.
setopt auto_list            # Automatically list choices on ambiguous completion.
setopt auto_pushd           # Make cd push the old directory onto the directory stack.
setopt bang_hist            # Treat the '!' character, especially during Expansion.
setopt interactive_comments # Comments even in interactive shells.
setopt multios              # Implicit tees or cats when multiple redirections are attempted.
setopt no_beep              # Don't beep on error.
setopt prompt_subst         # Substitution of parameters inside the prompt each time the prompt is drawn.
setopt pushd_ignore_dups    # Don't push multiple copies directory onto the directory stack.
setopt pushd_minus          # Swap the meaning of cd +1 and cd -1 to the opposite.
setopt cdable_vars          # Change directory to a path stored in a variable.

unsetopt clobber            # Do not overwrite existing files with > and >>.
                            # Use >! and >>! to bypass.

# Zstyle
# Fuzzy matching of completions
zstyle ':completion:*' completer _extensions _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'
#  Pretty completions
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
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*' use-cache true
zstyle ':completion:*' rehash true
# Do menu-driven completion
zstyle ':completion:*' menu select
zstyle ':completion:*:sudo::' environ \
  PATH="/sbin:/usr/sbin:$PATH" HOME="/root"

# Color completion for some things
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Enable debug
zstyle ":plugin:zgdbm" cppflags "-I/usr/local/include"  # Additional include directory
zstyle ":plugin:zgdbm" cflags "-Wall -O2 -g"            # Additional CFLAGS
zstyle ":plugin:zgdbm" ldflags "-L/usr/local/lib"       # Additional library directory

# Less 
export LESS=" -RF"
export LESSOPEN="|/usr/bin/lesspipe.sh %s"
export LESSCOLORIZER="bat --style=plain"
