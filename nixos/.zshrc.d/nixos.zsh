export NIX_HOME="${DOTFILES_PATH}/_nixos"

if [[ -n "${commands[fzf-share]}" ]]; then
  source "$(fzf-share)/key-bindings.zsh"
fi

alias nixos-clean-up="sudo -- sh -c 'nix-collect-garbage -d && nixos-rebuild boot --fast'"
alias nix-remove-stray-roots="nix-store --gc --print-roots | awk '{print $1}' | grep /result$ | sudo xargs rm"

nix-sha256-github() {
  local author="${1}"
  local repo="${2}"
  local commit="${3:-master}"

  if (( ${#} < 2 )); then
    echo "Usage: nix-sha256-github <author> <repo> [commit]" 2>&1
    return
  fi

  nix-prefetch-url --unpack "https://github.com/${author}/${repo}/archive/${commit}.tar.gz"
}

nixos-copy-etc() {
  diff --color=auto -r "${NIX_HOME}/etc/nixos" /etc/nixos/

  while true; do
    printf '%s' 'Copy current NixOS configuration (y/n)? '
    read yn
    case $yn in
        [Yy]* ) cp -r /etc/nixos/^(configuration.nix|hardware-configuration.nix)* ${NIX_HOME}/etc/nixos
                break;;
        [Nn]* ) break;;
        * ) echo 'Please answer (y)es or (n)o.';;
    esac
  done
}

nixos-restore-etc() {
  diff --color=auto -r /etc/nixos/ "${NIX_HOME}/etc/nixos"

  while true; do
    printf '%s' 'Restore NixOS configuration (y/n)? '
    read yn
    case $yn in
        [Yy]* ) sudo cp -r ${NIX_HOME}/etc/nixos/* /etc/nixos
                break;;
        [Nn]* ) break;;
        * ) echo 'Please answer (y)es or (n)o.';;
    esac
  done
}

nix-build-derivation() {
  nix-build -E "with import <nixpkgs> {}; callPackage `realpath "$1"` {}"
}

UPGRADE_CMDS+="sudo nixos-rebuild switch --upgrade"
