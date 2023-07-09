{ pkgs, config, ... }:

{
  # Simply install just the packages
  environment.packages = with pkgs; [
    # User-facing stuff that you really really want to have
    vim  # or some other editor, e.g. nano or neovim
    neovim

    # Some common stuff that people expect to have
    diffutils
    findutils
    utillinux
    tzdata
    hostname
    man
    man-pages
    gnugrep
    gnupg
    gnused
    gnutar
    bzip2
    gzip
    xz
    zip
    unzip
    fd
    gawk

    keybase
    kbfs

    zsh
    tmux

    perl
    automake
    # binutils
    ccls
    cmake
    ctags
    bear

    clang
    libcxx

    # gcc
    # libstdcxx5  # gcc?

    git
    gnumake
    go
    nodejs
    python3
    rustup
    tmux
    jdk

    tree
    lua
    musl
    tree-sitter
    ruby
    tig
    silver-searcher
    sumneko-lua-language-server
    #nodePackages_latest.bash-language-server
    vimPlugins.nvim-treesitter

    openssh
    wget
    curl
    gdb
    coreutils
    procps
  ];

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "23.05";

  # After installing home-manager channel like
  #   nix-channel --add https://github.com/rycee/home-manager/archive/release-21.05.tar.gz home-manager
  #   nix-channel --update
  # you can configure home-manager in here like
  home-manager.config =
   { pkgs, ... }:
   {
     # Read the changelog before changing this value
     home.stateVersion = "23.05";

     # Use the same overlays as the system packages
     nixpkgs.overlays = config.nixpkgs.overlays;

     # insert home-manager config

     # programs.neovim = {
     #   enable = true;
     #   withPython3 = true;
     #   plugins = with pkgs.vimPlugins; [
     #     (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
     #   ];
     # };
     programs.java.enable = true;
   };
   home-manager.useUserPackages = true;

}

# vim: ft=nix
