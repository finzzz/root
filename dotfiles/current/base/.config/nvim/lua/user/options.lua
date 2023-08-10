return {
  opt = {
    relativenumber = true, -- sets vim.opt.relativenumber
    number         = true, -- sets vim.opt.number
    spell          = false, -- sets vim.opt.spell
    signcolumn     = "auto", -- sets vim.opt.signcolumn to auto
    fdc            = "1", -- sets fold column
    wrap           = true, -- sets vim.opt.wrap
    showbreak      = "↪",
    list           = true, -- show whitespace characters
    listchars      = {
      eol        = "$",
      extends    = "»",
      nbsp       = "␣",
      precedes   = "«",
      tab        = "│→",
      trail      = "·",
    },
  },
  g = {
    autoformat_enabled       = false, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
    autopairs_enabled        = true, -- enable autopairs at start
    cmp_enabled              = true, -- enable completion at start
    diagnostics_mode         = 3, -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
    icons_enabled            = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
    mapleader                = " ", -- sets vim.g.mapleader
    ui_notifications_enabled = true, -- disable notifications when toggling UI elements
    vmt_list_item_char       = "-" -- Vim markdown TOC: list item marker
  },
}

