""
"" * setting
""
set lazyredraw " fast
set clipboard=unnamedplus " macのクリップボードとyankを共有
set showmatch " 括弧移動
set matchtime=1 " 時間短縮
set autoread " 開いているがvim上で変更のないファイルについて、外部で変更があった時に自動的に読み込む
set enc=utf8 " utf8
set fenc=utf-8 " utf8にエンコード
set shiftwidth=4
set tabstop=4
set hidden " 保存されていないファイルがあるときでも別のファイルを開くことが出来る
set history=100 " コマンドラインの履歴を100件保存する
set hlsearch " 検索文字列をハイライトする
set incsearch " インクリメンタルサーチを行う
set isk+=- " ハイフンをiskeywordに含める
set ttyfast
set nobackup " 勝手に作るファイルを無効にする
set noswapfile
set number " 行番号の表示
set noruler " 右下に表示されるやつを消す
set visualbell " ビープ音を消す
set wildmenu " ファイル名補完
set wildmode=full
set wrap " 画面の端で、行を折り返して表示してくれるようになる
set backspace=indent,eol,start " インサートモード中の BS、CTRL-W、CTRL-U による文字削除を柔軟にする
set autoindent "改行時に前の行のインデントを継続する"
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
	Plug 'vim-test/vim-test'
	Plug 'preservim/vimux'
	
	" status bar
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'tpope/vim-fugitive' " status barにgit branchを表示させるため

	" git
	Plug 'tyru/open-browser.vim'
	Plug 'tyru/open-browser-github.vim'
	Plug 'airblade/vim-gitgutter'
	Plug 'iberianpig/tig-explorer.vim' " vimからtigを開く

	" etc
	Plug 'tpope/vim-commentary' " gccでコメントアウトできるようにする
	Plug 'unblevable/quick-scope' " 横移動をいい感じにする
	Plug 'cohama/lexima.vim' " 閉じかっこ補完
	Plug 'tomasr/molokai' " color thema

	" go
	Plug 'mattn/vim-goimports'
	" rust
	Plug 'rust-lang/rust.vim'
	" terraform
	Plug 'hashivim/vim-terraform'
	" protobuf
	Plug 'uarun/vim-protobuf'
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
        checkOnSave = { command = "clippy" },
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
-- エラー表示の設定
vim.diagnostic.config({
  virtual_text = {
    prefix = '●',                             -- エラーアイコン
    severity = vim.diagnostic.severity.ERROR,  -- エラーのみ表示
  },
  signs = true,                               -- 左側にエラー記号を表示
  underline = true,                           -- エラー行に下線を表示
  update_in_insert = false,                   -- 挿入モード中は更新しない
  severity_sort = true,                       -- 重要度順にソート
})

-- エラーの色設定
vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = '#ff0000' })
vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = '#ffaa00' })
vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = '#00aaff' })
vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = '#ffffff' })

-- エラー記号の設定
local signs = {
  { name = "DiagnosticSignError", text = "✗", texthl = "DiagnosticSignError" },
  { name = "DiagnosticSignWarn", text = "⚠", texthl = "DiagnosticSignWarn" },
  { name = "DiagnosticSignInfo", text = "ℹ", texthl = "DiagnosticSignInfo" },
  { name = "DiagnosticSignHint", text = "→", texthl = "DiagnosticSignHint" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, {
    texthl = sign.name,
    text = sign.text,
    numhl = ""
  })
end
EOF

hi MatchParen cterm=bold ctermfg=lightgrey ctermbg=NONE gui=bold guifg=#B0B0B0 guibg=NONE " Parenの色をわかりやすく
