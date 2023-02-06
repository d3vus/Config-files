--------------------------------------------------------------------------- VARIABLE ----------------------------------------------------------------------------------------------------

local set = vim.opt
local global = vim.g
local keymap = vim.keymap

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------- NVIM-TREE --------------------------------------------------------------------------------------------------
-- Disable netrw to use nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- setup nvim-tree with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
}
)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

require("toggleterm").setup{}
-------------------------------------------------------------------------------- AUTO PAIRS ------------------------------------------------------------------------------------------------------------------
--
require('nvim-autopairs').setup({
  disable_filetype = { "TelescopePrompt" , "vim" },
}) 
-------------------------------------------------------------------------------- SET THEME ----------------------------------------------------------------------------------------------

require('onedark').setup {
    style = 'darker'
}
require('onedark').load()

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
local lualine = require('lualine')

-- Color table for highlights
-- stylua: ignore
local colors = {
  bg       = '#202328',
  fg       = '#bbc2cf',
  yellow   = '#ECBE7B',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#98be65',
  orange   = '#FF8800',
  violet   = '#a9a1e1',
  magenta  = '#c678dd',
  blue     = '#51afef',
  red      = '#ec5f67',
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

-- Config
local config = {
  options = {
    -- Disable sections and component separators
    component_separators = '',
    section_separators = '',
    theme = {
      -- We are going to use lualine_c an lualine_x as left and
      -- right section. Both are highlighted by c theme .  So we
      -- are just setting default looks o statusline
      normal = { c = { fg = colors.fg, bg = colors.bg } },
      inactive = { c = { fg = colors.fg, bg = colors.bg } },
    },
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left {
  function()
    return '▊'
  end,
  color = { fg = colors.blue }, -- Sets highlighting of component
  padding = { left = 0, right = 1 }, -- We don't need space before this

}

ins_left {
  -- mode component
  function()
    return ''
  end,
  color = function()
    -- auto change color according to neovims mode
    local mode_color = {
      n = colors.red,
      i = colors.green,
      v = colors.blue,
      [''] = colors.blue,
      V = colors.blue,
      c = colors.magenta,
      no = colors.red,
      s = colors.orange,
      S = colors.orange,
      [''] = colors.orange,
      ic = colors.yellow,
      R = colors.violet,
      Rv = colors.violet,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ['r?'] = colors.cyan,
      ['!'] = colors.red,
      t = colors.red,
    }
    return { fg = mode_color[vim.fn.mode()] }
  end,
  padding = { right = 1 },
}

ins_left {
  -- filesize component
  'filesize',
  cond = conditions.buffer_not_empty,
}

ins_left {
  'filename',
  cond = conditions.buffer_not_empty,
  color = { fg = colors.magenta, gui = 'bold' },
}

ins_left { 'location' }

ins_left { 'progress', color = { fg = colors.fg, gui = 'bold' } }

ins_left {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = { error = ' ', warn = ' ', info = ' ' },
  diagnostics_color = {
    color_error = { fg = colors.red },
    color_warn = { fg = colors.yellow },
    color_info = { fg = colors.cyan },
  },
}

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left {
  function()
    return '%='
  end,
}

--[[ins_left {
  -- Lsp server name .
  function()
    local msg = 'No Active Lsp'
    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return msg
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return client.name
      end
    end
    return msg
  end,
  icon = ' LSP:',
  color = { fg = '#ffffff', gui = 'bold' },
}
]]

-- Add components to right sections
ins_right {
  'o:encoding', -- option component same as &encoding in viml
  fmt = string.upper, -- I'm not sure why it's upper case either ;)
  cond = conditions.hide_in_width,
  color = { fg = colors.green, gui = 'bold' },
}

ins_right {
  'fileformat',
  fmt = string.upper,
  icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
  color = { fg = colors.green, gui = 'bold' },
}

ins_right {
  'branch',
  icon = '',
  color = { fg = colors.violet, gui = 'bold' },
}

ins_right {
  'diff',
  -- Is it me or the symbol for modified us really weird
  symbols = { added = ' ', modified = '柳 ', removed = ' ' },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
  },
  cond = conditions.hide_in_width,
}

ins_right {
  function()
    return '▊'
  end,
  color = { fg = colors.blue },
  padding = { left = 1 },
}

-- Now don't forget to initialize lualine
lualine.setup(config)





--[[

-- Bubbles config for lualine
-- Author: lokesh-krishna
-- MIT license, see LICENSE for more details.

-- stylua: ignore
local colors = {
  blue   = '#80a0ff',
  cyan   = '#79dac8',
  black  = '#080808',
  white  = '#c6c6c6',
  red    = '#ff5189',
  violet = '#d183e8',
  grey   = '#303030',
}

local bubbles_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.violet },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.black, bg = colors.black },
  },

  insert = { a = { fg = colors.black, bg = colors.blue } },
  visual = { a = { fg = colors.black, bg = colors.cyan } },
  replace = { a = { fg = colors.black, bg = colors.red } },

  inactive = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.black, bg = colors.black },
  },
}

