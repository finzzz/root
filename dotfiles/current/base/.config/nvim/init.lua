-- Options
-- `:help vim.g`
vim.g.mapleader        = ' ' -- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)

vim.opt.breakindent    = true          -- wrap indent to match line start
vim.opt.clipboard      = "unnamedplus" -- connection to the system clipboard
vim.opt.cmdheight      = 0             -- hide command bar
vim.opt.cursorline     = true          -- highlight the text line of the cursor
vim.opt.expandtab      = true          -- enable the use of space in tab
vim.opt.ignorecase     = true          -- case insensitive searching
vim.opt.list           = true          -- show whitespace chars
vim.opt.mouse          = "a"           -- mouse support
vim.opt.number         = true          -- show numberline
vim.opt.relativenumber = true          -- show relative numberline
vim.opt.shiftwidth     = 2             -- number of space inserted for indentation
vim.opt.showbreak      = "↪"           -- show break sign when wrapping long line
vim.opt.spell          = false         -- spell checking
vim.opt.tabstop        = 2             -- number of space in a tab
vim.opt.wrap           = true          -- wrapping of lines longer than the width of window
vim.opt.listchars      = {             -- whitespace chars
   eol        = "$",
   extends    = "»",
   nbsp       = "␣",
   precedes   = "«",
   tab        = "│→",
   trail      = "·",
}

vim.cmd("set splitbelow") -- default split window below
vim.cmd("set splitright") -- default split window right
-- vim.cmd("set shm=a")

-- Package manager
-- https://github.com/folke/lazy.nvim
-- `:help lazy.nvim.txt`
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Plugins here
local lazyconfig = {
  defaults = { lazy = true }
}

