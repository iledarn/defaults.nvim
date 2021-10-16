{ pkgs ? import <nixpkgs> {
    overlays = [
      (import (builtins.fetchTarball {
        url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
      }))
    ];
  }
}:
with pkgs;
let
  neovimPythonPackages = p: with p; [
    jedi
    flake8
    black
    pylint
  ];
  neovim = pkgs.neovim.override {
    extraPython3Packages = neovimPythonPackages;
    withPython3 = true;
    withNodeJs = true;
  };
in
mkShell {
  buildInputs = [
    # Customized packages
    tmux
    git
    nixpkgs-fmt
    python
    python3
    neovim

    fd
    ripgrep
    nodePackages.diagnostic-languageserver
    nodePackages.json-server
    nodePackages.pyright
    rnix-lsp
    rust-analyzer
    clang-tools
    (lib.optional pkgs.stdenv.isLinux sumneko-lua-language-server)
  ];

  shellHook = ''
    alias nvim="nvim -u $(pwd)/init.lua"
  '';
}
