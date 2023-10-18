return {
  { "Shatur/neovim-session-manager", enabled = false },
  { "stevearc/resession.nvim", enabled = false },
  { "AstroNvim/astrocommunity" },
  { "williamboman/mason-lspconfig.nvim" },
  { "jay-babu/mason-null-ls.nvim" },
  { "jay-babu/mason-nvim-dap.nvim" },
  {
    "goolord/alpha-nvim",
    config = function()
      require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end,
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {}
      dashboard.section.buttons.val = {
        dashboard.button("s", "⌕ Find Session", "<cmd>Telescope possession list<cr>"),
        dashboard.button("f", "⌕ Find Files", "<cmd>Telescope find_files<cr>"),
        dashboard.button("t", " Find Text", "<cmd>Telescope live_grep<cr>"),
        dashboard.button("r", "⧖ Recent Files", "<cmd>Telescope oldfiles<cr>"),
        dashboard.button("z", "󰏖 Lazy", "<cmd>Lazy<cr>"),
        dashboard.button("q", " Quit", "<cmd>qa<cr>"),
      }
      return dashboard
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "jedrzejboczar/possession.nvim",
    },
    config = function(...)
      require "plugins.configs.telescope"(...)
      local telescope = require "telescope"
      telescope.load_extension "possession"
      telescope.load_extension "neoclip"
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      linehl     = false,
      numhl      = true,
      signcolumn = true,
      current_line_blame_opts = { ignore_whitespace = true },
    },
  },
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require("astronvim.utils.status")
      local mycomponent = {provider = "test"}

      opts.statusline = {
        hl = { fg = "fg", bg = "bg" },
        status.component.mode { mode_text = { padding = { left = 1, right = 1 } } },
        {
          provider = function()
            session = require('possession.session').session_name or 'Untitled'
            return "󱂬 "..session.."  "
          end,
        },
        status.component.git_branch(),
        status.component.file_info { filetype = {}, filename = false, file_modified = false },
        status.component.git_diff(),
        status.component.diagnostics(),
        status.component.fill(),
        status.component.cmd_info(),
        status.component.fill(),
        status.component.lsp(),
        status.component.treesitter(),
        status.component.nav(),
      }
      return opts
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      default_component_configs = {
        git_status = {
          symbols = {
            untracked = "?",
          }
        }
      },
      filesystem = {
        filtered_items = {
	        visible = true,
	        hide_dotfiles = false,
	        hide_gitignored = false,
        },
      }
    }
  },
}
