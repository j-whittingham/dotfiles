" sdothum - 2016 (c) wtfpl

" Plugins
" ══════════════════════════════════════════════════════════════════════════════

" Plugin manager _______________________________________________________________

" ........................................................................ Setup
filetype off  " safe startup (vundle requirement)

" see https://github.com/junegunn/vim-plug
" :PlugInstall/PlugUpdate/PlugClean
" :PlugUpgrade (vim-plug)
call plug#begin('~/.vim/plugged')

" ....................................................................... System
let code  = { 'for' : ['c', 'cpp', 'haskell', 'lua', 'ruby', 'sh', 'snippets', 'vim'] }
let prose = { 'for' : ['draft', 'mail', 'markdown', 'note', 'wiki', 'html'] }

Plug 'Shougo/vimproc.vim', { 'do' : 'make' }
" Plug 'tpope/vim-scriptease'         " debugger
" Plug 'tpope/vim-dispatch'           " launch async shell command

" User Interface _______________________________________________________________

" ....................................................................... Layout
Plug 'junegunn/limelight.vim'         " hyperfocus highlighting
Plug 'bilalq/lite-dfm'                " distraction free mode
Plug 'TaDaa/vimade'                   " hyperfocus highlghting for buffers

" ......................................................................... Info
" Plug 'metakirby5/codi.vim'          " async evaluator
" Plug 'reedes/vim-wordy'             " word usage
Plug 'majutsushi/tagbar'              " ctags
Plug 'lvht/tagbar-markdown', prose    " markdown for tagbar
Plug 'bimlas/vim-eightheader'         " custom foldtext

" ....................................................................... Keymap
" Plug 'kana/vim-arpeggio'            " key chords
Plug 'tpope/vim-repeat'               " dot plugin
Plug 'tpope/vim-rsi'                  " readline keybindings

" ................................................................. Highlighting
" Plug 'JuliaEditorSupport/julia-vim' " julia programming language
" Plug 'markonm/traces.vim'           " ex pattern/range highlghting
" Plug 'romainl/vim-cool'             " auto clear search highlighting
Plug 'itchyny/vim-cursorword', prose  " word highlighting
Plug 'nathanaelkane/vim-indent-guides', { 'on' : 'IndentGuidesToggle' }  " colourized indent columns
Plug 'sheerun/vim-polyglot'           " multilingual highlighting
Plug 'machakann/vim-highlightedyank'  " yank highlghting

" Buffers ______________________________________________________________________

" ................................................................... Management
" Plug 'duff/vim-scratch'             " scratch buffer
" Plug 'simeji/winresizer'            " resize windows
Plug 'chrisbra/NrrwRgn'               " visual block buffer

" .............................................................. Version control
" Plug 'tpope/vim-fugitive'           " github wrapper
" Plug markwoodhall/vim-mercurial     " mercurial wrapper
Plug 'mhinz/vim-signify'              " vcs diff

" .................................................................... Hypertext
" Plug 'dyng/ctrlsf.vim'              " ctrl-shift-f clone
" Plug 'lervag/wiki'                  " vimwiki clone
Plug 'junegunn/fzf.vim', { 'dir': '~/.fzf', 'do': './install --all' }  " fuzzy finder
Plug 'Alok/notational-fzf-vim'        " fzf note search

" ...................................................................... History
Plug 'simnalamburt/vim-mundo', { 'on' : 'MundoToggle' }  " undo
Plug 'vim-scripts/YankRing.vim'       " paste (yank)

" ....................................................................... Linter
Plug 'w0rp/ale'                       " asynchronous lint engine

" Editing ______________________________________________________________________

" ................................................................... Navigation
" Plug 'wellle/targets.vim'           " text objects
Plug 'Konfekt/FastFold'               " update folds
Plug 'kshenoy/vim-signature'          " toggle marks
Plug 'justinmk/vim-sneak'             " jump to location

" ................................................................. Text objects
Plug 'tpope/vim-surround'             " pairwise c'hange, d'elete, y'ank
Plug 'kana/vim-textobj-entire'        " document
Plug 'kana/vim-textobj-fold'          " block
Plug 'kana/vim-textobj-function'      " language
Plug 'kana/vim-textobj-indent'        " with same indent level
Plug 'kana/vim-textobj-lastpat'       " last search pattern
Plug 'kana/vim-textobj-line'          " current line
Plug 'reedes/vim-textobj-quote'       " typographic characters
Plug 'kana/vim-textobj-user'          " dependency for vim-textobj-quote

" ................................................................... Formatting
Plug 'scrooloose/nerdcommenter'       " toggle comment
Plug 'junegunn/vim-easy-align'        " align text objects
Plug 'reedes/vim-pencil'              " dynamic paragraph formatting

" ................................................................... Completion
" Plug 'mattn/emmet-vim'              " html
Plug 'jiangmiao/auto-pairs'           " insert/delete pairs
Plug 'Shougo/neocomplete.vim'         " required by snippets
Plug 'Shougo/neosnippet.vim'          " snippets
Plug 'tpope/vim-endwise', code        " add 'end' statement
Plug 'reedes/vim-litecorrect', prose  " autocorrections

" Plugin completion ____________________________________________________________

" .................................................................... Configure
call plug#end()
unlet code prose

filetype plugin on
filetype indent on  " required
filetype on

" plugin.vim
