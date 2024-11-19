-------------
-------------
-- Options --
-------------
-------------
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
vim.opt.undofile       = true          -- enable undo after close
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
-------------
-------------
-- Options --
-------------
-------------

-------------------------
-------------------------
-- Bootstrap lazy.nvim --
-------------------------
-------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
-------------------------
-------------------------
-- Bootstrap lazy.nvim --
-------------------------
-------------------------

-------------
-------------
-- Plugins --
-------------
-------------
local lazyconfig = {
  defaults = { lazy = true }
}

require('lazy').setup(
  {
    --------------
    --------------
    -- AI SETUP --
    --------------
    --------------
    {
      'Exafunction/codeium.vim',
      commit = "9406f13cf3eaa08318b76746bd105a04506cab27",
      cmd = { "Codeium", "CodeiumToggle" },
      config = function()
        vim.g.codeium_enabled = false
        vim.g.codeium_disable_bindings = 1
        vim.keymap.set('i', '<c-d>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
        vim.keymap.set('i', '<c-]>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
        vim.keymap.set('i', '<c-[>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
        vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
      end
    },
    {
      "jackMort/ChatGPT.nvim",
      commit = "df53728e05129278d6ea26271ec086aa013bed90",
      event = "VeryLazy",
      config = function()
        require("chatgpt").setup({
          api_key_cmd = "printenv OPENAI_API_KEY",
          popup_input = {
            submit = "<CR>"
          },
          edit_with_instructions = {
            keymaps = {
              use_output_as_input = "<C-n>"
            }
          },
          openai_params = { 
          model = "gpt-4o-mini", 
          frequency_penalty = 0, 
          presence_penalty = 0, 
          max_tokens = 300, 
          temperature = 0, 
          top_p = 1, 
          n = 1, 
        }, 
        openai_edit_params = { 
          model = "gpt-3.5-turbo", 
          frequency_penalty = 0, 
          presence_penalty = 0, 
          temperature = 0, 
          top_p = 1, 
          n = 1, 
        },
      })
      end,
      dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "folke/trouble.nvim",
        "nvim-telescope/telescope.nvim"
      }
    },
    --------------
    --------------
    -- AI SETUP --
    --------------
    --------------
    ------------------
    ------------------
    -- FILE MANAGER --
    ------------------
    ------------------
    {
      "nvim-neo-tree/neo-tree.nvim",
      commit = "00b46a1ee17ec2bb93b52e1aac7d1449b659f53f",
      lazy = false,
      dependencies = {
        { "nvim-lua/plenary.nvim", tag = "v0.1.4" },
        { "nvim-tree/nvim-web-devicons", commit = "3af745113ea537f58c4b1573b64a429fefad9e07" },
        { "MunifTanjim/nui.nvim", tag = "0.2.0" },
      },
      opts = {
        auto_clean_after_session_restore = true,
        close_if_last_window = true,
        sources = { "filesystem", "document_symbols" },
        source_selector = {
          winbar = true,
          content_layout = "center",
          sources = {
            { source = "filesystem", display_name = "Files" },
            { source = "document_symbols", display_name = "Symbols" },
          }
        },
        default_component_configs = {
          container = {
            enable_character_fade = true
          },
          git_status = {
            symbols = {
              modified  = ""
            }
          },
          file_size = {
            required_width = 200,
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
              },
              ["m"] = {
                "move",
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
      "stevearc/oil.nvim",
      tag = "v2.2.0",
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
    ------------------
    ------------------
    -- FILE MANAGER --
    ------------------
    ------------------
    --------------------
    --------------------
    -- LANGUAGE SETUP --
    --------------------
    --------------------
    -- syntax highlighter
    -- { import = "lazyvim.plugins.extras.lang.typescript" },
    {
      'nvim-treesitter/nvim-treesitter',
      commit = "18cf02f5efe677d992fe7f96f395ef40a2f329d2",
      event = "VeryLazy",
      config = function()
        require'nvim-treesitter.configs'.setup {
          highlight = { enable = true },
          indent = { enable = true },
          ensure_installed = {
            "go",
            "lua",
            "markdown",
            "python",
            "rust",
            "svelte",
            "typescript"
          },
        }
        require("nvim-treesitter.install").prefer_git = true
      end,
      keys = {
        { "<leader>li", "<cmd>TSInstallInfo<cr>", desc = "Treesitter info", mode = "n" },
        { "<leader>lu", "<cmd>TSUpdate<cr>", desc = "Treesitter update", mode = "n" },
        { "<leader>ls", "<cmd>TSInstallSync<cr>", desc = "Treesitter sync", mode = "n" },
      }
    },
    -- LSP
    {
      "williamboman/mason.nvim", -- Package manager
      commit = "e2f7f9044ec30067bc11800a9e266664b88cda22",
      event = "VeryLazy",
      dependencies = {
        { "williamboman/mason-lspconfig.nvim", commit = "25c11854aa25558ee6c03432edfa0df0217324be" },
        { "neovim/nvim-lspconfig", commit = "84f867753f659bfd9319f75bd5eb273a315f2da5" },
      },
      config = function()
        -- Custom LSP server
        local configs = require("lspconfig.configs")
        local util = require("lspconfig.util")

        -- https://templ.guide/
        configs.templ = {
          default_config = {
            cmd = { "templ", "lsp", },
            filetypes = { "templ" },
            root_dir = util.root_pattern("go.mod", ".git"),
            settings = {},
          }
        }

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true
        }

        local handlers = {
          function(server)
            -- https://github.com/neovim/nvim-lspconfig/pull/3232
            if server == "tsserver" then
              server = "ts_ls"
            end
            require('lspconfig')[server].setup{ capabilities = capabilities }
          end
        }

        require("mason").setup()
        require("mason-lspconfig").setup{
          ensure_installed = {
            "gopls",
            "lua_ls",
            "pyright",
            "rust_analyzer",
            "svelte",
            "terraformls",
            "tsserver"
          },
          handlers = handlers,
        }

        vim.api.nvim_exec_autocmds("FileType", {}) -- https://www.reddit.com/r/neovim/comments/14cikep/on_nightly_my_lsp_is_not_starting_automatically/
      end,
      keys = {
        { "<leader>lm", "<cmd>Mason<cr>", desc = "Mason package manager", mode = "n" },
        { "<leader>fd", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols", mode = "n" },
        { "<leader>fD", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace document symbols", mode = "n" },
      }
    },
    -- Autocompletion
    {
      "hrsh7th/nvim-cmp",
      commit = "cd2cf0c124d3de577fb5449746568ee8e601afc8",
      event = "VeryLazy",
      dependencies = {
        -- Autocompletion
        { "hrsh7th/cmp-buffer", commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa" },
        { "hrsh7th/cmp-cmdline", commit = "8ee981b4a91f536f52add291594e89fb6645e451" },
        { "hrsh7th/cmp-nvim-lsp", commit = "44b16d11215dce86f253ce0c30949813c0a90765" },
        { "hrsh7th/cmp-path", commit = "91ff86cd9c29299a64f968ebb45846c485725f23" },
        -- Snippets
        { "L3MON4D3/LuaSnip", tag = "v2.0.0" },
        { "saadparwaiz1/cmp_luasnip", commit = "05a9ab28b53f71d1aece421ef32fee2cb857a843" },
        { "rafamadriz/friendly-snippets", commit = "43727c2ff84240e55d4069ec3e6158d74cb534b6" },
      },
      config = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')
        require("luasnip.loaders.from_vscode").lazy_load()

        local tab_next_insert_mapping = function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end

        local tab_prev_insert_mapping = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end

        local safe_enter = function(fallback)
          if cmp.visible() and cmp.get_active_entry() then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
          else
            fallback()
          end
        end

        cmp.setup({
          preselect = cmp.PreselectMode.None,
          snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
          window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },
          mapping = {
            ['<C-e>'] = cmp.mapping.abort(),
            ['<Tab>'] = cmp.mapping(tab_next_insert_mapping),
            ["<C-d>"] = cmp.mapping(tab_prev_insert_mapping),
            ['<CR>'] = cmp.mapping({
              -- when in insert mode
              i = safe_enter,
              -- when searching
              s = cmp.mapping.confirm({ select = true }),
              -- when typing comman
              c = safe_enter,
            }),
          },
          sources = cmp.config.sources{
            { name = 'buffer' },
            { name = 'luasnip' },
            { name = 'nvim_lsp' },
            { name = 'path' }
          }
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
      end,
    },
    -- {
    --   'anasinnyk/nvim-k8s-crd',
    --   event = { 'BufEnter *.yaml' },
    --   dependencies = { 'neovim/nvim-lspconfig' },
    --   config = function()
    --     require('k8s-crd').setup({
    --       cache_dir = ".k8s-schemas",
    --       k8s = {
    --         file_mask = "*.yaml",
    --       },
    --     })
    --   end
    -- },
    --------------------
    --------------------
    -- LANGUAGE SETUP --
    --------------------
    --------------------
    ---------------
    ---------------
    -- FORMATTER --
    ---------------
    ---------------
    {
      "mg979/vim-visual-multi",
      tag = "v0.5.8",
      lazy = false,
      config = function()
        vim.g.VM_mouse_mappings = 1
        vim.keymap.set('n', '<C-S-LeftMouse>', '<Plug>(VM-Mouse-Cursor)')
      end
    },
    {
      "godlygeek/tabular",
      tag = "1.0.0",
      cmd = "Tab",
      keys = {
        { "<leader>:", ":'<,'>Tab/:<cr>", mode = "x" },
        { "<leader>=", ":'<,'>Tab/=<cr>", mode = "x" },
        { "<leader>|", ":'<,'>Tab/|<cr>", mode = "x" },
      }
    },
    {
      'windwp/nvim-autopairs',
      commit = "f6c71641f6f183427a651c0ce4ba3fb89404fa9e",
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
      'numToStr/Comment.nvim',
      tag = "v0.8.0",
      dependencies = {
        {
          "JoosepAlviste/nvim-ts-context-commentstring",
          commit = "9c74db6",
        },
      },
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
      config = function()
        require('Comment').setup {
          pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        }
      end,
    },
    {
      "thinca/vim-qfreplace",
      cmd = "Qfreplace",
    },
    {
      'mzlogin/vim-markdown-toc',
      tag = "v1.4.0",
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
      "hashivim/vim-terraform",
      commit = "d37ae7e7828aa167877e338dea5d4e1653ed3eb1",
      ft = "terraform",
      config = function()
        vim.g.terraform_align       = 1
        vim.g.terraform_fmt_on_save = 1
      end
    },
    {
      "kylechui/nvim-surround",
      tag = "v2.1.1",
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
      commit = "070e6761d0b11a55446d988a69908f7a0928dbab",
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
    ---------------
    ---------------
    -- FORMATTER --
    ---------------
    ---------------
    ------------------
    ------------------
    -- COLOR SCHEME --
    ------------------
    ------------------
    -- {
    --   "folke/tokyonight.nvim",
    --   tag = "v2.9.0",
    --   lazy = false,
    --   priority = 1000,
    --   config = function()
    --     require("tokyonight").setup({
    --       style = "night",
    --       transparent = false,
    --       terminal_colors = true,
    --       styles = {
    --         comments = "italic",
    --         sidebars = "dark",
    --         floats = "dark",
    --       },
    --       sidebars = { "qf", "help" },
    --       day_brightness = 0.3,
    --       hide_inactive_statusline = false,
    --       dim_inactive = false,
    --       lualine_bold = false,
    --       on_highlights = function(hl, c)
    --         hl.WinSeparator = {
    --           fg = c.dark3,
    --         }
    --       end
    --     })
    --   end
    -- },
    {
      "EdenEast/nightfox.nvim",
      tag = "v3.9.3",
      lazy = false,
      config = function()
      end
    },
    ------------------
    ------------------
    -- COLOR SCHEME --
    ------------------
    ------------------
    -----------------
    -----------------
    -- UI ENHANCER --
    -----------------
    -----------------
    {
      'norcalli/nvim-colorizer.lua',
      commit = "36c610a9717cc9ec426a07c8e6bf3b3abcb139d6",
      event = "VeryLazy",
      config = function()
        require 'colorizer'.setup()
      end
    },
    {
      "lukas-reineke/indent-blankline.nvim",
      tag = "v3.3.2",
      event = "VeryLazy",
      config = function()
        require("ibl").setup()
      end,
    },
    {
      "folke/todo-comments.nvim",
      tag = "v1.1.0",
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
          search = {
            command = "rg",
            args = {
              "--color=never",
              "--no-heading",
              "--with-filename",
              "--line-number",
              "--column",
              "--hidden",
            }
          }
        }
        vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next todo comment" })
        vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous todo comment" })
        require('telescope').load_extension('todo-comments')
      end,
      keys = {
        { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "All todo comments", mode = "n" },
        { "<leader>TC", "<cmd>TodoLocList<cr>", desc = "All todo comments", mode = "n" },
        { "<leader>Tc", "<cmd>exe ':TodoQuickFix cwd=' .. fnameescape(expand('%:p'))<cr>", desc = "Todo comments", mode = "n" },
      }
    },
    {
      'nvim-lualine/lualine.nvim',
      commit = "7533b0ead663d80452210c0c089e5105089697e5",
      lazy = false,
      config = function()
        local function session_name()
          local session = require('possession.session').get_session_name or 'Untitled'
          return "󱂬  "..session
        end

        local function show_macro_recording()
          local recording_register = vim.fn.reg_recording()
          if recording_register == "" then
            return ""
          else
            return "Recording @" .. recording_register
          end
        end

        local clients_lsp = function ()
          local bufnr = vim.api.nvim_get_current_buf()

          local clients = vim.lsp.buf_get_clients(bufnr)
          if next(clients) == nil then
            return ''
          end

          local c = {}
          for _, client in pairs(clients) do
            table.insert(c, client.name)
          end
          return '\u{f085} ' .. table.concat(c, '|')
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
              {
                "macro-recording",
                fmt = show_macro_recording,
              },
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
              'searchcount'
            },
            lualine_y = {
              clients_lsp,
              'encoding',
              {
                'filetype',
                colored = true
              },
              'filesize'
            },
            lualine_z = {'progress'},
          },
        })

        -- https://www.reddit.com/r/neovim/comments/xy0tu1/cmdheight0_recording_macros_message/
        lualine = require('lualine')
        vim.api.nvim_create_autocmd("RecordingEnter", {
          callback = function()
            lualine.refresh({
              place = { "statusline" },
            })
          end,
        })

        vim.api.nvim_create_autocmd("RecordingLeave", {
          callback = function()
            local timer = vim.loop.new_timer()
            timer:start(
              50,
              0,
              vim.schedule_wrap(function()
                lualine.refresh({
                  place = { "statusline" },
                })
              end)
            )
          end,
        })
      end
    },
    {
      "luukvbaal/statuscol.nvim",
      commit = "5998d16044159ad3779f62c45e756c555e3051f0",
      config = function()
        local builtin = require("statuscol.builtin")
        require("statuscol").setup({
          relculright = true,
          segments = {
            { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
            { text = { builtin.lnumfunc }},
            { sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = true }, click = "v:lua.ScSa" },
            { sign = { name = { "GitSign" }, colwidth = 1, wrap = true }, click = "v:lua.ScSa" }
          },
        })
      end,
      lazy = false
    },
    {
      "kevinhwang91/nvim-ufo",
      commit = "203c9f434feec57909ab4b1e028abeb3349b7847",
      event = "BufEnter",
      dependencies = { 
        { "kevinhwang91/promise-async", commit = "119e8961014c9bfaf1487bf3c2a393d254f337e2" },
        { "luukvbaal/statuscol.nvim" },
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
      "karb94/neoscroll.nvim",
      commit = "4bc0212e9f2a7bc7fe7a6bceb15b33e39f0f41fb",
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
    -----------------
    -----------------
    -- UI ENHANCER --
    -----------------
    -----------------
    -----------------
    -----------------
    -- UX ENHANCER --
    -----------------
    -----------------
    {
      'nyngwang/NeoZoom.lua',
      commit = "1289b900bd478fd135dcc0faf4a43b3cf7524097",
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
      'smoka7/hop.nvim',
      tag = "v2.3.2",
      cmd = {
        "HopLineStart",
        "HopPatternAC",
        "HopPatternBC",
      },
      config = function()
        require'hop'.setup { keys = 'plmoknijb8uhv7ygc6tfx5rdz4es3wa2q' }
      end
    },
    -----------------
    -----------------
    -- UX ENHANCER --
    -----------------
    -----------------
    -----------
    -----------
    -- UTILS --
    -----------
    -----------
    {
      'jedrzejboczar/possession.nvim',
      version = "2dbf7aee020a330827eedc15dc7a32f0a8da8eee",
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
      "goolord/alpha-nvim",
      commit = "234822140b265ec4ba3203e3e0be0e0bb826dff5",
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
    {
      'nvim-telescope/telescope.nvim',
      tag = "0.1.4",
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
      "akinsho/toggleterm.nvim",
      tag = "v2.8.0",
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
      "folke/which-key.nvim",
      tag = "v1.6.0",
      event = "VeryLazy",
    },
    {
      'romgrk/barbar.nvim',
      -- tag = "v1.7.0",
      commit = "7c28de8c22f4c00ed43a78ae16c13dd6a248fe1a",
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
      "folke/trouble.nvim",
      tag = "v2.10.0",
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
    -----------
    -----------
    -- UTILS --
    -----------
    -----------
    ---------------
    ---------------
    -- GIT UTILS --
    ---------------
    ---------------
    {
      "lewis6991/gitsigns.nvim",
      tag = "v0.6",
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
    },
    {
      "tpope/vim-fugitive",
      commit = "d4877e54cef67f5af4f950935b1ade19ed6b7370",
      lazy = false,
    },
    {
      "sindrets/diffview.nvim",
      commit = "d38c1b5266850f77f75e006bcc26213684e1e141",
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
    ---------------
    ---------------
    -- GIT UTILS --
    ---------------
    ---------------
  },
  lazyconfig
)
-------------
-------------
-- Plugins --
-------------
-------------

-----------------------
-----------------------
-- which-key mapping --
-----------------------
-----------------------
require("which-key").register(
  {
    ["<leader>"] = {
      -- example: https://github.com/folke/which-key.nvim#%EF%B8%8F-mappings
      b = { name = "Buffer" },
      D = { name = "Diffview" },
      f = { name = "Telescope" },
      h = {
        name = "Hop",
        l = { "<cmd>HopLineStart<cr>", "Hop line start" },
        p = { "<cmd>HopPatternAC<cr>", "Hop pattern after cursor" },
        P = { "<cmd>HopPatternBC<cr>", "Hop pattern before cursor" },
        s = { "v<cmd>HopPatternAC<cr>", "Select with hop pattern after cursor" },
        S = { "v<cmd>HopPatternBC<cr>", "Select with hop pattern before cursor" },
      },
      -- k = { "<cmd>K8SSchemasGenerate<cr>", "Sync K8S schema" },
      l = { name = "Language" },
      L = { "<cmd>Lazy<cr>", "Lazy" },
      M = { name = "Markdown" },
      S = { name = "Session" },
      g = {
        name = "Git",
        p = { "<cmd>Gitsigns preview_hunk<cr>", "Git preview hunk" },
        r = { "<cmd>Gitsigns reset_hunk<cr>", "Git reset hunk" },
        s = { "<cmd>Gitsigns stage_hunk<cr>", "Git stage hunk" },
        S = { "<cmd>Gitsigns undo_stage_hunk<cr>", "Git undo stage hunk" },
        mode = { "n", "x" }
      },
      G = {
        name = "ChatGPT",
        c = { "<cmd>ChatGPT<CR>", "ChatGPT" },
        a = { "<cmd>ChatGPTActAs<CR>", "ChatGPT act as" },
        e = { "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction" },
        g = { "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction" },
        t = { "<cmd>ChatGPTRun translate<CR>", "Translate" },
        k = { "<cmd>ChatGPTRun keywords<CR>", "Keywords" },
        d = { "<cmd>ChatGPTRun docstring<CR>", "Docstring" },
        t = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests" },
        o = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code" },
        s = { "<cmd>ChatGPTRun summarize<CR>", "Summarize" },
        f = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs" },
        x = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code" },
        r = { "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit" },
        l = { "<cmd>ChatGPTRun code_readability_analysis<CR>", "Code Readability Analysis" },
        mode = { "n", "x" }
      },
      t = {
        name = "Terminal",
        ["<bslash>"] = { "<cmd> silent !tmux split-window -v -c %:p:h<cr>", "Tmux vertical split" },
        ["|"] = { "<cmd> silent !tmux split-window -h -c %:p:h<cr>", "Tmux horizontal split" },
        w = { "<cmd> silent !tmux new-window -c %:p:h<cr>", "Tmux new window" },
      },
      T = { name = "Trouble" },
      C = { "<cmd> CodeiumToggle <cr>", "Toggle Codeium" },
      w = { "<cmd> silent w<cr>", "Save" },
      x = { "<cmd> silent wq<cr>", "Save & Quit" },
      q = { "<cmd> silent q<cr>", "Quit" },
    }
  }
)
-----------------------
-----------------------
-- which-key mapping --
-----------------------
-----------------------

----------------------------
----------------------------
-- non plugin key mapping --
----------------------------
----------------------------
vim.keymap.set('n', '<Tab>', '<cmd>BufferNext<cr>')
vim.keymap.set('n', '<C-c>', 'i')
vim.keymap.set('n', 'Q', '@@')
vim.keymap.set('n', 'a', 'i')
vim.keymap.set('n', 'A', 'o')
vim.keymap.set('x', 'a', 'I')
vim.keymap.set('x', '[', ':m-2<cr>gv=gv')
vim.keymap.set('x', ']', ":m'>+<cr>gv=gv")
vim.keymap.set({ 'n', 'x' }, 'i', '<up>')
vim.keymap.set({ 'n', 'x' }, 'j', '<left>')
vim.keymap.set({ 'n', 'x' }, 'k', '<down>')
vim.keymap.set({ 'n', 'x' }, 'l', '<right>')
vim.keymap.set({ 'n', 'x' }, '<C-i>', '<C-w><up>')
vim.keymap.set({ 'n', 'x' }, '<C-j>', '<C-w><left>')
vim.keymap.set({ 'n', 'x' }, '<C-k>', '<C-w><down>')
vim.keymap.set({ 'n', 'x' }, '<C-l>', '<C-w><right>')
vim.keymap.set({ 'n', 'x' }, '<C-up>', '<C-w><up>')
vim.keymap.set({ 'n', 'x' }, '<C-left>', '<C-w><left>')
vim.keymap.set({ 'n', 'x' }, '<C-down>', '<C-w><down>')
vim.keymap.set({ 'n', 'x' }, '<C-right>', '<C-w><right>')
----------------------------
----------------------------
-- non plugin key mapping --
----------------------------
----------------------------

-------------
-------------
-- autocmd --
-------------
-------------
-- auto-reload files when modified externally
vim.o.autoread = true
-- vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
--   command = "if mode() != 'c' | checktime | endif",
--  pattern = { "*" },
--})

vim.api.nvim_create_autocmd('Colorscheme', {
  group = vim.api.nvim_create_augroup('custom_highlights', {}),
  callback = function()
    -- configure tab color
    local fg = "#cdcecf"
    local bg = "#29394f"
    vim.api.nvim_set_hl(0, 'BufferCurrent', {fg = fg, bg = bg})
    vim.api.nvim_set_hl(0, 'BufferCurrentSign', {fg = fg, bg = bg})
    vim.api.nvim_set_hl(0, 'BufferCurrentMod', {fg = fg, bg = bg})

    vim.api.nvim_set_hl(0, 'WinSeparator', {fg = "#71839b"})
  end,
})
vim.cmd("colo nightfox")

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
vim.api.nvim_create_autocmd("BufWinEnter",
  {
    pattern = "*.rst",
    command = "set ft=rust"
  }
)

vim.api.nvim_create_autocmd({"BufEnter"},
  {
    pattern = {
      "*.tmux",
      "*.templ",
    },
    command = "let &filetype=expand('%:e')" -- set filetype based on extension
  }
)

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', {}),
  desc = 'Hightlight selection on yank',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank { higroup = 'IncSearch', timeout = 200 }
  end,
})
-------------
-------------
-- autocmd --
-------------
-------------

---------------
---------------
-- functions --
---------------
---------------
vim.api.nvim_create_user_command(
  "Gofmt",
  function(opts)
    vim.cmd([[cexpr system('gofmt -e -w ' . expand('%')) | e!]])
  end,
  { nargs = '?' }
)

-- https://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
vim.keymap.set('n', 'cn', '*``cgn')
vim.g.mc = vim.api.nvim_replace_termcodes([[y/\V<C-r>= escape(@", '/')<CR><CR>]], true, true, true)
vim.api.nvim_set_keymap('x', 'cn', [[g:mc . "``cgn"]], { expr = true })
