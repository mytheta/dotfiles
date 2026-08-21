-- ============================================================
-- settings
-- ============================================================
vim.opt.lazyredraw = true                   -- fast
vim.opt.clipboard = 'unnamedplus'           -- macのクリップボードとyankを共有
vim.opt.showmatch = true                    -- 括弧移動
vim.opt.matchtime = 1                       -- 時間短縮
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.history = 100                       -- コマンドラインの履歴
vim.opt.iskeyword:append('-')               -- ハイフンをiskeywordに含める
vim.opt.swapfile = false
vim.opt.number = true                       -- 行番号の表示
vim.opt.ruler = false                       -- 右下に表示されるやつを消す
vim.opt.visualbell = true                   -- ビープ音を消す

-- paste時にyankしない
vim.keymap.set('x', 'p', function()
  return 'pgv"' .. vim.v.register .. 'ygv<esc>'
end, { expr = true })

-- fileからディレクトリに戻る
vim.keymap.set('n', '-', ':<C-u>e %:h<CR>')

-- 外部変更の同期
vim.api.nvim_create_autocmd('CursorHold', {
  group = vim.api.nvim_create_augroup('dotfiles_checktime', { clear = true }),
  command = 'checktime',
})

-- 開いてる絶対pathをコピー
vim.keymap.set('n', '<Space>c', ':silent !echo %:p | pbcopy<CR>', { silent = true })

-- ============================================================
-- vim-plug
-- ============================================================
vim.cmd([[
call plug#begin('~/.vim/plugged')
  " lsp
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate' }
  Plug 'williamboman/mason-lspconfig.nvim'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  " code-action プレビュー
  Plug 'aznhe21/actions-preview.nvim'
  Plug 'MunifTanjim/nui.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-lua/plenary.nvim'

  " filer
  Plug 'mattn/vim-molder'
  Plug 'mattn/vim-molder-operations'

  " fzf
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  " vim-ripgrep
  Plug 'jremmen/vim-ripgrep'

  " test
  Plug 'vim-test/vim-test', { 'on': ['TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit'] }
  Plug 'preservim/vimux',   { 'on': ['TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit'] }

  " status bar
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'tpope/vim-fugitive'

  " git
  Plug 'tyru/open-browser.vim',        { 'on': ['OpenBrowser', 'OpenBrowserSmartSearch', 'OpenGithubFile', 'OpenGithubPullReq', 'OpenGithubIssue', 'OpenGithubProject'] }
  Plug 'tyru/open-browser-github.vim', { 'on': ['OpenGithubFile', 'OpenGithubPullReq', 'OpenGithubIssue', 'OpenGithubProject'] }
  Plug 'airblade/vim-gitgutter'
  Plug 'iberianpig/tig-explorer.vim',  { 'on': ['TigStatus', 'TigOpenCurrentFile', 'TigOpenProjectRootDir', 'TigBlame', 'TigGrep'] }

  " etc
  Plug 'tpope/vim-commentary'
  Plug 'unblevable/quick-scope'
  Plug 'windwp/nvim-autopairs'
  Plug 'tomasr/molokai'

  " languages
  Plug 'mattn/vim-goimports',    { 'for': 'go' }
  Plug 'rust-lang/rust.vim',     { 'for': 'rust' }
  Plug 'hashivim/vim-terraform', { 'for': ['terraform', 'hcl'] }
  Plug 'uarun/vim-protobuf',     { 'for': 'proto' }
call plug#end()
]])

-- ============================================================
-- fzf
-- ============================================================
vim.keymap.set('n', '<Space>b', ':Buffers<CR>')
vim.keymap.set('n', '<Space>f', ':Files<CR>')
vim.env.FZF_DEFAULT_COMMAND = "rg --files --hidden -g '!.git/**' -g '!bazel-server'"

