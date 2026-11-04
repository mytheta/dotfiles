-- ============================================================
-- settings
-- ============================================================
vim.opt.lazyredraw = true                   -- fast
vim.opt.clipboard = 'unnamedplus'           -- yankをクリップボードと共有
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

-- yank は常に OSC 52 で「手元の端末」のクリップボードへ送る(ssh 越しでも届く)
-- SSH_TTY 等で判定すると、ローカルで起動した tmux に ssh から attach した場合に
-- 環境変数が引き継がれず pbcopy に落ちてしまうので、判定せず常に送る
-- 加えて pbcopy にも入れておき、paste は pbpaste から読む(OSC 52 の読み出しはほぼ非対応)
do
  local osc52 = require('vim.ui.clipboard.osc52')
  local has_pb = vim.fn.executable('pbcopy') == 1
  local function copy(reg)
    local send = osc52.copy(reg)
    return function(lines, regtype)
      send(lines, regtype)
      if has_pb then vim.fn.system('pbcopy', table.concat(lines, '\n')) end
    end
  end
  local function paste()
    local reg = vim.fn.getreg('"')
    if has_pb then
      local text = vim.fn.system('pbpaste')
      -- 自分で yank した内容ならレジスタタイプ(行単位/矩形など)も復元する
      if text ~= reg:gsub('\n$', '') then return vim.split(text, '\n') end
    end
    return { vim.split(reg, '\n'), vim.fn.getregtype('"') }
  end
  vim.g.clipboard = {
    name = 'OSC 52 + pbcopy',
    copy = { ['+'] = copy('+'), ['*'] = copy('*') },
    paste = { ['+'] = paste, ['*'] = paste },
  }
end

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

-- 開いてる絶対pathをコピー (クリップボードレジスタ経由なので ssh 先でも手元に届く)
vim.keymap.set('n', '<Space>c', function()
  vim.fn.setreg('+', vim.fn.expand('%:p'))
end, { silent = true })

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

  " markdown preview (nvim 0.12+, kitty graphics protocol 対応ターミナル推奨)
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'delphinus/budoux.lua'
  Plug 'delphinus/md-render.nvim'

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
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case --hidden -g "!.git/**" -- %s || true'
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

-- md-render (markdown プレビュー)
vim.keymap.set('n', '<Space>m', '<Plug>(md-render-preview)')
vim.keymap.set('n', '<Space>M', '<Plug>(md-render-preview-tab)')

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
  -- pyright は PATH の python を見るため、放置すると pyenv の global 環境を参照して
  -- サードパーティ製 import が全て解決不能になる。root_dir 配下の venv を明示的に渡す。
  before_init = function(_, config)
    local root = config.root_dir or vim.fn.getcwd()
    local candidates = { root .. '/.venv/bin/python', vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. '/bin/python') }
    for _, python in ipairs(candidates) do
      if python and vim.fn.executable(python) == 1 then
        -- config.settings 自体を差し替えると client.settings の参照が古いままになるので、
        -- 既存テーブルの python キーを in-place で書き換える
        config.settings = config.settings or {}
        config.settings.python =
          vim.tbl_deep_extend('force', config.settings.python or {}, { pythonPath = python })
        return
      end
    end
  end,
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

vim.lsp.config('vtsls', {
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,      -- プロジェクトの node_modules/typescript を使う
      experimental = {
        completion = { enableServerSideFuzzyMatch = true },
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = 'always' },
      suggest = { completeFunctionCalls = true },
      preferences = { importModuleSpecifier = 'shortest' },
      inlayHints = {
        parameterNames = { enabled = 'literals' },
        parameterTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
      },
    },
    javascript = {
      updateImportsOnFileMove = { enabled = 'always' },
      preferences = { importModuleSpecifier = 'shortest' },
    },
  },
})

-- eslint: 保存時に --fix (eslint 設定のあるプロジェクトでのみ起動する)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('dotfiles_eslint_fix', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= 'eslint' then
      return
    end
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = args.buf,
      command = 'LspEslintFixAll',
    })
  end,
})

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'gopls', 'rust_analyzer', 'pyright', 'vtsls', 'eslint' },
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
