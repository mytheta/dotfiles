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
" set list
" set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%
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
	Plug 'prabirshrestha/async.vim'
	Plug 'prabirshrestha/asyncomplete.vim'
	Plug 'prabirshrestha/asyncomplete-lsp.vim'
	Plug 'prabirshrestha/vim-lsp'
	Plug 'mattn/vim-lsp-settings'

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

	" 以下avante.nvimの設定
	" Deps
	Plug 'stevearc/dressing.nvim'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'MunifTanjim/nui.nvim'

	" Optional deps
	Plug 'hrsh7th/nvim-cmp'
	Plug 'nvim-tree/nvim-web-devicons' "or Plug 'echasnovski/mini.icons'
	Plug 'HakonHarnes/img-clip.nvim'
	Plug 'zbirenbaum/copilot.lua'

	" Yay, pass source=true if you want to build from source
	Plug 'yetone/avante.nvim', { 'branch': 'main', 'do': 'make' }
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

if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

""
"" * lsp
""
nmap <silent> <Space>d :LspDefinition<CR>
nmap <silent> rn :LspRename<CR>
nmap <silent> <Space>T :LspTypeDefinition<CR>
nmap <silent> <Space>i :LspImplementation<CR>
nmap <silent> <Space>a :LspCodeAction<CR>
nmap <silent> rr :LspReferences<CR>
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1 " Show diagnostics message to status line
let g:asyncomplete_popup_delay = 200

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
nmap <silent> <Space>t :TestNearest<CR>
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
"" * mattn/vim-goimports
""
let g:goimports = 1
let g:goimports_simplify = 1

""
"" * prabirshrestha/asyncomplete.vim
""
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() . "\<cr>" : "\<cr>"

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
"" * highlight
""
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight LineNr ctermbg=NONE guibg=NONE
highlight Folded ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE

""
"" * avante.nvim
""
autocmd! User avante.nvim 
lua << EOF
require('avante_lib').load()
require('copilot').setup({})
require('avante').setup({
	provider = "copilot",
    auto_suggestions_provider = "copilot",
	copilot = {
	  model = "gpt-4o-2024-05-13",
	  -- model = "gpt-4o-mini",
	  max_tokens = 4096,
	},
    -- 動作設定
    behaviour = {
      auto_suggestions = false,
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
      minimize_diff = true,
    },
    -- ウィンドウ設定
	windows = {
	  position = "right",
	  width = 30,
	  sidebar_header = {
	  	align = "center",
	  	rounded = false,
	  },
	  ask = {
	  	floating = true,
	  	start_insert = true,
	  	border = "rounded"
	  }
	},
})
EOF