-- ============================================================
-- vim-ripgrep (RG)
-- ============================================================
vim.cmd([[
function! FZGrep(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang RG call FZGrep(<q-args>, <bang>0)
]])
vim.keymap.set('n', '<Space>l', ':RG<CR>')

-- ============================================================
-- colorscheme
-- ============================================================
vim.opt.termguicolors = true
vim.cmd('syntax on')
vim.cmd.colorscheme('molokai')

-- true color 対応 (tmux/screen 下)
vim.cmd([[
if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
]])

-- ============================================================
-- plugin configs
-- ============================================================
vim.g.molder_show_hidden = 1

-- gitgutter
vim.opt.updatetime = 250
vim.opt.signcolumn = 'yes'

-- vim-test
vim.keymap.set('n', '<Space>t', ':TestNearest<CR>', { silent = true })
vim.g['test#strategy'] = 'vimux'

-- vim-goimports
vim.g.goimports = 1
vim.g.goimports_simplify = 1

-- rust.vim
vim.g.rustfmt_autosave = 1

-- vim-airline
vim.g.airline_theme = 'violet'
vim.g['airline#extensions#tabline#enabled'] = 1
vim.g.airline_statusline_ontop = 1
vim.g.airline_powerline_fonts = 0
vim.g['airline#extensions#tabline#buffer_nr_show'] = 1
vim.g.airline_section_b = '%{airline#extensions#branch#get_head()}'
vim.g.airline_section_x = ''
vim.g.airline_section_y = ''
vim.g.airline_section_z = ''
vim.g['airline#extensions#whitespace#enabled'] = 0
vim.g.airline_skip_empty_sections = 1

vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('dotfiles_laststatus', { clear = true }),
  callback = function() vim.opt.laststatus = 0 end,
})

-- tig
vim.keymap.set('n', 'tt', ':TigStatus<CR>', { silent = true })

-- ============================================================
-- highlights (半透明化 + cursor)
-- ============================================================
for _, group in ipairs({ 'Normal', 'NonText', 'LineNr', 'Folded', 'EndOfBuffer' }) do
  vim.api.nvim_set_hl(0, group, { bg = 'NONE', ctermbg = 'NONE' })
end

vim.api.nvim_set_hl(0, 'Cursor',  { fg = 'NONE', bg = '#00FFFF' })
vim.api.nvim_set_hl(0, 'lCursor', { fg = 'NONE', bg = '#00FFFF' })

-- Parenの色をわかりやすく
vim.api.nvim_set_hl(0, 'MatchParen', {
  bold = true,
  fg = '#B0B0B0',
  bg = 'NONE',
  ctermfg = 'lightgrey',
  ctermbg = 'NONE',
})

-- ============================================================
-- LSP / completion (mason-lspconfig v2 + nvim 0.11+ API)
-- ============================================================
-- 全サーバー共通の capabilities (nvim-cmp)
vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

vim.lsp.config('gopls', {
  settings = {
    gopls = {
      usePlaceholders = true,
      gofumpt = true,
      staticcheck = true,
      analyses = {
        unusedparams = true,
        nilness = true,
        shadow = true,
      },
      codelenses = {
        generate = true,
        gc_details = false,
        test = true,
        tidy = true,
      },
    },
  },
})

vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      cargo = { allFeatures = true },
      checkOnSave = true,
      check = { command = 'clippy' },
      inlayHints = { enable = true },
    },
  },
})

vim.lsp.config('pyright', {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      },
    },
  },
})

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'gopls', 'rust_analyzer', 'pyright' },
  automatic_enable = true,   -- インストール済みサーバーを vim.lsp.enable で自動有効化
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('dotfiles_lsp_attach', { clear = true }),
  callback = function(args)
    local buf = args.buf
    local nmap = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = buf, silent = true, noremap = true, desc = desc })
    end

    nmap('<Space>d', vim.lsp.buf.definition,                   'Go to definition')
    nmap('<Space>T', vim.lsp.buf.type_definition,              'Go to type')
    nmap('<Space>i', vim.lsp.buf.implementation,               'Go to impl')
    nmap('<Space>a', require('actions-preview').code_actions,  'Preview code action')
    nmap('rn',       vim.lsp.buf.rename,                       'Rename symbol')
    nmap('rr',       vim.lsp.buf.references,                   'List references')
  end,
})

require('nvim-autopairs').setup({})

local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)       -- nvim 0.10+ ネイティブ snippet
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<Tab>']   = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>']    = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = 'nvim_lsp' },
  },
})
cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())

require('actions-preview').setup({
  backend = { 'telescope', 'nui' },
  telescope = require('telescope.themes').get_dropdown({
    winblend = 10,
    preview_cutoff = 20,
  }),
})

vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    severity = vim.diagnostic.severity.ERROR,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✗',
      [vim.diagnostic.severity.WARN]  = '⚠',
      [vim.diagnostic.severity.INFO]  = 'ℹ',
      [vim.diagnostic.severity.HINT]  = '→',
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = '#ff0000' })
vim.api.nvim_set_hl(0, 'DiagnosticWarn',  { fg = '#ffaa00' })
vim.api.nvim_set_hl(0, 'DiagnosticInfo',  { fg = '#00aaff' })
vim.api.nvim_set_hl(0, 'DiagnosticHint',  { fg = '#ffffff' })
