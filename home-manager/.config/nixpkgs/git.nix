{ config, lib, ... }:

{
  programs.git = {
    enable = true;

    userName = "Thiago Kenji Okada";
    userEmail = "thiagokokada@gmail.com";

    aliases = {
      branch-cleanup = ''
        !git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d #'';
      pushf = "push --force-with-lease";
      logs = "log --show-signature";
    };

    ignores = lib.splitString "\n"
      (builtins.readFile (config.my.dotfilesDir + "/git/.config/git/ignore"));

    includes = [{ path = "~/.config/git/local"; }];

    extraConfig = {
      branch = { sort = "-commiterdate"; };
      color = { ui = true; };
      commit = { verbose = true; };
      core = {
        whitespace = "trailing-space,space-before-tab,indent-with-non-tab";
        excludesfile = "~/.config/git/ignore_local";
      };
      checkout = { defaultRemote = "origin"; };
      github = { user = "thiagokokada"; };
      merge = { tool = "nvim -d"; };
      pull = { rebase = true; };
      push = { default = "simple"; };
      rebase = { autoStash = true; };
    };
  };

  programs.zsh.shellAliases = { gk = "run-bg gitk"; };
}
