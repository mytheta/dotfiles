" --settings-------------------------------------------------------
nnoremap x "_x " 削除キーでyankしない
nnoremap d "_d
xnoremap p "_dP
set clipboard=unnamed " macのクリップボードとyankを共有
set showmatch " 括弧移動
set matchtime=1 " 時間短縮
set autoread " 開いているがvim上で変更のないファイルについて、外部で変更があった時に自動的に読み込む
set enc=utf8 " utf8
set fenc=utf-8 " utf8にエンコード
set expandtab " tabをスペース2にし、スペースに変換
set shiftwidth=0
set tabstop=2
set hidden " 保存されていないファイルがあるときでも別のファイルを開くことが出来る
set history=100 " コマンドラインの履歴を100件保存する
set hlsearch " 検索文字列をハイライトする
set ignorecase " 大文字と小文字を区別しない
set incsearch " インクリメンタルサーチを行う
set isk+=- " ハイフンをiskeywordに含める
set lazyredraw " fast
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
set laststatus=2 " ステータスラインを常に表示
set autoindent "改行時に前の行のインデントを継続する"

let mapleader = "\<Space>" " Spaceを割り当て

" --カーソル表示-------------------------------------------------------
if has('vim_starting')
    let &t_SI .= "\e[6 q"
    let &t_EI .= "\e[2 q"
    let &t_SR .= "\e[4 q"
endif


" --fzfのショートカットキー---------------------------------------------
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>l :BLines<CR>


" -- markdown settings-----------------------------------------------
autocmd BufRead,BufNewFile *.mkd  set filetype=markdown
autocmd BufRead,BufNewFile *.md  set filetype=markdown
" Need: kannokanno/previm
nnoremap <silent> <C-p> :PrevimOpen<CR> " Ctrl-pでプレビュー
" 自動で折りたたまないようにする
let g:vim_markdown_folding_disabled=1
let g:previm_enable_realtime = 1


" --lsp--------------------------------------------------------------
nmap <silent> <Leader>d :LspDefinition<CR>
nmap <silent> <Leader>r :LspRename<CR>
nmap <silent> <Leader>t :LspTypeDefinition<CR>
nmap <silent> <Leader>i :LspImplementation<CR>
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:asyncomplete_popup_delay = 200
let g:lsp_text_edit_enabled = 0


" --vim-plugin-------------------------------------------------------
call plug#begin('~/.vim/plugged')
    Plug 'prabirshrestha/async.vim'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'
    Plug 'mattn/vim-lsp-icons'

    Plug 'hrsh7th/vim-vsnip'
    Plug 'hrsh7th/vim-vsnip-integ'

    Plug 'justinmk/vim-dirvish'

    Plug  'tpope/vim-markdown'
    Plug  'kannokanno/previm'
    Plug  'tyru/open-browser.vim'

    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
call plug#end()
