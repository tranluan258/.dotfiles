return {
  -- Bazel integration
  {
    "alexander-born/bazel.nvim",
    ft = { "java", "bzl", "starlark" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "<leader>bb", "<cmd>Bazel build<CR>", desc = "Bazel build current target" },
      { "<leader>br", "<cmd>Bazel run<CR>", desc = "Bazel run current target" },
      { "<leader>bt", "<cmd>Bazel test<CR>", desc = "Bazel test current target" },
      { "<leader>bT", "<cmd>Bazel test --test_output=all<CR>", desc = "Bazel test (verbose)" },
      { "<leader>bg", "<cmd>BazelGetCurrentBufTarget<CR>", desc = "Get Bazel target for current file" },
    },
    config = function()
      require("bazel").setup({
        -- Default Bazel command
        bazel_cmd = "bazel",
      })
    end,
  },

  -- Treesitter for Starlark/Bazel syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "starlark",
        "java",
      })
    end,
  },

  -- Configure filetype for BUILD files
  {
    "nathom/filetype.nvim",
    lazy = true,
    opts = {
      overrides = {
        extensions = {
          bzl = "bzl",
        },
        literal = {
          BUILD = "bzl",
          ["BUILD.bazel"] = "bzl",
          WORKSPACE = "bzl",
          ["WORKSPACE.bazel"] = "bzl",
        },
      },
    },
  },
}
