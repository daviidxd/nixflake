-----------------------------------------------------------------------------
-- General Config
-----------------------------------------------------------------------------
vim.g.mapleader = " "
vim.cmd('syntax on')
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.termguicolors = true
-----------------------------------------------------------------------------
-- 1. Theme (CATPPUCCIN)
-----------------------------------------------------------------------------
require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = true,
  term_colors = true,
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    treesitter = true,
    bufferline = true,
    telescope = true,
  },
})
vim.cmd.colorscheme "catppuccin"

-----------------------------------------------------------------------------
-- 2. (NVIM-CMP)
-----------------------------------------------------------------------------
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
      else fallback() end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
    { name = "path" },
  }),
})

-----------------------------------------------------------------------------
-- 3. LSP CONFIG
-----------------------------------------------------------------------------
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local setup_server = function(server, config)
  config = config or {}
  config.capabilities = capabilities
  lspconfig[server].setup(config)
end

-- 1. Lua (lua_ls)
setup_server("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },\
      },
    },
  },
})

-- 2. HTML (html)
setup_server("html")

-- 3. CSS (cssls)
setup_server("cssls")

-- 4. CSS Variables (css_variables)
setup_server("css_variables")

-- 5. CSS Modules (cssmodules_ls)
setup_server("cssmodules_ls")
-----------------------------------------------------------------------------
-- 4. Other Plugins
-----------------------------------------------------------------------------
require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
  indent = { enable = true },
})

require("cord").setup()

-- Nvim-Tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require("nvim-tree").setup({ view = { width = 30 } })
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

require("bufferline").setup({
  options = { diagnostics = "nvim_lsp", separator_style = "thin" }
})

require("auto-save").setup({})

-- Mini.nvim
require("mini.pairs").setup()
require("mini.comment").setup()
require("mini.surround").setup()

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})

-----------------------------------------------------------------------------
-- 5. Lualine
-----------------------------------------------------------------------------
local colors = {
  bg       = '#202328', fg       = '#bbc2cf', yellow   = '#ECBE7B',
  cyan     = '#008080', darkblue = '#081633', green    = '#98be65',
  orange   = '#FF8800', violet   = '#a9a1e1', magenta  = '#c678dd',
  blue     = '#51afef', red      = '#ec5f67',
}

local conditions = {
  buffer_not_empty = function() return vim.fn.empty(vim.fn.expand('%:t')) ~= 1 end,
  hide_in_width = function() return vim.fn.winwidth(0) > 80 end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local config = {
  options = {
    component_separators = '',
    section_separators = '',
    theme = {
      normal = { c = { fg = colors.fg, bg = colors.bg } },
      inactive = { c = { fg = colors.fg, bg = colors.bg } },
    },
  },
  sections = { lualine_a = {}, lualine_b = {}, lualine_y = {}, lualine_z = {}, lualine_c = {}, lualine_x = {} },
  inactive_sections = { lualine_a = {}, lualine_b = {}, lualine_y = {}, lualine_z = {}, lualine_c = {}, lualine_x = {} },
}

local function ins_left(component) table.insert(config.sections.lualine_c, component) end
local function ins_right(component) table.insert(config.sections.lualine_x, component) end

ins_left { function() return '▊' end, color = { fg = colors.blue }, padding = { left = 0, right = 1 } }
ins_left {
  function() return '' end,
  color = function()
    local mode_color = {
      n = colors.red, i = colors.green, v = colors.blue, [''] = colors.blue, V = colors.blue,
      c = colors.magenta, no = colors.red, s = colors.orange, S = colors.orange, 
      ic = colors.yellow, R = colors.violet, Rv = colors.violet, cv = colors.red, ce = colors.red,
      r = colors.cyan, rm = colors.cyan, ['r?'] = colors.cyan, ['!'] = colors.red, t = colors.red,
    }
    return { fg = mode_color[vim.fn.mode()] }
  end,
  padding = { right = 1 },
}
ins_left { 'filesize', cond = conditions.buffer_not_empty }
ins_left { 'filename', cond = conditions.buffer_not_empty, color = { fg = colors.magenta, gui = 'bold' } }
ins_left { 'location' }
ins_left { 'progress', color = { fg = colors.fg, gui = 'bold' } }
ins_left {
  'diagnostics', sources = { 'nvim_diagnostic' },
  symbols = { error = ' ', warn = ' ', info = ' ' },
  diagnostics_color = { color_error = { fg = colors.red }, color_warn = { fg = colors.yellow }, color_info = { fg = colors.cyan } },
}

ins_right {
  function()
    local msg = 'No Active Lsp'
    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_clients()
    if next(clients) == nil then return msg end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then return client.name end
    end
    return msg
  end,
  icon = ' LSP:', color = { fg = '#ffffff', gui = 'bold' },
}
ins_right { 'branch', icon = '', color = { fg = colors.violet, gui = 'bold' } }
ins_right {
  'diff', symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
  diff_color = { added = { fg = colors.green }, modified = { fg = colors.orange }, removed = { fg = colors.red } },
  cond = conditions.hide_in_width,
}
ins_right { function() return '▊' end, color = { fg = colors.blue }, padding = { left = 1 } }

require('lualine').setup(config)
