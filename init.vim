""
"" * setting
""
set lazyredraw " fast
set clipboard=unnamed " macのクリップボードとyankを共有
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
set ignorecase " 大文字と小文字を区別しない
set incsearch " インクリメンタルサーチを行う
set isk+=- " ハイフンをiskeywordに含める
set ttyfast
set nobackup " 勝手に作るファイルを無効にする
set noswapfile
set number " 行番号の表示
set showcmd " 入力中のコマンドを右下に表示する
set visualbell " ビープ音を消す
set wildmenu " ファイル名補完
set wildmode=full
set wrap " 画面の端で、行を折り返して表示してくれるようになる
set backspace=indent,eol,start " インサートモード中の BS、CTRL-W、CTRL-U による文字削除を柔軟にする
set autoindent "改行時に前の行のインデントを継続する"
set list
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%
let mapleader = "\<Space>" " Spaceを割り当て
xnoremap <expr> p 'pgv"'.v:register.'ygv<esc>' " paste時にyankしない

""
"" * その他割り当て
""
nmap <silent> tt :vert botright term ++close tig status<CR>

""
"" * カーソル表示
""
if has('vim_starting')
	let &t_SI .= "\e[6 q"
	let &t_EI .= "\e[2 q"
	let &t_SR .= "\e[4 q"
endif

""
"" * fzf
""
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>l :BLines<CR>
let $FZF_DEFAULT_COMMAND="rg --files --hidden -g '!.git/**' -g '!bazel-server'"

""
"" * fileからディレクトリに戻る
""
nnoremap - :<C-u>e %:h<Cr>

""
"" * vim-plugin
""
call plug#begin('~/.vim/plugged')
	Plug 'prabirshrestha/async.vim'
	Plug 'prabirshrestha/asyncomplete.vim'
	Plug 'prabirshrestha/asyncomplete-lsp.vim'
	Plug 'prabirshrestha/vim-lsp'
	Plug 'mattn/vim-lsp-settings'

	Plug 'mattn/vim-goimports'
	Plug 'vim-jp/vim-go-extra'

	Plug 'mattn/vim-molder'
	Plug 'mattn/vim-molder-operations'

	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'

	Plug 'tomasr/molokai'

	Plug 'cappyzawa/starlark.vim'
	Plug 'vmware-tanzu/ytt.vim'
	Plug 'uarun/vim-protobuf'

	Plug 'vim-test/vim-test'
	Plug 'preservim/vimux'

	Plug 'hashivim/vim-terraform'

	Plug 'cohama/lexima.vim'

	Plug 'hrsh7th/vim-vsnip'
	Plug 'hrsh7th/vim-vsnip-integ'

	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'tpope/vim-fugitive' " status barにgit branchを表示させるため

	Plug 'k0kubun/vim-open-github'
	Plug 'APZelos/blamer.nvim'
	Plug 'airblade/vim-gitgutter'

	Plug 'tpope/vim-commentary' " gccでコメントアウトできるようにする

	Plug 'iberianpig/tig-explorer.vim' " vimからtigを開く
call plug#end()


""
"" * colorscheme
""
syntax on
colorscheme molokai


""
"" * golang-syntax
""
autocmd FileType go autocmd BufWritePre <buffer> Fmt

""
"" * lsp
""
nmap <silent> <Leader>d :LspDefinition<CR>
nmap <silent> <Leader>r :LspRename<CR>
nmap <silent> <Leader>T :LspTypeDefinition<CR>
nmap <silent> <Leader>i :LspImplementation<CR>
nmap <silent> <Leader>a :LspCodeAction<CR>
nmap <silent> rr :LspReferences<CR>
" let g:lsp_diagnostics_enabled = 1
" let g:lsp_diagnostics_echo_cursor = 1 " Show diagnostics message to status line
" let g:asyncomplete_popup_delay = 200
" let g:lsp_text_edit_enabled = 0

""
"" * mattn/vim-lsp-settings
""
highlight link LspWarningHighlight Error

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
nmap <silent> <leader>t :TestNearest<CR>
let test#strategy = "vimux"

""
"" * vim-vsnip
""
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
let g:lsp_settings = {
  \   'gopls': {
  \     'initialization_options': {
  \       'usePlaceholders': v:true,
  \     },
  \   },
  \ }


""
"" * prabirshrestha/asyncomplete.vim
""
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() . "\<cr>" : "\<cr>"

""
"" * vim-airline/vim-airline
""
let g:airline#extensions#tabline#enabled = 1
let g:airline_statusline_ontop = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_theme='violet' 
autocmd VimEnter * set laststatus=0
