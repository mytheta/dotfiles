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

""
"" * 挿入モードで縦棒カーソル表示(vimの時)
""
if has('vim_starting')
	let &t_SI .= "\e[6 q"
	let &t_EI .= "\e[2 q"
	let &t_SR .= "\e[4 q"
endif

""
"" * fileからディレクトリに戻る
""
nnoremap - :<C-u>e %:h<CR>

""
"" * vim-plugin
""
call plug#begin('~/.vim/plugged')
	" lsp
	Plug 'neovim/nvim-lspconfig'
	Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate' }
	Plug 'williamboman/mason-lspconfig.nvim'
	Plug 'hrsh7th/nvim-cmp'
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'hrsh7th/cmp-vsnip'

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
	
	" スニペット
	Plug 'hrsh7th/vim-vsnip'
	Plug 'hrsh7th/vim-vsnip-integ'

	" status bar
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'tpope/vim-fugitive' " status barにgit branchを表示させるため

	" git
	Plug 'tyru/open-browser.vim'
	Plug 'tyru/open-browser-github.vim'
	Plug 'APZelos/blamer.nvim'
	Plug 'airblade/vim-gitgutter'
	Plug 'iberianpig/tig-explorer.vim' " vimからtigを開く
	Plug 'rbgrouleff/bclose.vim'

	" etc
	Plug 'tpope/vim-commentary' " gccでコメントアウトできるようにする
	Plug 'unblevable/quick-scope' " 横移動をいい感じにする
	Plug 'terryma/vim-expand-region' " 選択範囲をいい感じにする
	Plug 'cohama/lexima.vim' " 閉じかっこ補完
	Plug 'tomasr/molokai' " color thema

	" go
	Plug 'mattn/vim-goimports'
	" terraform
	Plug 'hashivim/vim-terraform'
	" ytt
	Plug 'cappyzawa/starlark.vim'
	Plug 'vmware-tanzu/ytt.vim'
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
"" * terryma/vim-expand-region
""
map K <Plug>(expand_region_expand)
map J <Plug>(expand_region_shrink)

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
" highlight Normal ctermbg=NONE guibg=NONE
" highlight NonText ctermbg=NONE guibg=NONE
" highlight LineNr ctermbg=NONE guibg=NONE
" highlight Folded ctermbg=NONE guibg=NONE
" highlight EndOfBuffer ctermbg=NONE guibg=NONE

" ==================================================================
" LSP / completion (Lua) ###########################################
" ==================================================================
lua << EOF
-- mason -----------------------------------------------------------
require('mason').setup()
require('mason-lspconfig').setup{
  ensure_installed = { 'gopls' },   -- 使う言語サーバーを列挙
  automatic_installation = true,
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
    nmap('<Space>a', vim.lsp.buf.code_action,      'Code action')
    nmap('rn',        vim.lsp.buf.rename,          'Rename symbol')
    nmap('rr',        vim.lsp.buf.references,      'List references')
  end,
})

-- capabilities (for nvim-cmp) ------------------------------------
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- gopls -----------------------------------------------------------
require('lspconfig').gopls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    gopls = {
      usePlaceholders = true,      -- 旧 g:lsp_settings 相当
    },
  },
}

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
EOF

" colorscheme の直後に書くと確実に上書きできる
hi MatchParen cterm=bold ctermfg=lightgrey ctermbg=NONE gui=bold guifg=#B0B0B0 guibg=NONE
