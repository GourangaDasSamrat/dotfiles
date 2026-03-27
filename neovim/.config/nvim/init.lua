local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "Mofiqul/dracula.nvim",
    priority = 1000,
    config = function()
      require("dracula").setup({ italic_comment = true })
      vim.cmd("colorscheme dracula")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({ options = { theme = "dracula-nvim" } })
    end,
  },
  { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
  { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, config = true },
  { "rhysd/committia.vim" },
  { "lewis6991/gitsigns.nvim", config = true },
  -- New Dashboard Plugin
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      
      dashboard.section.header.val = {
        [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
        [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
        [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
        [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
        [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
        [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
      }
      
      dashboard.section.buttons.val = {
        dashboard.button("n", "  New File", ":enew<CR>"),
        dashboard.button("e", "󰙅  File Browser", ":Explore<CR>"),
        dashboard.button("q", "󰅚  Quit", ":qa<CR>"),
      }
      
      -- Remove the footer/usage text
      dashboard.section.footer.val = ""
      
      alpha.setup(dashboard.config)
    end,
  },
})

local o = vim.opt
o.number, o.cursorline, o.termguicolors = true, true, true
o.wrap, o.linebreak, o.scrolloff = true, true, 5
o.tabstop, o.shiftwidth, o.expandtab = 2, 2, true
o.ignorecase, o.smartcase, o.clipboard = true, true, "unnamedplus"
o.undofile, o.swapfile, o.signcolumn = true, false, "yes"
o.list, o.listchars = true, { trail = "·", tab = "→ " }
o.shortmess:append("sI")

local map = vim.keymap.set
vim.g.mapleader = " "
map("n", "<leader>w", ":w<CR>")
map("n", "<leader>q", ":q<CR>")
map("n", "<leader>Q", ":qa!<CR>")
map("n", "<Esc>", ":nohlsearch<CR>", { silent = true })
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("v", "p", '"_dP')
map("n", "<C-a>", "ggVG")

-- Git commit settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    o.textwidth, o.colorcolumn = 72, "50,72"
    o.spell = true
    vim.cmd("startinsert")
  end,
})

-- SQL specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
  end,
})

-- UI highlights
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#3d3f4e" })
    vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#bd93f9" })
  end,
})
