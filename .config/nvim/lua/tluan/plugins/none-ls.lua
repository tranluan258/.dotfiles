return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.gofumpt,
        null_ls.builtins.code_actions.impl,
        null_ls.builtins.formatting.google_java_format.with({
          extra_args = { "--aosp" },
        }),
      },
    })
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.java",
      callback = function()
        vim.lsp.buf.format()
      end,
    })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function()
        vim.opt_local.tabstop = 4 -- how many spaces a <Tab> looks like
        vim.opt_local.shiftwidth = 4 -- spaces per indentation level
        vim.opt_local.softtabstop = 4 -- spaces when you hit <Tab>
        vim.opt_local.expandtab = true -- convert tabs to spaces
      end,
    })
  end,
}
