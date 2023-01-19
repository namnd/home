{ config, pkgs, lib, ... }:

let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  unstable = import (fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz) { };
in
{
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  home.stateVersion = "22.05";

  home.packages = with pkgs; [
    awscli2
    aws-vault
    coreutils
    csvkit
    jq

    # Nix LSP
    rnix-lsp

    # Neovim related
    unstable.neovim
    cht-sh
    lemonade # remote clipboard over TCP

    # Other CLI tools
    fd
    fzf
    tldr
    tree
    pass
    cloc
    hugo
    ripgrep
  ] ++ lib.optionals (isLinux) [
    gcc
    unzip
  ] ++ lib.optionals (isDarwin) [
    colima
    docker
  ];

  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    config = {
      global = {
        warn_timeout = "10m";
      };
    };
    nix-direnv = {
      enable = true;
    };
  };

  imports = [
    ./custom.nix
  ];
}
