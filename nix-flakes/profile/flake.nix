{
  description = "Global profile environment for utilities and development tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    pkgs = import nixpkgs { system = "aarch64-darwin"; };
  in {
    defaultPackage.aarch64-darwin = pkgs.buildEnv {
      name = "profile-env";
      paths = [
        (pkgs.python311.withPackages(ps: with ps; [
          mido
          python-rtmidi
          pip
        ]))
        pkgs.bat
        pkgs.coreutils
        pkgs.delve
        pkgs.docker
        pkgs.docker-compose
        pkgs.eza
        pkgs.fzf
        pkgs.git
        pkgs.gnupg
        pkgs.go
        pkgs.go-task
        pkgs.golangci-lint
        pkgs.gopls
        pkgs.govulncheck
        pkgs.graphviz
        pkgs.gnugrep
        pkgs.jq
        pkgs.lazydocker
        pkgs.lua-language-server
        pkgs.neovim
        pkgs.protobuf
        pkgs.ripgrep
        pkgs.starship
        pkgs.stow
        pkgs.tmux
        pkgs.tree
        pkgs.zoxide
        pkgs.zsh
        pkgs.zsh-autosuggestions
        pkgs.zsh-completions
        pkgs.zsh-syntax-highlighting
        pkgs.nix-zsh-completions
        pkgs.atuin
        pkgs.portmidi
      ];
      pathsToLink = [ "/share" "/share/man" "/share/doc" "/bin" "/lib" ];
      extraOutputsToInstall = [ "man" "doc" ];
    };
  };
}
