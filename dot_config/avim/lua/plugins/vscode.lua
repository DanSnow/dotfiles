if true then return {} end -- use commonity receipes
if not vim.g.vscode then return {} end

local vscode = require "vscode-neovim"
vim.notify = vscode.notify
-- lvim.builtin.autopairs.active = false
-- lvim.builtin.treesitter.highlight.enable = false
-- disable so we can use builtin indent
-- lvim.builtin.treesitter.indent.enable = false
-- lvim.builtin.cmp.active = false

---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      -- Configure core features of AstroNvim
      features = {
        autopairs = false,
        cmp = false,
        highlighturl = false,
        notifications = false, -- enable notifications at start
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = false,
  },
}
