""
"" * setting
""
set lazyredraw " fast
set clipboard=unnamedplus " macのクリップボードとyankを共有
set showmatch " 括弧移動
set matchtime=1 " 時間短縮
set shiftwidth=4
set tabstop=4
set history=100 " コマンドラインの履歴を100件保存する
set isk+=- " ハイフンをiskeywordに含める
set noswapfile
set number " 行番号の表示
set noruler " 右下に表示されるやつを消す
set visualbell " ビープ音を消す
xnoremap <expr> p 'pgv"'.v:register.'ygv<esc>' " paste時にyankしない
nnoremap - :<C-u>e %:h<CR> " fileからディレクトリに戻る
au CursorHold * checktime " 同期
nnoremap <silent> <Space>c :silent !echo %:p \| pbcopy<CR> " 開いてる絶対pathを取得

""
"" * vim-plugin
""
call plug#begin('~/.vim/plugged')
	" lsp
	Plug 'neovim/nvim-lspconfig' " LSP設定
	Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate' } " LSPサーバー管理
	Plug 'williamboman/mason-lspconfig.nvim'
	Plug 'hrsh7th/nvim-cmp' " 補完
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'hrsh7th/cmp-vsnip'
	" --- code-action プレビュー ------------------------------
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
	Plug 'preservim/vimux', { 'on': ['TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit'] }
	
	" status bar
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'tpope/vim-fugitive' " status barにgit branchを表示させるため

	" git
	Plug 'tyru/open-browser.vim', { 'on': ['OpenBrowser', 'OpenBrowserSmartSearch'] }
	Plug 'tyru/open-browser-github.vim', { 'on': ['OpenGithubFile', 'OpenGithubPullReq', 'OpenGithubIssue', 'OpenGithubProject'] }
	Plug 'airblade/vim-gitgutter'
	Plug 'iberianpig/tig-explorer.vim', { 'on': ['TigStatus', 'TigOpenCurrentFile', 'TigOpenProjectRootDir', 'TigBlame', 'TigGrep'] } " vimからtigを開く

	" etc
	Plug 'tpope/vim-commentary' " gccでコメントアウトできるようにする
	Plug 'unblevable/quick-scope' " 横移動をいい感じにする
	Plug 'cohama/lexima.vim' " 閉じかっこ補完
	Plug 'tomasr/molokai' " color thema
	Plug 'eetann/editprompt.nvim' " editprompt 連携

	" go
	Plug 'mattn/vim-goimports', { 'for': 'go' }
	" rust
	Plug 'rust-lang/rust.vim', { 'for': 'rust' }
	" terraform
	Plug 'hashivim/vim-terraform', { 'for': ['terraform', 'hcl'] }
	" protobuf
	Plug 'uarun/vim-protobuf', { 'for': 'proto' }
call plug#end()

""
"" * fzf
""
nnoremap <Space>b :Buffers<CR>
nnoremap <Space>f :Files<CR>
let $FZF_DEFAULT_COMMAND="rg --files --hidden -g '!.git/**' -g '!bazel-server'"