require('lazy').setup(
  {
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
      config = function()
        require("tokyonight").setup({
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
          on_highlights = function(hl, c)
            hl.WinSeparator = {
              fg = c.dark3,
            }
          end
        })
        vim.cmd("colo tokyonight")
      end
    },
    {
      "godlygeek/tabular",
      cmd = "Tab",
      keys = {
        { "<leader>:", ":'<,'>Tab/:<cr>", mode = "x" },
        { "<leader>=", ":'<,'>Tab/=<cr>", mode = "x" },
        { "<leader>|", ":'<,'>Tab/|<cr>", mode = "x" },
      }
    },
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
    },
    {
      'windwp/nvim-autopairs',
      event = "InsertEnter",
      opts = {
        check_ts = true,
        ts_config = { java = false },
        fast_wrap = {
          map = "<M-e>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
          offset = 0,
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "PmenuSel",
          highlight_grey = "LineNr",
        },
      }
    },
    {
      "luukvbaal/statuscol.nvim",
      config = function()
        local builtin = require("statuscol.builtin")
        require("statuscol").setup({
          relculright = true,
          segments = {
            { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
            { text = { " %s" }, click = "v:lua.ScSa" },
            { text = { builtin.lnumfunc, " " }},
          },
        })
      end,
      lazy = false
    },
    {
      "kevinhwang91/nvim-ufo",
      event = "BufEnter",
      dependencies = { 
        "kevinhwang91/promise-async",
      },
      config = function()
        vim.o.foldcolumn = "1" -- show sidebar fold status
        vim.o.foldenable = true -- enable folding
        vim.o.foldlevel = 99 -- ufo needs a large value
        vim.o.foldlevelstart = 99
        vim.o.fillchars = [[eob: ,fold: ,foldsep: ,foldopen:▼,foldclose:▶]]
        require("ufo").setup()
        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "neo-tree" },
          callback = function()
            -- window scoped option to disable fold in special buffer
            vim.wo.foldcolumn = "0"
          end
        })
      end
    },
    {
      'numToStr/Comment.nvim',
      opts = {
        mappings = {
          basic = false,
          extra = false
        }
      },
      keys = {
        { "<leader>/", "<Plug>(comment_toggle_linewise_current)", desc = "Comment lines", mode = "n" },
        { "<leader>/", "<Plug>(comment_toggle_linewise_visual)", desc = "Comment lines", mode = "x" },
      },
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      lazy = false,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
      opts = {
        auto_clean_after_session_restore = true,
        close_if_last_window = true,
        sources = { "filesystem", "git_status", "document_symbols" },
        source_selector = {
          winbar = true,
          content_layout = "center",
        },
        default_component_configs = {
          git_status = {
            symbols = {
              modified  = ""
            }
          }
        },
        filesystem = {
          filtered_items = {
            visible = true,
          },
          window = {
            mappings = {
              ["c"] = {
                "copy",
                config = {
                  show_path = "absolute"
                }
              }
            }
          }
        },
      },
      keys = {
        { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle neotree", mode = "n" },
        { "<leader>s", "<cmd>Neotree toggle document_symbols<cr>", desc = "Neotree symbols", mode = "n" },
      },
    },
    {
      "lewis6991/gitsigns.nvim",
      enabled = vim.fn.executable "git" == 1,
      event = "VeryLazy",
      opts = {
        linehl                  = false,
        numhl                   = true,
        signcolumn              = true,
        current_line_blame      = true,
        current_line_blame_opts = { ignore_whitespace = true },
        current_line_blame_formatter = ' <abbrev_sha> <author> <author_time:%Y-%b-%d-%H:%M><author_tz> - <summary>'
      },
      keys = {
        { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Git preview hunk", mode = { "n", "x" } },
        { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Git reset hunk", mode = { "n", "x" } },
        { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Git stage hunk", mode = { "n", "x" } },
        { "<leader>gS", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Git undo stage hunk", mode = { "n", "x" } }
      }
    },
    {
      {
        'smoka7/hop.nvim',
        config = function()
          require'hop'.setup { keys = 'plmoknijb8uhv7ygc6tfx5rdz4es3wa2q' }
        end,
        keys = {
          { "<leader>hl", "<cmd>HopLineStart<cr>", desc = "Hop line start", mode = "n" },
          { "<leader>hp", "<cmd>HopPatternAC<cr>", desc = "Hop pattern after cursor", mode = "n" },
          { "<leader>hP", "<cmd>HopPatternBC<cr>", desc = "Hop pattern before cursor", mode = "n" },
          { "<leader>hs", "v<cmd>HopPatternAC<cr>", desc = "Select with hop pattern after cursor", mode = "n" },
          { "<leader>hS", "v<cmd>HopPatternBC<cr>", desc = "Select with hop pattern before cursor", mode = "n" },
        }
      }
    },
    {
      'romgrk/barbar.nvim',
      init = function() vim.g.barbar_auto_setup = false end,
      opts = {
        clickable = true,
        no_name_title = "untitled",
        icons = {
          pinned = { filename = true }
        }
      },
      lazy = false,
      keys = {
        { "<leader>bc", "<cmd>BufferClose<cr>", desc = "Close current buffer", mode = "n" },
        { "<leader>bC", "<cmd>BufferCloseAllButCurrentOrPinned<cr>", desc = "Close all buffers except", mode = "n" },
        { "<leader>bp", "<cmd>BufferPin<cr>", desc = "Pin/unpin current buffer", mode = "n" },
        { "<leader>bj", "<cmd>BufferPick<cr>", desc = "Jump to buffer", mode = "n" },
      }
    },
    {
      "williamboman/mason.nvim", -- Package manager
      event = "VeryLazy",
      dependencies = {
        -- LSP related
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
        -- Autocompletion
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        -- Snippets
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
      },
      config = function()
        local cmp = require('cmp')

        cmp.setup({
          snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
          window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
          }, {
            { name = 'buffer' },
          })
        })

        cmp.setup.filetype('gitcommit', {
          sources = cmp.config.sources({
            { name = 'git' },
          }, {
            { name = 'buffer' },
          })
        })

        -- Use buffer source for `/` and `?`
        cmp.setup.cmdline({ '/', '?' }, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = 'buffer' }
          }
        })

        -- Use cmdline & path source for ':'
        cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = 'path' }
          }, {
            { name = 'cmdline' }
          })
        })

        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        local handlers = {
          function(server)
            require('lspconfig')[server].setup{ capabilities = capabilities }
          end
        }

        require("mason").setup()
        require("mason-lspconfig").setup({
          handlers = handlers
        })

        require("luasnip.loaders.from_vscode").lazy_load()
      end,
      keys = {
        { "<leader>lm", "<cmd>Mason<cr>", desc = "Mason package manager", mode = "n" },
        { "<leader>fd", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols", mode = "n" },
        { "<leader>fD", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace document symbols", mode = "n" },
      }
    },
    {
      "dense-analysis/ale", -- linter
      event = "VeryLazy"
    },
    {
      'nvim-treesitter/nvim-treesitter', -- syntax highlighter
      event = "VeryLazy",
      config = function()
        require'nvim-treesitter.configs'.setup {
          highlight = {
            enable = true
          },
          indent = {
            enable = true
          }
        }
      end,
      keys = {
        { "<leader>li", "<cmd>TSInstallInfo<cr>", desc = "Treesitter info", mode = "n" },
        { "<leader>lu", "<cmd>TSUpdate<cr>", desc = "Treesitter update", mode = "n" },
        { "<leader>ls", "<cmd>TSInstallSync<cr>", desc = "Treesitter sync", mode = "n" },
      }
    },
    {
      'nvim-lualine/lualine.nvim',
      lazy = false,
      config = function()
        local function session_name()
          session = require('possession.session').session_name or 'Untitled'
          return "󱂬  "..session
        end
        require('lualine').setup({
          options = {
            globalstatus = true,
            component_separators = { left = ' ', right = ' '},
            section_separators = { left = ' ', right = ' '},
          },
          sections = {
            lualine_a = {'mode'},
            lualine_b = { session_name, 'branch'},
            lualine_c = {
              'diff',
              'diagnostics',
              {
                'filename',
                path = 3,
                file_status = true, -- Displays file status (readonly status, modified status)
                symbols = {
                  modified = '[M]',
                  readonly = '[RO]',
                }
              }
            },
            lualine_x = {
              'encoding',
              {
                'filetype',
                colored = true
              },
              'filesize'
            },
            lualine_y = {'progress'},
            lualine_z = {}
          },
        })
      end
    },
    {
      'nvim-telescope/telescope.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' },
      keys = {
        { "<leader>f/", function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "Words in current buffer", mode = "n" },
        { "<leader>f<cr>", function() require("telescope.builtin").resume() end, desc = "Resume previous search", mode = "n" },
        { "<leader>fF", function() require("telescope.builtin").find_files{ hidden = true, no_ignore = true } end , desc = "All files", mode = "n" },
        { "<leader>fc", function() require("telescope.builtin").commands() end, desc = "Commands", mode = "n" },
        { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Files", mode = "n" },
        { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help" },
        { "<leader>fk", function() require("telescope.builtin").keymaps() end, desc = "Keymaps", mode = "n" },
        { "<leader>fm", function() require("telescope.builtin").man_pages() end, desc = "Manpage" },
        { "<leader>fr", function() require("telescope.builtin").oldfiles() end, desc = "Recent files", mode = "n" },
        { "<leader>fR", function() require("telescope.builtin").registers() end, desc = "Registers", mode = "n" },
        { "<leader>fw", function() require("telescope.builtin").live_grep() end, desc = "Words", mode = "n" },
        { "<leader>fW",
          function()
            require("telescope.builtin").live_grep {
              additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
            }
          end,
          desc = "Words in all files",
          mode = "n"
        },
      }
    },
    {
      'norcalli/nvim-colorizer.lua',
      event = "VeryLazy",
      config = function()
        require 'colorizer'.setup()
      end
    },
    {
      "akinsho/toggleterm.nvim",
      cmd = "ToggleTerm",
      config = function()
        require("toggleterm").setup()
      end,
      keys = {
        { "<leader>tf", "<cmd>ToggleTerm direction=float dir=%:h:p<cr>", desc = "ToggleTerm float", mode = "n" },
        { "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal dir=%:h:p<cr>", desc = "ToggleTerm horizontal split", mode = "n" },
        { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical dir=%:h:p<cr>", desc = "ToggleTerm vertical split", mode = "n" },
      }
    },
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
      cmd = "Oil",
      keys = {
        { "<leader>E", "<cmd>Oil<cr>", desc = "Oil FM", mode = "n" },
      }
    },
    {
      "kylechui/nvim-surround",
      event = "VeryLazy",
      config = function()
        vim.keymap.set('n', 's', '<nop>')
        require("nvim-surround").setup({
          keymaps = {
            insert = false,
            insert_line = false,
            normal = false,
            normal_cur = false,
            normal_line = false,
            normal_cur_line = false,
            visual = false,
            visual_line = false,
            delete = "sd",
            change = "sc",
          },
        })
        vim.api.nvim_set_keymap('n', 'sa', '<Plug>(nvim-surround-normal)iw', { desc = "Surround add" })
        vim.api.nvim_set_keymap('x', 'sa', '<Plug>(nvim-surround-visual)', { desc = "Surround add" })
      end,
    },
    {
      'Wansmer/treesj',
      dependencies = { 'nvim-treesitter/nvim-treesitter' },
      config = function()
        require('treesj').setup({
          use_default_keymaps = false
        })
      end,
      cmd = "TSJToggle",
      keys = {
        { "<leader>[", "<cmd>TSJToggle<cr>", desc = "TreeSJToggle", mode = { "n", "x" } }
      },
    },
    {
      "karb94/neoscroll.nvim",
      event = "VeryLazy",
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
        t['<C-u>'] = {'scroll', { '-vim.wo.scroll', 'true', '100' }}
        t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '100'}}
        t['<PageUp>'] = {'scroll', {'-vim.wo.scroll', 'true', '100'}}
        t['<PageDown>'] = {'scroll', {'vim.wo.scroll', 'true', '100'}}
        require('neoscroll.config').set_mappings(t)
      end,
    },
    {
      "hashivim/vim-terraform",
      ft = "terraform",
      config = function()
        vim.g.terraform_align       = 1
        vim.g.terraform_fmt_on_save = 1
      end
    },
    {
      "lukas-reineke/indent-blankline.nvim",
      event = "VeryLazy",
      config = function()
        require("ibl").setup()
      end,
    },
    {
      "folke/trouble.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("trouble").setup()
      end,
      keys = {
        { "<leader>Tw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace diagnostics", mode = "n" },
        { "<leader>Tl", "<cmd>TroubleToggle loclist<cr>", desc = "Location list", mode = "n" },
        { "<leader>Td", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document diagnostics", mode = "n" },
      }
    },
    {
      'nyngwang/NeoZoom.lua',
      config = function()
        require('neo-zoom').setup{
          winopts = {
            offset = {
              width = 0.85,
              height = 0.85,
            },
            border = 'thicc',
          },
        }
      end,
      keys = {
        { "<leader>z", "<cmd>NeoZoomToggle<cr>", desc = "Toggle zoom", mode = "n" },
      }
    },
    {
      "folke/todo-comments.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      event = "VeryLazy",
      config = function()
        require("todo-comments").setup{
          keywords = {
            FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
            TODO = { icon = " ", color = "info" },
            WARN = { icon = " ", color = "warning", alt = { "WARNING" } },
            NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
            TEST = { icon = "󰙨 ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
          },
        }
        vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next todo comment" })
        vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous todo comment" })
        require('telescope').load_extension('todo-comments')
      end,
      keys = {
        { "<leader>ft", ":TodoTelescope<cr>", desc = "Find todo comment", mode = "n" },
        { "<leader>Tc", ":TodoLocList<cr>", desc = "todo comment", mode = "n" },
      }
    },
    {
      'mzlogin/vim-markdown-toc',
      ft = "markdown",
      config = function()
        vim.g.vmt_list_item_char = "-"
      end,
      keys = {
        { "<leader>Ma", "<cmd>GenTocGFM<cr>", desc = "Add TOC", mode = "n" },
        { "<leader>Mu", "<cmd>UpdateToc<cr>", desc = "Update TOC", mode = "n" },
      }
    },
    {
      'jedrzejboczar/possession.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        require('possession').setup {}
        require('telescope').load_extension('possession')
      end,
      keys = {
        { "<leader>Sc", "<cmd>PossessionClose<cr>", desc = "Close this session" },
        { "<leader>Sd", "<cmd>PossessionDelete<cr>", desc = "Delete this session" },
        { "<leader>fs", "<cmd>Telescope possession list<cr>", desc = "Find session" },
        { "<leader>Sr", "<cmd>PossessionRename<cr>", desc = "Rename this session" },
        { "<leader>Ss", ":PossessionSave untitled", desc = "Save this session" },
      }
    },
    {
      "sindrets/diffview.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        local actions = require("diffview.actions")
        require('diffview').setup {
          keymaps = {
            disable_defaults = true,
            view = {
              { "n", "<leader>c",   "<cmd>DiffviewRefresh<cr>",             { desc = "Conflict" } },
              { "n", "<leader>co",  actions.conflict_choose("ours"),        { desc = "Choose OURS" } },
              { "n", "<leader>ct",  actions.conflict_choose("theirs"),      { desc = "Choose THEIRS" } },
              { "n", "<leader>cb",  actions.conflict_choose("base"),        { desc = "Choose BASE" } },
              { "n", "<leader>ca",  actions.conflict_choose("all"),         { desc = "Choose ALL" } },
              { "n", "<leader>cO",  actions.conflict_choose_all("ours"),    { desc = "Choose OURS for all" } },
              { "n", "<leader>cT",  actions.conflict_choose_all("theirs"),  { desc = "Choose THEIRS for all" } },
              { "n", "<leader>cB",  actions.conflict_choose_all("base"),    { desc = "Choose BASE for all" } },
              { "n", "<leader>cA",  actions.conflict_choose_all("all"),     { desc = "Choose ALL for all" } },
              { "n", "<leader>cx",  actions.conflict_choose("none"),        { desc = "Delete conflict" } },
              { "n", "<leader>cX",  actions.conflict_choose_all("none"),    { desc = "Delete conflict for all" } },
              { "n", "<leader>Dr",  "<cmd>DiffviewRefresh<cr>",             { desc = "Refresh DiffView" } },
            }
          }
        }
      end,
      keys = {
        { "<leader>D<cr>", "<cmd> DiffviewOpen<cr>",          desc = "Open DiffView" },
        { "<leader>DH",    "<cmd> DiffviewFileHistory<cr>",   desc = "Open DiffView Branch History" },
        { "<leader>Dc",    "<cmd> DiffviewClose<cr>",         desc = "Close DiffView" },
        { "<leader>Dh",    "<cmd> DiffviewFileHistory %<cr>", desc = "Open DiffView File History" },
      }
    },
    {
      "goolord/alpha-nvim",
      lazy = false,
      config = function()
        require'alpha'.setup(require'alpha.themes.startify'.config)
        require'alpha'.setup(require'alpha.themes.dashboard'.config)
      end,
      opts = function()
        local dashboard = require("alpha.themes.dashboard")
        dashboard.section.header.val = {}
        dashboard.section.buttons.val = {
          dashboard.button("S", "⌕ Find Session", "<cmd>Telescope possession list<cr>"),
          dashboard.button("f", "⌕ Find Files", "<cmd>Telescope find_files<cr>"),
          dashboard.button("t", " Find Text", "<cmd>Telescope live_grep<cr>"),
          dashboard.button("r", "⧖ Recent Files", "<cmd>Telescope oldfiles<cr>"),
          dashboard.button("z", "󰏖 Lazy", "<cmd>Lazy<cr>"),
          dashboard.button("q", " Quit", "<cmd>qa<cr>"),
        }
        return dashboard
      end,
    },
  },
  lazyconfig
)
vim.keymap.set('n', '<leader>L', '<cmd>Lazy<cr>', { desc = "Lazy" })

