return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      jdtls = {},
    },
    setup = {
      jdtls = function()
        return true -- avoid duplicate servers
      end,
    },
  },
}
