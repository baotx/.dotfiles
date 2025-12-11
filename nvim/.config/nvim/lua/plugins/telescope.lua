return {
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, conf)
      conf.pickers = vim.tbl_deep_extend("force", conf.pickers or {}, {
        find_files = {
          hidden = true,
        },
      })

      conf.defaults = vim.tbl_deep_extend("force", conf.defaults or {}, {
        file_ignore_patterns = {
          "%.git/",
        },
      })

      return conf
    end,
  },
}