-- conform.nvim ships with LazyVim; just add the Java formatter.
-- Loaded lazily by LazyVim (no longer force-required at startup).
return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      java = { "google-java-format" },
    },
  },
}
