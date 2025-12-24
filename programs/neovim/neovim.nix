{ pkgs, ... }:

{
programs.neovim = {
	enable = true;	  
plugins = with pkgs.vimPlugins; [
    catppuccin-nvim
    nvim-cmp
    cmp-nvim-lsp
    cmp-buffer
    cmp-path
    luasnip
    friendly-snippets
    nvim-lspconfig
    nvim-treesitter.withAllGrammars
    cord-nvim
    nvim-tree-lua
    bufferline-nvim
    lualine-nvim
    telescope-nvim
    mini-nvim
    auto-save-nvim
  ];

extraPackages = with pkgs; [
    tailwindcss-language-server
    lua-language-server
    astro-language-server
    vtsls
    emmet-language-server
];


    extraLuaConfig = builtins.readFile ./config/init.lua;
};
}
