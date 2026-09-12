-- Only apply when running inside Neovide
if not vim.g.neovide then return {} end

local function paste_clipboard() vim.api.nvim_paste(vim.fn.getreg "+", true, -1) end

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    mappings = {
      n = {
        ["<D-v>"] = { '"+P', desc = "Paste from system clipboard" },
      },
      v = {
        ["<D-v>"] = { '"+P', desc = "Paste from system clipboard" },
        ["<D-c>"] = { '"+y', desc = "Copy to system clipboard" },
      },
      i = {
        ["<D-v>"] = { paste_clipboard, desc = "Paste from system clipboard" },
      },
      c = {
        ["<D-v>"] = { "<C-R>+", desc = "Paste from system clipboard" },
      },
      t = {
        ["<D-v>"] = { paste_clipboard, desc = "Paste from system clipboard" },
      },
    },
  },
}