require('lualine').setup {
  options = {
    theme = bubbles_theme,
    component_separators = '|',
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = {
      { 'mode', separator = { left = '' }, right_padding = 2 },
    },
    lualine_b = { 'filename', 'branch' },
    lualine_c = { 'fileformat' },
    lualine_x = {},
    lualine_y = { 'filetype', 'progress' },
    lualine_z = {
      { 'location', separator = { right = '' }, left_padding = 2 },
    },
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  tabline = {},
  extensions = {},
}

--]]
-------------------------------------------------------------------------------- TERMINAL -----------------------------------------------------------------------------------------------

-- Terminal settings

function openterminal()
    set.split = "term://fish"
    set.resize = 10
end

-- FloatermToggle

global.floaterm_shell = "fish"

------------------------------------------------------------------------------- CONQUER OF COMPLETION -----------------------------------------------------------------------------------------

-- Coc-extensions
global.coc_global_extensions = {'coc-eslint', 'coc-emmet', 'coc-html', 'coc-json', 'coc-tsserver', 'coc-go', 'coc-pyright', 'coc-prettier', 'coc-git', 'coc-yaml'}


------------------------------------------------------------------------------- BUFFERLINE ----------------------------------------------------------------------------------------------------------

require("bufferline").setup{
    options = {

        
        offsets = {
        {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true -- use a "true" to enable the default, or set your own character
        }
    },

}
}

--[[local db=require'dashboard'
db.setup({
  theme = 'doom',
  config = {
    header = {}, --your header
    center = {
      {
        icon = ' ',
        icon_hl = 'Title',
        desc = 'Find File',
        desc_hl = 'String',
        key = 'b',
        keymap = 'SPC f f',
        key_hl = 'Number',
        action = 'lua print(2)'
      },
      {
        icon = ' ',
        desc = 'Find Dotfiles',
        key = 'f',
        keymap = 'SPC f d',
        action = 'lua print(3)'
      },
    },
    footer = {}  --your footer
  }
})--]]
------------------------------------------------------------------------------- DASHBOARD NEOVIM -------------------------------------------------------------------------------------------------------------------------------------
--



------------------------------------------------------------------------------- FUZZY FILE FINDER -------------------------------------------------------------------------------------------------------
--
global.fzf_action = {}

------------------------------------------------------------------------------ TELESCOPE -----------------------------------------------------------------------------------------------------
--

local builtin = require('telescope.builtin')  
keymap.set('n', '<leader>ff', builtin.find_files, {})
keymap.set('n', '<leader>fg', builtin.live_grep, {})
keymap.set('n', '<leader>fb', builtin.buffers, {})
keymap.set('n', '<leader>fh', builtin.help_tags, {})




----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------- OPTIONS FOR NEOVIM -------------------------------------------------------------------------------------------------------------------------------

