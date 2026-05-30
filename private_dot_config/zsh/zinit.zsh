#!/bin/zsh
# ── zinit.zsh ──
# Plugin declarations for zinit.
# Organized by loading priority: annexes → core → system → tools → prompt → heavy.
#
# Docs: https://wiki.zshell.dev/docs/getting_started/installation
#
# ── About `zinit ice wait` ──
# `wait` delays loading a plugin until after the first prompt appears.
#   wait        = load immediately after prompt (no delay)
#   wait'0a'    = load at priority 0a (before 0b, etc.)
#   wait'1'     = load 1 second after prompt
#   wait'!'     = load immediately, but asynchronously
# Combine with `lucid` to suppress the "loaded in …ms" message.


# ═══════════════════════════════════════════════════════════════════════════════
# Zinit Annexes (extensions to zinit itself)
# Must load FIRST — no wait.
# ═══════════════════════════════════════════════════════════════════════════════

zinit lucid build for @zdharma-continuum/zunit

zinit lucid light-mode for \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-submods \
  zdharma-continuum/zinit-annex-binary-symlink \
  zdharma-continuum/zinit-annex-linkman \
  zdharma-continuum/zinit-annex-rust \
  zdharma-continuum/zinit-annex-bin-gem-node \
    atinit'Z_A_USECOMP=1' \
  NICHOLAS85/z-a-eval

# if [[ -z $Z_NO_BIN_INSTALL ]]; then
#     source "${ZDOTDIR}/zinit-binaries.zsh"
# fi

# ═══════════════════════════════════════════════════════════════════════════════
# Core Interaction
# Must load BEFORE prompt — no wait.
# These affect key bindings, aliases, and basic shell behaviour.
# ═══════════════════════════════════════════════════════════════════════════════

# Prezto utility & editor modules
zinit lucid for \
  PZTM::utility \
  PZTM::editor

# Oh-My-Zsh git aliases and functions
zinit snippet OMZ::plugins/git/git.plugin.zsh


# ═══════════════════════════════════════════════════════════════════════════════
# System Integrations
# Completions and environment tweaks needed for early commands.
# ═══════════════════════════════════════════════════════════════════════════════

# LS_COLORS: generate dircolors and feed them into completion list-colors
zinit ice eval"dircolors -b LS_COLORS" \
  atload'zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"'
zinit light trapd00r/LS_COLORS

# Kubectl completions (generated on-the-fly, cached by zinit)
# No wait — completions should be ready for the first kubectl tab-press.
zinit ice lucid id-as"kubectl_completion" has"kubectl" \
  eval"kubectl completion zsh" run-atpull
zinit light @zdharma-continuum/null

# Nix shell integration
# wait'0a' — needed early if you run nix-shell, but not blocking.
zinit ice wait'0a' lucid has'nix-shell'
zinit load chisui/zsh-nix-shell

# Batman (bat-extras) environment export
# wait'0b' — batman is rarely used interactively; defer heavily.
zinit ice wait'0b' nocompile id-as'eth-p/bat-extras/batman' has'batman' \
  eval'batman --export-env'
zinit load @zdharma-continuum/null


# ═══════════════════════════════════════════════════════════════════════════════
# CLI Tool Integrations
# Explicitly-invoked tools — defer until after prompt.
# ═══════════════════════════════════════════════════════════════════════════════

# fzf preview script (ships with fzf repo)
# wait — only needed when fzf is actually invoked.
zinit ice wait nocompile has'fzf' id-as'fzf-preview' \
  sbin'bin/fzf-preview.sh -> fzf-preview'
zinit load junegunn/fzf

# Better git TUI (requires fzf)
# wait — forgit commands (e.g. glog, gdiff) are explicitly invoked.
zinit ice wait lucid has'git' has'fzf'
zinit load wfxr/forgit

# Navi (interactive cheat-sheet) widget
# wait'0b' — invoked via keybinding, very late-loading.
zinit ice wait'0b' nocompile lucid id-as'navi-widget' has'navi' \
  eval'navi widget zsh'
zinit load @zdharma-continuum/null

# fnm (Fast Node Manager) environment
# wait'0b' — only relevant in Node.js projects.
zinit ice wait'0b' nocompile lucid id-as'fnm-eval' has'fnm' \
  eval'fnm env'
zinit load @zdharma-continuum/null

# pay-respects (thefuck alternative) completions
# wait — only used after a failed command.
zinit ice wait nocompile lucid id-as"pay-respects-completions" \
  has"pay-respects" eval"pay-respects zsh"
zinit load @zdharma-continuum/null

# Broot (tree + fuzzy finder) shell function
# wait — only invoked when running broot.
zinit ice wait lucid id-as'broot-fn' has'broot' \
  eval'broot --print-shell-function zsh'
zinit load @zdharma-continuum/null

