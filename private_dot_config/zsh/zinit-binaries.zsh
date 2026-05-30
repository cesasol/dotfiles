# ═══════════════════════════════════════════════════════════════════════════════
# Binary Installs from GitHub Releases
# Only installed if the command is not already on PATH.
# ═══════════════════════════════════════════════════════════════════════════════

# ── Helper: install binary from GitHub release if not on PATH ──
# Usage: z_ghbin <command> <repo> [sbin-pattern] [extra-ice ...]
#   <command>       binary name to check on PATH
#   <repo>          GitHub owner/repo
#   [sbin-pattern]  zinit sbin pattern (defaults to <command>)
#   [extra-ice ...] additional zinit ice modifiers (e.g. atclone, atpull, lman)
z_ghbin() {
  local cmd=$1 repo=$2 sbin=${3:-$1}
  if ! command -v $cmd &>/dev/null; then
    zinit ice wait from'gh-r' id-as"${cmd}-bin" sbin"$sbin" "${(@)argv[4,-1]}"
    zinit load $repo
  fi
}

# ── Helper: install Rust binary via cargo if not on PATH ──
# Usage: z_rustbin <command> <repo> [cargo-pkg] [extra-ice ...]
#   <command>     binary name to check on PATH
#   <repo>        GitHub owner/repo
#   [cargo-pkg]   crate name (defaults to <command>)
#   [extra-ice ...] additional zinit ice modifiers
z_rustbin() {
  local cmd=$1 repo=$2 pkg=${3:-$1}
  if ! command -v $cmd &>/dev/null; then
    zinit ice wait id-as"${cmd}-bin" rustup cargo"!$pkg" "${(@)argv[4,-1]}"
    zinit load $repo
  fi
}

z_ghbin zshellcheck afadesigns/zshellcheck
z_ghbin rg          BurntSushi/ripgrep
z_ghbin fd          sharkdp/fd
z_ghbin delta       dandavison/delta
z_ghbin zellij      zellij-org/zellij
z_ghbin atuin       atuinsh/atuin  'atuin -> atuin'
z_ghbin xh          ducaale/xh
z_ghbin dust        bootandy/dust
z_ghbin sd          chmln/sd
z_ghbin just        casey/just
z_ghbin tldr        tealdeer-rs/tealdeer  'tealdeer* -> tldr'
z_ghbin hyperfine   sharkdp/hyperfine
z_ghbin deno        denoland/deno
z_ghbin yt-dlp      yt-dlp/yt-dlp
z_ghbin starship    starship/starship

z_rustbin prek     j178/prek
z_rustbin rheo     freecomputinglab/rheo
z_rustbin rumdl    rvben/rumdl
z_rustbin stylua   JohnnyMorganz/StyLua
z_rustbin typstyle typstyle-rs/typstyle
z_rustbin utpm     utpm

# Infisical CLI — binary, completion & manpage from GitHub release
z_ghbin infisical Infisical/cli 'infisical' \
  atclone'cp -vf completion/infisical.zsh _infisical; cp -vf manpages/infisical.1.gz .' \
  atpull'%atclone' \
  lman