-- WhichKey keymapping
require("which-key").register(
  {
    ["<leader>"] = {
      -- example: https://github.com/folke/which-key.nvim#%EF%B8%8F-mappings
      b = { name = "Buffer" },
      D = { name = "Diffview" },
      f = { name = "Telescope" },
      g = { name = "Git" },
      h = { name = "Hop" },
      l = { name = "Language" },
      M = { name = "Markdown" },
      S = { name = "Session" },
      t = {
        name = "Terminal",
        ["<bslash>"] = { "<cmd> silent !tmux split-window -v -c %:p:h<cr>", "Tmux vertical split" },
        ["|"] = { "<cmd> silent !tmux split-window -h -c %:p:h<cr>", "Tmux horizontal split" },
        w = { "<cmd> silent !tmux new-window -c %:p:h<cr>", "Tmux new window" },
      },
      T = { name = "Trouble" },
    }
  }
)

-- Non plugin keymapping
vim.keymap.set('n', '<Tab>', '<cmd>BufferNext<cr>')
vim.keymap.set('n', '<C-c>', 'i')

-- https://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
vim.keymap.set('n', 'cn', '*``cgn')
vim.g.mc = vim.api.nvim_replace_termcodes([[y/\V<C-r>= escape(@", '/')<CR><CR>]], true, true, true)
vim.api.nvim_set_keymap('x', 'cn', [[g:mc . "``cgn"]], { expr = true })

-- Autocmd

-- auto-reload files when modified externally
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

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