set.number = true
set.tabstop = 4
set.shiftwidth = 4
set.softtabstop = 0
set.expandtab = true
set.swapfile = false
set.relativenumber = true
set.termguicolors = true
set.incsearch = true
set.ruler =  true 
set.backup = false
set.ignorecase = true
-- set.hlsearch = true
set.termguicolors = true
set.fileencoding = "utf-8"
set.mouse = "a"
set.splitbelow = true
set.splitright = true
set.updatetime = 300
set.signcolumn = "yes"

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- LEADER KEY
global.mapleader = " " 

------------------------------------------------------------------------- KEYMAPS -----------------------------------------------------------------------------------------------------------------------------------------

keymap.set('n', '<leader>w',  ':w<CR>',{noremap = true})
keymap.set('i', '<leader>e',  '<esc>:w<CR>',{noremap = true})
keymap.set('n', '<leader>q',  ':q!<CR>',{noremap = true})
keymap.set('n', '<leader>s',  ':so %<CR>',{noremap = true})
keymap.set('n', '<leader>ev', ':vsplit $MYVIMRC<CR>',{noremap = true})
keymap.set('n', '<leader>sv', ':w<CR>:so %<CR>:q<CR>',{noremap = true})
keymap.set('n', '<leader>b',  ':NvimTreeToggle<CR>',{noremap = true})

--move around pane
keymap.set('n', '<A-h>',      '<C-w>h',{noremap = true})
keymap.set('n', '<A-j>',      '<C-w>j',{noremap = true})
keymap.set('n', '<A-k>',      '<C-w>k',{noremap = true})
keymap.set('n', '<A-l>',      '<C-w>l',{noremap = true})

-- split screen
keymap.set('n', '<leader>h',  '<C-w>s', {noremap =  true})
keymap.set('n', '<leader>v',  '<C-w>v', {noremap =  true})

-- resize pane
keymap.set('n', '<leader><Left>', ':vertical resize -10<CR>', {noremap = true})
keymap.set('n', '<leader><Right>', ':vertical resize +10<CR>', {noremap = true})
keymap.set('n', '<leader><Up>', ':resize +10<CR>', {noremap = true})
keymap.set('n', '<leader><Down>', ':resize -10<CR>', {noremap = true})


-- move in pane
keymap.set('n', '<tab>', '<c-w><c-w>', {noremap = true})


-- terminal
keymap.set('n', '<C-n>', ':FloatermToggle --height=2.0 --width=1.5<CR>', {noremap = true})
keymap.set('t', '<esc>', '<C-\\><C-n>', {noremap = true})

-- FZF
keymap.set('n', '<c-p>', ':FZF<CR>', {noremap = true})


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------  PLUGINS  --------------------------------------------------------------------------------------------------------------------------------------

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'tpope/vim-fugitive'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use 'tiagofumo/vim-nerdtree-syntax-highlight'
  use 'kyazdani42/nvim-web-devicons'
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'
  use 'Mofiqul/dracula.nvim'
  use {
  'nvim-tree/nvim-tree.lua',
  requires = {
    'nvim-tree/nvim-web-devicons', -- optional, for file icons
  }, 
}
  use {
	'windwp/nvim-autopairs',
    config = function() require("nvim-autopairs").setup {} end
  }
  -- Theme
  use 'navarasu/onedark.nvim' 

  --tabline
  use {'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons'}

  use 'voldikss/vim-floaterm'
  use {"akinsho/toggleterm.nvim", tag = '*', config = function()
  require("toggleterm").setup()
end}

  use {'neoclide/coc.nvim', branch ='release'}

  
  use { "junegunn/fzf", run = ":call fzf#install()" }

  use {
  'nvim-telescope/telescope.nvim', tag = '0.1.1',
-- or                            , branch = '0.1.x',
  requires = { {'nvim-lua/plenary.nvim'} }
}

  use {
  'glepnir/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup {
      -- config
    }
  end,
  requires = {'nvim-tree/nvim-web-devicons'}
}

end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


