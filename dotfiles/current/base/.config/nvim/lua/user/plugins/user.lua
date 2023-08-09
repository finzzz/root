return {
  { "junegunn/vim-easy-align", event = "User AstroFile" },
  { "mzlogin/vim-markdown-toc", event = "User AstroFile" },
  { "machakann/vim-sandwich", event = "VeryLazy" },
  {
    "stevearc/oil.nvim",
    opts = {
      default_file_explorer = false,
      use_default_keymaps = false,
      view_options = {
        show_hidden = true
      },
      keymaps = {
        ["<C-c>"] = "actions.close",
        ["<C-r>"] = "actions.refresh",
        ["<C-h>"] = "actions.toggle_hidden",
        ["<cr>"]  = "actions.select",
        [","]     = "actions.parent",
        ["."]     = "actions.open_cwd",
      },
    },
    cmd = "Oil"
  },
  {
    "chentoast/marks.nvim",
    event = "User AstroFile",
    opts = {
      default_mappings = false,
      mappings = {
        set_next = false,
        next = "]",
        prev = "[",
        toggle = "mm",
      }
    }
  },
  {
    "phaazon/hop.nvim",
    branch = 'v2',
    config = function()
      require'hop'.setup { keys = 'plmoknijb8uhv7ygc6tfx5rdz4es3wa2q' }
    end,
    cmd = {
      "HopLineStart",
      "HopPattern",
      "HopWord"
    }
  },
  {
    "AckslD/nvim-neoclip.lua",
    requires = {
      {'nvim-telescope/telescope.nvim'},
    },
    config = function()
      require('neoclip').setup()
    end,
  },
  {
    "karb94/neoscroll.nvim",
    event = "User AstroFile",
    config = function()
      require('neoscroll').setup({
        mappings = { "<C-u>", "<C-d>", "<PageUp>", "<PageDown>" },
        hide_cursor = true,
        stop_eof = true,
        use_local_scrolloff = false,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = nil,
        pre_hook = nil,
        post_hook = nil,
      })

      local t = {}
      t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '100'}}
      t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '100'}}
      t['<PageUp>'] = {'scroll', {'-vim.wo.scroll', 'true', '100'}}
      t['<PageDown>'] = {'scroll', {'vim.wo.scroll', 'true', '100'}}
      require('neoscroll.config').set_mappings(t)
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = {
      use_diagnostic_signs = true,
      action_keys = {
        close = { "q", "<esc>" },
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    as = "tokyonight",
    config = function()
      require("tokyonight").setup {
        style = "night",
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = "italic",
          sidebars = "dark",
          floats = "dark",
        },
        sidebars = { "qf", "help" },
        day_brightness = 0.3,
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = false,
      }
    end,
  },
  {
    "jedrzejboczar/possession.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      local Path = require('plenary.path')
      require('possession').setup {
        session_dir = (Path:new(vim.fn.stdpath('data')) / 'possession'):absolute(),
        silent = false,
        load_silent = true,
        debug = false,
        logfile = false,
        prompt_no_cr = false,
        autosave = {
          current = false,  -- or fun(name): boolean
          tmp = false,  -- or fun(): boolean
          tmp_name = 'tmp',
          on_load = true,
          on_quit = true,
        },
        commands = {
          save = 'PossessionSave',
          load = 'PossessionLoad',
          rename = 'PossessionRename',
          close = 'PossessionClose',
          delete = 'PossessionDelete',
          show = 'PossessionShow',
          list = 'PossessionList',
          migrate = 'PossessionMigrate',
        },
        hooks = {
          before_save = function(name) return {} end,
          after_save = function(name, user_data, aborted) end,
          before_load = function(name, user_data) return user_data end,
          after_load = function(name, user_data) end,
        },
        plugins = {
          close_windows = {
            hooks = {'before_save', 'before_load'},
            preserve_layout = true,  -- or fun(win): boolean
            match = {
              floating = true,
              buftype = {},
              filetype = {},
              custom = false,  -- or fun(win): boolean
            },
          },
          delete_hidden_buffers = {
            hooks = {
              'before_load',
              vim.o.sessionoptions:match('buffer') and 'before_save',
            },
            force = false,  -- or fun(buf): boolean
          },
          nvim_tree = true,
          tabby = true,
          dap = true,
          delete_buffers = false,
        },
      }
    end,
    lazy = false
  },
  {
    "pwntester/octo.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function ()
      require"octo".setup({
        mappings = {
          issue = {
            close_issue = { lhs = "<space>Gic", desc = "close issue" },
            reopen_issue = { lhs = "<space>Gio", desc = "reopen issue" },
            list_issues = { lhs = "<space>Gil", desc = "list open issues on same repo" },
            copy_url = { lhs = "<space>Giu", desc = "copy url to system clipboard" },
            add_assignee = { lhs = "<space>Gaa", desc = "add assignee" },
            remove_assignee = { lhs = "<space>Gad", desc = "remove assignee" },
            create_label = { lhs = "<space>Glc", desc = "create label" },
            add_label = { lhs = "<space>Gla", desc = "add label" },
            remove_label = { lhs = "<space>Gld", desc = "remove label" },
            goto_issue = { lhs = "<space>Ggi", desc = "navigate to a local repo issue" },
            add_comment = { lhs = "<space>Gca", desc = "add comment" },
            delete_comment = { lhs = "<space>Gcd", desc = "delete comment" },
            react_hooray = { lhs = "<space>Grp", desc = "add/remove 🎉 reaction" },
            react_heart = { lhs = "<space>Grh", desc = "add/remove ❤️ reaction" },
            react_eyes = { lhs = "<space>Gre", desc = "add/remove 👀 reaction" },
            react_thumbs_up = { lhs = "<space>Gr+", desc = "add/remove 👍 reaction" },
            react_thumbs_down = { lhs = "<space>Gr-", desc = "add/remove 👎 reaction" },
            react_rocket = { lhs = "<space>Grr", desc = "add/remove 🚀 reaction" },
            react_laugh = { lhs = "<space>Grl", desc = "add/remove 😄 reaction" },
            react_confused = { lhs = "<space>Grc", desc = "add/remove 😕 reaction" },
          },
          pull_request = {
            checkout_pr = { lhs = "<space>Gpo", desc = "checkout PR" },
            merge_pr = { lhs = "<space>Gpm", desc = "merge commit PR" },
            squash_and_merge_pr = { lhs = "<space>Gpsm", desc = "squash and merge PR" },
            list_commits = { lhs = "<space>Gpc", desc = "list PR commits" },
            list_changed_files = { lhs = "<space>Gpf", desc = "list PR changed files" },
            show_pr_diff = { lhs = "<space>Gpd", desc = "show PR diff" },
            add_reviewer = { lhs = "<space>Gva", desc = "add reviewer" },
            remove_reviewer = { lhs = "<space>Gvd", desc = "remove reviewer request" },
            close_issue = { lhs = "<space>Gic", desc = "close PR" },
            reopen_issue = { lhs = "<space>Gio", desc = "reopen PR" },
            list_issues = { lhs = "<space>Gil", desc = "list open issues on same repo" },
            copy_url = { lhs = "<space>Gpu", desc = "copy url to system clipboard" },
            add_assignee = { lhs = "<space>Gaa", desc = "add assignee" },
            remove_assignee = { lhs = "<space>Gad", desc = "remove assignee" },
            create_label = { lhs = "<space>Glc", desc = "create label" },
            add_label = { lhs = "<space>Gla", desc = "add label" },
            remove_label = { lhs = "<space>Gld", desc = "remove label" },
            goto_issue = { lhs = "<space>Ggi", desc = "navigate to a local repo issue" },
            add_comment = { lhs = "<space>Gca", desc = "add comment" },
            delete_comment = { lhs = "<space>Gcd", desc = "delete comment" },
            react_hooray = { lhs = "<space>Grp", desc = "add/remove 🎉 reaction" },
            react_heart = { lhs = "<space>Grh", desc = "add/remove ❤️ reaction" },
            react_eyes = { lhs = "<space>Gre", desc = "add/remove 👀 reaction" },
            react_thumbs_up = { lhs = "<space>Gr+", desc = "add/remove 👍 reaction" },
            react_thumbs_down = { lhs = "<space>Gr-", desc = "add/remove 👎 reaction" },
            react_rocket = { lhs = "<space>Grr", desc = "add/remove 🚀 reaction" },
            react_laugh = { lhs = "<space>Grl", desc = "add/remove 😄 reaction" },
            react_confused = { lhs = "<space>Grc", desc = "add/remove 😕 reaction" },
          },
          review_thread = {
            goto_issue = { lhs = "<space>Ggi", desc = "navigate to a local repo issue" },
            add_comment = { lhs = "<space>Gca", desc = "add comment" },
            add_suggestion = { lhs = "<space>Gsa", desc = "add suggestion" },
            delete_comment = { lhs = "<space>Gcd", desc = "delete comment" },
            react_hooray = { lhs = "<space>Grp", desc = "add/remove 🎉 reaction" },
            react_heart = { lhs = "<space>Grh", desc = "add/remove ❤️ reaction" },
            react_eyes = { lhs = "<space>Gre", desc = "add/remove 👀 reaction" },
            react_thumbs_up = { lhs = "<space>Gr+", desc = "add/remove 👍 reaction" },
            react_thumbs_down = { lhs = "<space>Gr-", desc = "add/remove 👎 reaction" },
            react_rocket = { lhs = "<space>Grr", desc = "add/remove 🚀 reaction" },
            react_laugh = { lhs = "<space>Grl", desc = "add/remove 😄 reaction" },
            react_confused = { lhs = "<space>Grc", desc = "add/remove 😕 reaction" },
          },
          review_diff = {
            add_review_comment = { lhs = "<space>Gca", desc = "add a new review comment" },
            add_review_suggestion = { lhs = "<space>Gsa", desc = "add a new review suggestion" },
            goto_file = { lhs = "gf", desc = "go to file" },
          },
        }
      })
    end,
    cmd = "Octo"
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = function()
      require("git-conflict").setup {
        default_mappings = {
          ours = 'co',
          theirs = 'ct',
          none = 'c0',
          both = 'ca',
          next = 'cn',
          prev = 'cN',
        },
        default_commands = true,
        disable_diagnostics = false,
      }
    end,
    event = "User AstroFile",
  },
  {
    "sindrets/diffview.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
    },
    event = "User AstroGitFile",
    opts = function()
      local actions = require "diffview.actions"
      local utils = require "astronvim.utils" --  astronvim utils

      local prefix = "<leader>D"

      utils.set_mappings {
        n = {
          [prefix] = { name = " Diff View" },
          [prefix .. "<cr>"] = { "<cmd>DiffviewOpen<cr>", desc = "Open DiffView" },
          [prefix .. "h"] = { "<cmd>DiffviewFileHistory %<cr>", desc = "Open DiffView File History" },
          [prefix .. "H"] = { "<cmd>DiffviewFileHistory<cr>", desc = "Open DiffView Branch History" },
        },
      }

      local build_keymaps = function(maps)
        local out = {}
        local i = 1
        for lhs, def in
          pairs(utils.extend_tbl(maps, {
            [prefix .. "q"] = { "<cmd>DiffviewClose<cr>", desc = "Quit Diffview" }, -- Toggle the file panel.
            ["]D"] = { actions.select_next_entry, desc = "Next Difference" }, -- Open the diff for the next file
            ["[D"] = { actions.select_prev_entry, desc = "Previous Difference" }, -- Open the diff for the previous file
            ["[C"] = { actions.prev_conflict, desc = "Next Conflict" }, -- In the merge_tool: jump to the previous conflict
            ["]C"] = { actions.next_conflict, desc = "Previous Conflict" }, -- In the merge_tool: jump to the next conflict
            ["Cl"] = { actions.cycle_layout, desc = "Cycle Diff Layout" }, -- Cycle through available layouts.
            ["Ct"] = { actions.listing_style, desc = "Cycle Tree Style" }, -- Cycle through available layouts.
            ["<leader>e"] = { actions.toggle_files, desc = "Toggle Explorer" }, -- Toggle the file panel.
            ["<leader>o"] = { actions.focus_files, desc = "Focus Explorer" }, -- Bring focus to the file panel
          }))
        do
          local opts
          local rhs = def
          local mode = { "n" }
          if type(def) == "table" then
            if def.mode then mode = def.mode end
            rhs = def[1]
            def[1] = nil
            def.mode = nil
            opts = def
          end
          out[i] = { mode, lhs, rhs, opts }
          i = i + 1
        end
        return out
      end

      return {
        enhanced_diff_hl = true,
        view = {
          merge_tool = { layout = "diff3_mixed" },
        },
        keymaps = {
          disable_defaults = true,
          view = build_keymaps {
            [prefix .. "o"] = { actions.conflict_choose "ours", desc = "Take Ours" }, -- Choose the OURS version of a conflict
            [prefix .. "t"] = { actions.conflict_choose "theirs", desc = "Take Theirs" }, -- Choose the THEIRS version of a conflict
            [prefix .. "b"] = { actions.conflict_choose "base", desc = "Take Base" }, -- Choose the BASE version of a conflict
            [prefix .. "a"] = { actions.conflict_choose "all", desc = "Take All" }, -- Choose all the versions of a conflict
            [prefix .. "0"] = { actions.conflict_choose "none", desc = "Take None" }, -- Delete the conflict region
          },
          diff3 = build_keymaps {
            [prefix .. "O"] = { actions.diffget "ours", mode = { "n", "x" }, desc = "Get Our Diff" }, -- Obtain the diff hunk from the OURS version of the file
            [prefix .. "T"] = { actions.diffget "theirs", mode = { "n", "x" }, desc = "Get Their Diff" }, -- Obtain the diff hunk from the THEIRS version of the file
          },
          diff4 = build_keymaps {
            [prefix .. "B"] = { actions.diffget "base", mode = { "n", "x" }, desc = "Get Base Diff" }, -- Obtain the diff hunk from the OURS version of the file
            [prefix .. "O"] = { actions.diffget "ours", mode = { "n", "x" }, desc = "Get Our Diff" }, -- Obtain the diff hunk from the OURS version of the file
            [prefix .. "T"] = { actions.diffget "theirs", mode = { "n", "x" }, desc = "Get Their Diff" }, -- Obtain the diff hunk from the THEIRS version of the file
          },
          file_panel = build_keymaps {
            j = actions.next_entry, -- Bring the cursor to the next file entry
            k = actions.prev_entry, -- Bring the cursor to the previous file entry.
            o = actions.select_entry,
            S = actions.stage_all, -- Stage all entries.
            U = actions.unstage_all, -- Unstage all entries.
            X = actions.restore_entry, -- Restore entry to the state on the left side.
            L = actions.open_commit_log, -- Open the commit log panel.
            Cf = { actions.toggle_flatten_dirs, desc = "Flatten" }, -- Flatten empty subdirectories in tree listing style.
            R = actions.refresh_files, -- Update stats and entries in the file list.
            ["-"] = actions.toggle_stage_entry, -- Stage / unstage the selected entry.
            ["<down>"] = actions.next_entry,
            ["<up>"] = actions.prev_entry,
            ["<cr>"] = actions.select_entry, -- Open the diff for the selected entry.
            ["<2-LeftMouse>"] = actions.select_entry,
            ["<c-b>"] = actions.scroll_view(-0.25), -- Scroll the view up
            ["<c-f>"] = actions.scroll_view(0.25), -- Scroll the view down
            ["<tab>"] = actions.select_next_entry,
            ["<s-tab>"] = actions.select_prev_entry,
          },
          file_history_panel = build_keymaps {
            j = actions.next_entry,
            k = actions.prev_entry,
            o = actions.select_entry,
            y = actions.copy_hash, -- Copy the commit hash of the entry under the cursor
            L = actions.open_commit_log,
            zR = { actions.open_all_folds, desc = "Open all folds" },
            zM = { actions.close_all_folds, desc = "Close all folds" },
            ["?"] = { actions.options, desc = "Options" }, -- Open the option panel
            ["<down>"] = actions.next_entry,
            ["<up>"] = actions.prev_entry,
            ["<cr>"] = actions.select_entry,
            ["<2-LeftMouse>"] = actions.select_entry,
            ["<C-A-d>"] = actions.open_in_diffview, -- Open the entry under the cursor in a diffview
            ["<c-b>"] = actions.scroll_view(-0.25),
            ["<c-f>"] = actions.scroll_view(0.25),
            ["<tab>"] = actions.select_next_entry,
            ["<s-tab>"] = actions.select_prev_entry,
          },
          option_panel = {
            q = actions.close,
            o = actions.select_entry,
            ["<cr>"] = actions.select_entry,
            ["<2-LeftMouse"] = actions.select_entry,
          },
        },
      }
    end,
  }
}
