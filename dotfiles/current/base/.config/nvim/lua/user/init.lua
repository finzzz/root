return {
  updater = {
    remote         = "origin",
    channel        = "stable",
    version        = "latest",
    branch         = "nightly",
    commit         = nil,
    pin_plugins    = nil,
    skip_prompts   = false,
    show_changelog = false,
    auto_quit      = false,
  },

  colorscheme = "tokyonight",

  diagnostics = {
    virtual_text = true,
    underline    = true,
  },

  lsp = {
    formatting = {
      format_on_save = {
        enabled = true,
      },
      timeout_ms = 1000,
    },
  },

  lazy = {
    defaults = { lazy = true },
    performance = {
      rtp = {
        disabled_plugins = { "tohtml", "gzip", "matchit", "zipPlugin", "netrwPlugin", "tarPlugin" },
      },
    },
  },

  polish = function()
    -- auto-reload files when modified externally
    vim.o.autoread = true
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
      command = "if mode() != 'c' | checktime | endif",
      pattern = { "*" },
    })
    --
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        vim.opt_local.sw = 2
      end
    })
    vim.api.nvim_create_autocmd("BufWinEnter",
      {
        pattern = {
          "*.hcl",
          "*.tf",
          "*.tfvars",
          ".terraformrc",
          "terraform.rc"
        },
        command = "set ft=terraform"
      }
    )
    vim.api.nvim_create_autocmd("BufWinEnter",
      {
        pattern = "*.tfstate",
        command = "set ft=json"
      }
    )
  end
}
