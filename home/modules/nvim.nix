{ pkgs, ... }:

{
  xdg.configFile.nvim.source = ./files/nvim;
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  home.packages = with pkgs; [
    lua-language-server
    yaml-language-server
    # python
    python312Packages.jedi-language-server
    ruff
    clang-tools
    # nodePackages_latest.vscode-json-languageserver
    # html
    emmet-ls
    vscode-langservers-extracted
    nodePackages_latest.typescript-language-server
    djlint
  ];
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      ## general plugins
      vim-wakatime
      auto-pairs
      # project-nvim # doesn't work right now
      mini-nvim
      editorconfig-nvim
      # copilot-vim
      wrapping-nvim
      ## lsp and cmp
      formatter-nvim
      nvim-lspconfig
      mason-nvim
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      nvim-cmp
      lspkind-nvim
      luasnip # may need friendly-snippets
      cmp_luasnip
      lspsaga-nvim
      ## language specific
      # haskell-vim
      plantuml-syntax
      yuck-vim
      vim-prisma
      # kdl-vim
      typst-vim
      ## treesitter
      nvim-treesitter.withAllGrammars
      rainbow-delimiters-nvim # replaces mrjones2014/nvim-ts-rainbow
      ## telescope
      telescope-nvim
      plenary-nvim
      telescope-fzf-native-nvim
      telescope-file-browser-nvim
      ## git
      vim-fugitive
      # git-blame-nvim
      vim-gitgutter
      ## UI
      gruvbox-community
      nvim-web-devicons # replaces kyazdani42/nvim-web-devicons
      virt-column-nvim
      vim-airline
      nvim-notify
      transparent-nvim
    ];
  };
}