# Zoxide (smart cd) — aliased to 'x'
# wait — replaces cd, so load early-after-prompt so first `cd` works.
zinit ice wait lucid nocompile id-as'zoxide' has'zoxide' \
  eval'zoxide init zsh --cmd=x'
zinit load @zdharma-continuum/null


# ═══════════════════════════════════════════════════════════════════════════════
# Extra Completions (from repos, not release tarballs)
# ═══════════════════════════════════════════════════════════════════════════════

# Bun completions (official upstream)
# wait'0b' — only needed when typing bun commands.
zinit ice wait'0b' lucid as'completion' blockf has'bun'
zinit snippet https://github.com/oven-sh/bun/blob/main/completions/bun.zsh

# Eza (modern ls) integration with AUTOCD
# wait'0a' — eza replaces ls, so load early; first ls should use eza.
zinit ice wait'0a' has'eza' atinit'AUTOCD=1'
zinit load z-shell/zsh-eza

# pnpm shell completions (only active inside pnpm projects)
# wait'0b' — only relevant inside pnpm projects.
zinit wait'0b' lucid for \
  has'pnpm' \
  has'curl' \
  id-as'pnpm-shell-completion' \
  atclone"./zplug.zsh; zinit creinstall -q ." \
  load'[[ -f "$PWD/pnpm-lock.yaml" ]]' \
  unload'![[ -f "$PWD/pnpm-lock.yaml" ]]' \
  g-plane/pnpm-shell-completion

# ── Completions for GitHub-release binaries ──

# just completions
zinit ice as'completion' blockf has'just' \
  atclone'just --completions zsh > _just' \
  atpull'%atclone'
zinit load casey/just

# deno completions
zinit ice as'completion' blockf has'deno' \
  atclone'deno completions zsh > _deno' \
  atpull'%atclone'
zinit load denoland/deno

# atuin completions
zinit ice as'completion' blockf has'atuin' \
  atclone'atuin gen-completions --shell zsh > _atuin' \
  atpull'%atclone'
zinit load atuinsh/atuin

# fd completions (shipped in repo)
zinit ice as'completion' blockf has'fd' \
  pick'contrib/completion/_fd'
zinit load sharkdp/fd


# ═══════════════════════════════════════════════════════════════════════════════
# Prompt
# ═══════════════════════════════════════════════════════════════════════════════

if [[ "${TERM##*-}" == 256color ]] || [[ ${terminfo[colors]:-0} -gt 255 ]]; then
  # ── Powerlevel10k (full features, requires 256+ colors) ──
  # wait"!" = async load so prompt appears instantly.
  zinit ice wait"!" depth'1' \
    atload"source ${ZDOTDIR}/.p10k.zsh; _p9k_precmd" \
    nocd
  zinit light romkatv/powerlevel10k

  # Alternatives (commented out):
  # zinit ice wait"!" id-as"starship" has"starship" eval"starship init zsh" run-atpull
  # zinit light @zdharma-continuum/null
  # zinit ice wait"!" id-as"spaceship"
  # zinit light spaceship-prompt/spaceship-prompt
else
  # ── Pure (minimal, works on basic terminals) ──
  # No wait needed — Pure is tiny and loads fast.
  zinit ice lucid nocd \
    pick"/dev/null" \
    multisrc"{async,pure}.zsh" \
    atload'!prompt_pure_precmd'
  zinit load sindresorhus/pure
fi


# ═══════════════════════════════════════════════════════════════════════════════
# Heavy / Late-loading Plugins
# Load LAST — only after everything else is ready.
# ═══════════════════════════════════════════════════════════════════════════════

# zsh-autocomplete (alternative to built-in compinit; disabled for now)
# zinit ice lucid
# zinit load marlonrichert/zsh-autocomplete

# Copy system completions
zinit for as'completion' \
    id-as'system-completions' \
    atclone"+zi-message 'Installing System Completions...'; command mkdir -p ${ZPFX}/share/zsh/$ZSH_VERSION/completions; command cp -f /usr/share/zsh/functions/Completion/*/_*(.) ${ZPFX}/share/zsh/$ZSH_VERSION/completions; zi creinstall -q /usr/share/zsh/functions/Completion; zi cclear -q" \
    atpull'%atclone' \
    atload'fpath=( ${(u)fpath[@]:#/usr/share/zsh/functions/Completion/*} ); fpath+=( ${ZPFX}/share/zsh/$ZSH_VERSION/completions );' \
    run-atpull nocompile lucid \
    @zdharma-continuum/null

zinit for \
    atload"zicompinit; zicdreplay" \
    blockf \
    lucid \
    wait \
  zsh-users/zsh-completions \
    trackbinds \
    atload"bindkey $terminfo[kcuu1] history-substring-search-up;
           bindkey $terminfo[kcud1] history-substring-search-down" \
  zsh-users/zsh-history-substring-search \
  zsh-users/zsh-syntax-highlighting \
  zsh-users/zsh-autosuggestions
