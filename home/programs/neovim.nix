{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias  = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      # UI
      catppuccin-nvim
      lualine-nvim
      nvim-web-devicons

      # Navigation
      telescope-nvim
      nvim-tree-lua

      # Treesitter (syntax highlighting)
      nvim-treesitter.withAllGrammars

      # LSP
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      luasnip

      # QOL
      comment-nvim
      nvim-autopairs
      gitsigns-nvim
      which-key-nvim
    ];

    extraLuaConfig = ''
      -- Options
      vim.opt.number         = true
      vim.opt.relativenumber = true
      vim.opt.expandtab      = true
      vim.opt.shiftwidth     = 2
      vim.opt.tabstop        = 2
      vim.opt.smartindent    = true
      vim.opt.wrap           = false
      vim.opt.termguicolors  = true
      vim.opt.signcolumn     = "yes"
      vim.opt.scrolloff      = 8
      vim.opt.undofile       = true

      -- Colorscheme
      require("catppuccin").setup({ flavour = "mocha" })
      vim.cmd.colorscheme("catppuccin")

      -- Statusline
      require("lualine").setup({ options = { theme = "catppuccin" } })

      -- Comment.nvim
      require("Comment").setup()

      -- Autopairs
      require("nvim-autopairs").setup()

      -- Gitsigns
      require("gitsigns").setup()

      -- Which-key
      require("which-key").setup()

      -- File tree (toggle with <leader>e)
      require("nvim-tree").setup()

      -- Keymaps
      vim.g.mapleader = " "
      local map = vim.keymap.set
      map("n", "<leader>e",  "<cmd>NvimTreeToggle<cr>",           { desc = "File tree" })
      map("n", "<leader>ff", "<cmd>Telescope find_files<cr>",     { desc = "Find files" })
      map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",      { desc = "Live grep" })
      map("n", "<leader>fb", "<cmd>Telescope buffers<cr>",        { desc = "Buffers" })
      map("n", "<leader>w",  "<cmd>w<cr>",                        { desc = "Save" })
      map("n", "<leader>q",  "<cmd>q<cr>",                        { desc = "Quit" })
    '';
  };
}
