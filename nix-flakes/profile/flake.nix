{
  description = "Global profile environment for utilities and development tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    defaultPackage.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.buildEnv {
      name = "profile-env";
      paths = with nixpkgs.legacyPackages.aarch64-darwin; [
        bat
        coreutils
        delve
        docker
        docker-compose
        eza 
        fzf
        git
        gnupg
        go
        go-task
        golangci-lint
        gopls
        govulncheck
        graphviz
        gnugrep
        jq
        lazydocker
        lua-language-server
        neovim
        protobuf
        python311Full
        ripgrep
        starship
        stow
        tmux
        tree
        zoxide
        zsh
        zsh-autosuggestions
        zsh-completions
        zsh-syntax-highlighting
        nix-zsh-completions
        atuin
      ];
      pathsToLink = [ "/share" "/share/man" "/share/doc" "/bin" "/lib" ];
      extraOutputsToInstall = [ "man" "doc" ];
    };
  };
}