""
"" * vim-ripgrep
""
function! FZGrep(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call FZGrep(<q-args>, <bang>0)
nnoremap <Space>l :RG<CR>

""
"" * colorscheme
""
syntax on
colorscheme molokai

" true color対応
if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

""
"" * mattn/vim-molder
""
let g:molder_show_hidden = 1

""
"" * airblade/vim-gitgutter
""
set updatetime=250
set signcolumn=yes

""
"" * vim-test/vim-test
""
nmap <silent> <Space>t :TestNearest<CR>
let test#strategy = "vimux"

""
"" * mattn/vim-goimports
""
let g:goimports = 1
let g:goimports_simplify = 1

""
"" rust-lang/rust.vim
""
" 自動import
let g:rustfmt_autosave = 1


""
"" * vim-airline/vim-airline
""
let g:airline_theme='violet' 
let g:airline#extensions#tabline#enabled = 1
let g:airline_statusline_ontop = 1
let g:airline_powerline_fonts = 0
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_section_b='%{airline#extensions#branch#get_head()}'
let g:airline_section_x=''
let g:airline_section_y=''
let g:airline_section_z=''
let g:airline#extensions#whitespace#enabled = 0
" remove separators for empty sections
let g:airline_skip_empty_sections = 1
autocmd VimEnter * set laststatus=0

""
"" * tig
""
nmap <silent> tt :TigStatus<CR>

""
"" * highlight(半透明化)
""
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight LineNr ctermbg=NONE guibg=NONE
highlight Folded ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE

" カーソル色を水色に
set termguicolors
highlight Cursor guifg=NONE guibg=#00FFFF
highlight lCursor guifg=NONE guibg=#00FFFF

" ==================================================================
" LSP / completion (Lua) ###########################################
" ==================================================================
lua << EOF
-- capabilities (for nvim-cmp) ------------------------------------
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- server configs ---------------------------------------------------
local servers = {
  gopls = {
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
  },

  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        checkOnSave = true,
        check = { command = "clippy" },
        inlayHints = { enable = true },
      },
    },
  },
}

-- mason -----------------------------------------------------------
require('mason').setup()
require('mason-lspconfig').setup{
  ensure_installed = { 'gopls', 'rust_analyzer' },   -- 使う言語サーバーを列挙
  automatic_installation = true,
  handlers = {
    function(server_name)
      local opts = servers[server_name] or {}
      opts.capabilities = capabilities
      require("lspconfig")[server_name].setup(opts)
    end,
  },
}

-- common on_attach ------------------------------------------------
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local buf = args.buf
    local nmap = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs,
        {buffer = buf, silent = true, noremap = true, desc = desc})
    end

    nmap('<Space>d', vim.lsp.buf.definition,       'Go to definition')
    nmap('<Space>T', vim.lsp.buf.type_definition,  'Go to type')
    nmap('<Space>i', vim.lsp.buf.implementation,   'Go to impl')
    nmap('<Space>a', require('actions-preview').code_actions,'Preview code action')
    nmap('rn',        vim.lsp.buf.rename,          'Rename symbol')
    nmap('rr',        vim.lsp.buf.references,      'List references')
  end,
})

-- nvim-cmp --------------------------------------------------------
local cmp = require('cmp')
cmp.setup{
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<Tab>']   = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>']    = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
}

-- actions-preview.nvim -------------------------------------------
require('actions-preview').setup {
  backend = { 'telescope', 'nui' },           -- telescope 優先
  telescope = require('telescope.themes').get_dropdown {
    winblend = 10,                            -- 透過度
    preview_cutoff = 20,                      -- リストが20行以下ならプレビュー非表示
  },
}

-- diagnostics (エラー表示) ----------------------------------------
vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    severity = vim.diagnostic.severity.ERROR,  -- エラーのみvirtual_text表示
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

-- editprompt.nvim -------------------------------------------------
if pcall(require, 'editprompt') then
  require('editprompt').setup({})
  local map = function(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { silent = true, noremap = true })
  end
  map('n', '<Space>ei', '<Cmd>Editprompt input --auto-send<CR>')
  map('n', '<Space>eI', '<Cmd>Editprompt input<CR>')
  map('x', '<Space>ei', '<Cmd>Editprompt input --visual --auto-send<CR>')
  map('n', '<Space>ep', '<Cmd>Editprompt history prev<CR>')
  map('n', '<Space>en', '<Cmd>Editprompt history next<CR>')
  map('n', '<Space>ed', '<Cmd>Editprompt dump<CR>')
  map('n', '<Space>es', '<Cmd>Editprompt stash pop<CR>')
  map('n', '<Space>eS', '<Cmd>Editprompt stash push<CR>')
  map('n', '<Space>ek', '<Cmd>Editprompt press_mode<CR>')
end
EOF

hi MatchParen cterm=bold ctermfg=lightgrey ctermbg=NONE gui=bold guifg=#B0B0B0 guibg=NONE " Parenの色をわかりやすく
