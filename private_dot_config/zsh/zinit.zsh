zinit lucid build for @zdharma-continuum/zunit
zinit lucid light-mode for \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-submods \
  zdharma-continuum/zinit-annex-binary-symlink \
  zdharma-continuum/zinit-annex-linkman \
  atinit'Z_A_USECOMP=1' \
  NICHOLAS85/z-a-eval

# Interaction
zinit lucid for \
  PZTM::utility \
  PZTM::editor
zinit snippet OMZ::plugins/git/git.plugin.zsh

# System snippets
zinit ice eval"dircolors -b LS_COLORS" \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zinit light trapd00r/LS_COLORS

zinit ice lucid id-as"kubectl_completion" has"kubectl" \
      eval"kubectl completion zsh" run-atpull
zinit light @zdharma-continuum/null

# Nix integration
zinit ice wait lucid has'nix-shell'
zinit load chisui/zsh-nix-shell

zinit ice wait'0a' lucid id-as'eth-p/bat-extras/batman' has'batman' eval'batman --export-env'
zinit load @zdharma-continuum/null

# fzf tab
#zinit for \
#  nocompile \
#  lucid \
#  has'fzf' \
#  wait'0b' \
#  Aloxaf/fzf-tab \
#  Freed-Wu/fzf-tab-source

# fzf preview script
zinit ice wait'0a' lucid has'fzf' id-as'fzf-preview' sbin'bin/fzf-preview.sh -> fzf-preview'
zinit load junegunn/fzf

# Better git ui
zinit ice wait'0a' lucid  has'git' has'fzf'
zinit load wfxr/forgit

# Start pay-respects completions
zinit ice wait'0a' nocompile lucid id-as"pay-respects-completions" has"pay-respects" eval"pay-respects zsh"
zinit load @zdharma-continuum/null

# Infisical CLI
zinit ice from'gh-r' \
  atclone"cp -vf manpages/infisical.1.gz $ZINIT[MAN_DIR]/man1;
          cp -vf completions/infisical.zsh _infisical" \
  as'program' \
  sbin'infisical'
zinit load Infisical/cli

zinit ice lucid wait as'completion' blockf has'bun'
zi snippet https://github.com/oven-sh/bun/blob/main/completions/bun.zsh

# Eza integration with zsh
zinit ice wait'0a' has'eza' atinit'AUTOCD=1'
zinit load z-shell/zsh-eza

# Enable broot
zinit ice wait'0a' lucid id-as'broot-fn' has'broot' eval'broot --print-shell-function zsh'
zinit load @zdharma-continuum/null

# PNPM completion
zi wait'0a' lucid for \
  has'pnpm' \
  has'curl' \
  id-as'pnpm-shell-completion' \
  atclone"./zplug.zsh; zi creinstall -q ." \
  load'[[ -f "$PWD/pnpm-lock.yaml" ]]' \
  unload'![[ -f "$PWD/pnpm-lock.yaml" ]]' \
  g-plane/pnpm-shell-completion

typeset -i C_PROMPT
export C_PROMPT=2

if [[ "${TERM##*-}" = 256color ]] || [[ ${terminfo[colors]:?} -gt 255  ]]; then
 # ~/.config/zsh/.p10k.zsh.
 zinit ice wait"!" depth'1' \
   atload"source ~/.config/zsh/.p10k.zsh; _p9k_precmd" nocd
 zinit light romkatv/powerlevel10k
else
  # Load pure for not so good terminals
  zinit ice lucid nocd \
    pick"/dev/null" multisrc"{async,pure}.zsh" \
    atload'!prompt_pure_precmd' lucid nocd
  zinit load sindresorhus/pure
fi

# Heavy zsh stuff and completions
# zinit ice lucid
# zinit load marlonrichert/zsh-autocomplete

zinit for \
    atload"zicompinit; zicdreplay" \
    blockf \
    lucid \
    wait \
  zsh-users/zsh-completions \
    trackbinds \
    atload"bindkey $terminfo[kcuu1] history-substring-search-up; bindkey $terminfo[kcud1] history-substring-search-down" \
  zsh-users/zsh-history-substring-search \
  zsh-users/zsh-syntax-highlighting \
  zsh-users/zsh-autosuggestions

